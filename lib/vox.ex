defmodule Vox do
    @moduledoc """
      Functions for working with voxels.
    """

    @doc """
      Create vox data from some data.
    """
    @spec new(any) :: Vox.Data.t | nil
    def new(data), do: new(data, format(data))

    @doc """
      Create vox data from some data that should be loaded by the specified
      module.
    """
    @spec new(any, module) :: Vox.Data.t
    @spec new(any, nil) :: nil
    def new(_, nil), do: nil
    def new(data, module), do: module.new(data)

    @default_formats [
        Vox.Format.VOX
    ]
    @doc """
      Get the format that will handle this voxel data format.
    """
    @spec format(any) :: module | nil
    def format(data), do: Enum.find(Application.get_env(:vox, :formats, []), &(&1.format?(data))) || Enum.find(@default_formats, &(&1.format?(data)))

    @doc """
      Get all the models represented by the voxel data.
    """
    @spec models(Vox.Data.t) :: [Vox.Model.t]
    def models(data), do: Vox.Data.models(data)

    @doc """
      Get a specific model represented by the voxel data.
    """
    @spec model(Vox.Data.t, Vox.Model.id) :: Vox.Model.t | nil
    def model(data, index) do
        case Vox.Data.impl(data, :model) do
            nil -> Enum.at(models(data), index)
            fun -> fun.(data, index)
        end
    end

    @doc """
      Get the number of models represented by the voxel data.
    """
    @spec model_count(Vox.Data.t) :: non_neg_integer
    def model_count(data) do
        case Vox.Data.impl(data, :model_count) do
            nil -> Enum.count(models(data))
            fun -> fun.(data)
        end
    end

    @doc """
      Get a voxel from a model in the voxel data.
    """
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

    @doc """
      Get a voxel from a model in the voxel data.
    """
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

    @doc """
      Get a voxel from a model in the voxel data.
    """
    @spec voxel!(Vox.Data.t, Vox.Model.id, Vox.Model.point) :: Vox.Voxel.t | nil | no_return
    def voxel!(data, index, point) do
        case voxel(data, index, point) do
            { :ok, result } -> result
            { :error, { :model, :unknown } } -> raise NoModelError, { data, index }
            { :error, { :model, :bounds } } -> raise Vox.Model.BoundsError, { model(data, index), point }
        end
    end

    @doc """
      Get a voxel from a model in the voxel data.
    """
    @spec voxel!(Vox.Data.t, Vox.Model.id, Vox.Model.point, Vox.Model.axis, Vox.Model.axis) :: Vox.Voxel.t | nil | no_return
    def voxel!(data, index, x, y, z), do: voxel!(data, index, { x, y, z })

    @doc """
      Transform the voxel data so it's coordinate system is re-orientated.
    """
    @spec transform(Vox.Data.t, Vox.Data.origin) :: Vox.Data.t
    def transform(data, origin), do: Vox.Transform.new(data, origin)

    @doc """
      Transform the voxel data so it's coordinate system is re-orientated.
    """
    @spec transform(Vox.Data.t, Vox.Data.face, Vox.Data.face, Vox.Data.face) :: Vox.Data.t
    def transform(data, x, y, z), do: transform(data, { x, y, z })
end
