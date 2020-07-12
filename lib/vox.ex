defmodule Vox do
    @spec models(Vox.Data.t) :: [Vox.Model.t]
    def models(data), do: Vox.Data.models(data)

    @spec model(Vox.Data.t, Vox.Model.id) :: Vox.Model.t | nil
    def model(data, index) do
        case Vox.Data.impl(data, :model) do
            nil -> Enum.at(models(data), index)
            fun -> fun.(data, index)
        end
    end

    @spec model_count(Vox.Data.t) :: non_neg_integer
    def model_count(data) do
        case Vox.Data.impl(data, :model_count) do
            nil -> Enum.count(models(data))
            fun -> fun.(data)
        end
    end

    @spec voxel(Vox.Data.t, Vox.Model.id, Vox.Model.point) :: { :ok, Vox.Voxel.t | nil } | Vox.Model.error(Vox.Model.bounds_error | Vox.Model.unknown_error)
    def voxel(data, index, point) do
        case Vox.Data.impl(data, :voxel) do
            nil ->
                case Enum.at(models(data), index) do
                    nil -> { :error, { :model, :unknown } }
                    model -> Vox.Model.voxel(model, point)
                end
            fun -> fun.(data, index, point)
        end
    end

    @spec voxel(Vox.Data.t, Vox.Model.id, Vox.Model.point, Vox.Model.axis, Vox.Model.axis) :: { :ok, Vox.Voxel.t | nil } | Vox.Model.error(Vox.Model.bounds_error | Vox.Model.unknown_error)
    def voxel(data, index, x, y, z), do: voxel(data, index, { x, y, z })

    defmodule NoModelError do
        defexception [:data, :id]

        @impl Exception
        def exception({ data, id }) do
            %NoModelError{
                data: data,
                id: id
            }
        end

        @impl Exception
        def message(%{ id: id }), do: "no model with id: #{inspect id}"
    end

    @spec voxel!(Vox.Data.t, Vox.Model.id, Vox.Model.point) :: Vox.Voxel.t | nil | no_return
    def voxel!(data, index, point) do
        case voxel(data, index, point) do
            { :ok, result } -> result
            { :error, { :model, :unknown } } -> raise NoModelError, { data, index }
            { :error, { :model, :bounds } } -> raise Vox.Model.BoundsError, { model(data, index), point }
        end
    end

    @spec voxel!(Vox.Data.t, Vox.Model.id, Vox.Model.point, Vox.Model.axis, Vox.Model.axis) :: Vox.Voxel.t | nil | no_return
    def voxel!(data, index, x, y, z), do: voxel!(data, index, { x, y, z })
end
