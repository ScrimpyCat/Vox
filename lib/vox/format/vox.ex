defmodule Vox.Format.VOX do
    @behaviour Vox.Format

    defstruct [models: [], palette: [], materials: %{}, scene: %{}]

    def new(data) do
        { data, _ } = Tonic.load(data, Vox.Format.VOX.Binary)

        create(data)
    end

    defp create({ { :header, _, _ }, { :main, data } }) do
        chunk(data)
    end

    defp chunk(data, vox \\ %__MODULE__{})
    defp chunk({ { :id, "MAIN" }, _, _, _, children }, vox) do
        Enum.reduce(children, vox, fn { child }, acc ->
            chunk(child, acc)
        end)
    end
    defp chunk({ { :id, "SIZE" }, _, _, { { :width, w }, { :height, h }, { :depth, d } }, _ }, vox) do
        %{ vox | models: [%Vox.Model{ size: { w, h, d } }|vox.models] }
    end
    defp chunk({ { :id, "XYZI" }, _, _, { _, { :voxel, voxels } }, _ }, vox = %{ models: [model|models] }) do
        %{ vox | models: [%{ model | voxels: Map.new(create_voxels(voxels, [])) }|models] }
    end
    defp chunk({ { :id, "RGBA" }, _, _, { { :palette, palette } }, _ }, vox) do
        { colours, _ } = Enum.reduce(palette, { %{}, 0 }, fn { { :r, r }, { :g, g }, { :b, b }, { :a, a } }, { colours, n } ->
            { Map.put(colours, n, %Vox.Colour{ r: r / 255, g: g / 255, b: b / 255, a: a / 255 }), n + 1 }
        end)
        %{ vox | palette: colours }
    end
    defp chunk({ { :id, "MATL" }, _, _, { { :id, id }, { :properties, properties } }, _ }, vox = %{ materials: materials }) do
        material = case properties do
            [{ "_type", "_diffuse" }|props] -> %Vox.Material{ type: :diffuse, properties: Map.new(props) }
            [{ "_type", "_metal" }|props] -> %Vox.Material{ type: :metal, properties: Map.new(props) }
            [{ "_type", "_glass" }|props] -> %Vox.Material{ type: :glass, properties: Map.new(props) }
            [{ "_type", "_emit" }|props] -> %Vox.Material{ type: :emissive, properties: Map.new(props) }
        end
        %{ vox | materials: Map.put(materials, id, material) }
    end
    defp chunk(_, vox), do: vox

    defp create_voxels([], voxels), do: voxels
    defp create_voxels([{ { :x, x }, { :y, y }, { :z, z }, { :colour_index, colour_index } }|data], voxels) do
        create_voxels(data, [{ { x, y, z }, %{ colour_index: colour_index } }|voxels])
    end

    def format?(<<"VOX ", _ :: binary>>), do: true
    def format?(_), do: false

    defimpl Vox.Data, for: __MODULE__ do
        def origin(_), do: { :left, :front, :bottom }

        def models(data), do: Enum.map(data.models, &format_model(&1, data))

        def impl(_, :model), do: &model/2
        def impl(_, :model_count), do: &model_count/1
        def impl(_, :voxel), do: &voxel/3
        def impl(_, _), do: nil

        def format_model(model, data) do
            voxels = Enum.map(model.voxels, fn { point, voxel } ->
                {
                    point,
                    format_voxel(voxel, data)
                }
            end)

            %{ model | voxels: Map.new(voxels) }
        end

        def format_voxel(%{ colour_index: index }, %{ palette: palette, materials: materials }) do
            %Vox.Voxel{
                colour: Map.get(palette, index, %Vox.Colour{}),
                material: Map.get(materials, index, %Vox.Material{})
            }
        end

        def model(data, id) do
            case Enum.at(data.models, id) do
                nil -> nil
                model -> format_model(model, data)
            end
        end

        def model_count(%{ models: models }), do: Enum.count(models)

        def voxel(data, id, point = { x, y, z }) do
            case Enum.at(data.models, id) do
                nil -> { :error, { :model, :unknown } }
                %{ size: { w, h, d } } when (x < 0) or (x >= w) or (y < 0) or (y >= h) or (z < 0) or (z >= d) -> { :error, { :model, :bounds } }
                %{ voxels: %{ ^point => voxel } } -> { :ok, format_voxel(voxel, data) }
                _ -> { :ok, nil }
            end
        end
    end
end
