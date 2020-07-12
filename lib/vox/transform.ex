defmodule Vox.Transform do
    defstruct [:origin, :data]

    @type t :: %__MODULE__{ data: Vox.Data.t, origin: Vox.Data.origin }

    @side_x [:left, :right]
    @side_y [:bottom, :top]
    @side_z [:front, :back]

    @spec new(Vox.Data.t, Vox.Data.origin) :: t
    def new(data, origin), do: %__MODULE__{ data: data, origin: origin }

    def transform(a, b) do
        { x, w } = transform_w(a, b)
        { y, h } = transform_h(a, b)
        { z, d } = transform_d(a, b)
        { [w, h, d], { x, y, z } }
    end

    defp get_side(a) when a in @side_x, do: @side_x
    defp get_side(a) when a in @side_y, do: @side_y
    defp get_side(a) when a in @side_z, do: @side_z

    defp with_side([a, b], { x, _, _ }) when x in [a, b], do: { 0, x }
    defp with_side([a, b], { _, y, _ }) when y in [a, b], do: { 1, y }
    defp with_side([a, b], { _, _, z }) when z in [a, b], do: { 2, z }

    defp transform_w({ x, _, _ }, { x, _, _ }), do: { 0, &resolve_nop/2 }
    defp transform_w({ x1, _, _ }, { x2, _, _ }) when ((x1 in @side_x and x2 in @side_x) or (x1 in @side_y and x2 in @side_y) or (x1 in @side_z and x2 in @side_z)), do: { 0, &resolve_w/2 }
    defp transform_w(old, { x2, _, _ }) do
        new_side = get_side(x2)
        case with_side(new_side, old) do
            { n, ^x2 } -> { n, &resolve_nop/2 }
            { n, _ } -> { n, &resolve_n(&1, &2, n) }
        end
    end

    defp transform_h({ _, y, _ }, { _, y, _ }), do: { 1, &resolve_nop/2 }
    defp transform_h({ _, y1, _ }, { _, y2, _ }) when ((y1 in @side_x and y2 in @side_x) or (y1 in @side_y and y2 in @side_y) or (y1 in @side_z and y2 in @side_z)), do: { 1, &resolve_h/2 }
    defp transform_h(old, { _, y2, _ }) do
        new_side = get_side(y2)
        case with_side(new_side, old) do
            { n, ^y2 } -> { n, &resolve_nop/2 }
            { n, _ } -> { n, &resolve_n(&1, &2, n) }
        end
    end

    defp transform_d({ _, _, z }, { _, _, z }), do: { 2, &resolve_nop/2 }
    defp transform_d({ _, _, z1 }, { _, _, z2 }) when ((z1 in @side_x and z2 in @side_x) or (z1 in @side_y and z2 in @side_y) or (z1 in @side_z and z2 in @side_z)), do: { 2, &resolve_d/2 }
    defp transform_d(old, { _, _, z2 }) do
        new_side = get_side(z2)
        case with_side(new_side, old) do
            { n, ^z2 } -> { n, &resolve_nop/2 }
            { n, _ } -> { n, &resolve_n(&1, &2, n) }
        end
    end

    @axes [x: 0, y: 1, z: 2]
    for { x, xi } <- @axes, { y, yi } <- @axes, { z, zi } <- @axes, (x != y) and (x != z) and (y != z) do
        def swizzle({ x, y, z }, unquote(Macro.escape({ xi, yi, zi }))), do: { unquote({ x, [], nil }), unquote({ y, [], nil }), unquote({ z, [], nil }) }
    end

    def resolve(point, size, [fun|ops]), do: resolve(fun.(point, size), size, ops)
    def resolve(point, _, []), do: point

    defp resolve_nop(point, _), do: point

    defp resolve_n(point, size, 0), do: resolve_w(point, size)
    defp resolve_n(point, size, 1), do: resolve_h(point, size)
    defp resolve_n(point, size, 2), do: resolve_d(point, size)

    defp resolve_w({ x, y, z }, { w, _, _ }), do: { (w - x) - 1, y, z }

    defp resolve_h({ x, y, z }, { _, h, _ }), do: { x, (h - y) - 1, z }

    defp resolve_d({ x, y, z }, { _, _, d }), do: { x, y, (d - z) - 1 }

    defimpl Vox.Data, for: __MODULE__ do
        def origin(%{ origin: origin }), do: origin

        def models(%{ origin: origin, data: data }) do
            { transformations, order } = Vox.Transform.transform(Vox.Data.origin(data), origin)

            Vox.Data.models(data)
            |> Enum.map(fn model = %{ size: size } ->
                voxels = Enum.map(model.voxels, fn { point, voxel } ->
                    { Vox.Transform.swizzle(Vox.Transform.resolve(point, size, transformations), order), voxel }
                end)

                %{ model | size: Vox.Transform.swizzle(size, order), voxels: Map.new(voxels) }
            end)
        end

        def impl(_, _), do: nil
    end
end
