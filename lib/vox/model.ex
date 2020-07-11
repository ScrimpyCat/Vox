defmodule Vox.Model do
    @type bounds_error :: :bounds
    @type unknown_error :: :unknown
    @type error(type) :: { :error, { :model, type } }

    @type id :: non_neg_integer
    @type axis :: non_neg_integer
    @type point :: { axis, axis, axis }

    @type t :: %__MODULE__{ size: point, voxels: %{ point => Vox.Voxel.t } }

    defstruct [size: { 0, 0, 0 }, voxels: %{}]

    @spec width(t) :: axis
    def width(%{ size: { w, _, _ } }), do: w

    @spec width(t) :: axis
    def height(%{ size: { _, h, _ } }), do: h

    @spec width(t) :: axis
    def depth(%{ size: { _, _, d } }), do: d

    @spec voxel(t, point) :: { :ok, Vox.Voxel.t | nil } | error(bounds_error)
    def voxel(%{ size: { w, h, d } }, { x, y, z }) when (x < 0) or (x >= w) or (y < 0) or (y >= h) or (z < 0) or (z >= d), do: { :error, { :model, :bounds } }
    def voxel(%{ voxels: voxels }, point), do: { :ok, voxels[point] }

    @spec voxel(t, axis, axis, axis) :: { :ok, Vox.Voxel.t | nil } | error(bounds_error)
    def voxel(model, x, y, z), do: voxel(model, { x, y, z })

    defmodule BoundsError do
        defexception [:point, :model]

        @impl Exception
        def exception({ model, point }) do
            %BoundsError{
                point: point,
                model: model
            }
        end

        @impl Exception
        def message(%{ model: %{ size: size }, point: point }), do: "(#{inspect point}) outside of model's bounds: #{inspect size}"
    end

    @spec voxel!(t, point) :: Vox.Voxel.t | nil | no_return
    def voxel!(model, point) do
        case voxel(model, point) do
            { :ok, result } -> result
            { :error, { :model, type } } -> raise BoundsError, { model, point }
        end
    end

    @spec voxel!(t, axis, axis, axis) :: Vox.Voxel.t | nil | no_return
    def voxel!(model, x, y, z), do: voxel!(model, { x, y, z })
end
