defmodule Vox.Model do
    @moduledoc """
      A voxel model.
    """
    @type bounds_error :: :bounds
    @type unknown_error :: :unknown
    @type error(type) :: { :error, { :model, type } }

    @type id :: non_neg_integer
    @type axis :: non_neg_integer
    @type point :: { axis, axis, axis }

    @type t :: %__MODULE__{ size: point, voxels: %{ point => Vox.Voxel.t } }

    defstruct [size: { 0, 0, 0 }, voxels: %{}]

    @doc """
      Get the width of the model.
    """
    @spec width(t) :: axis
    def width(%{ size: { w, _, _ } }), do: w

    @doc """
      Get the height of the model.
    """
    @spec width(t) :: axis
    def height(%{ size: { _, h, _ } }), do: h

    @doc """
      Get the depth of the model.
    """
    @spec width(t) :: axis
    def depth(%{ size: { _, _, d } }), do: d

    @doc """
      Get a voxel in the model.
    """
    @spec voxel(t, point) :: { :ok, Vox.Voxel.t | nil } | error(bounds_error)
    def voxel(%{ size: { w, h, d } }, { x, y, z }) when (x < 0) or (x >= w) or (y < 0) or (y >= h) or (z < 0) or (z >= d), do: { :error, { :model, :bounds } }
    def voxel(%{ voxels: voxels }, point), do: { :ok, voxels[point] }

    @doc """
      Get a voxel in the model.
    """
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

    @doc """
      Get a voxel in the model.
    """
    @spec voxel!(t, point) :: Vox.Voxel.t | nil | no_return
    def voxel!(model, point) do
        case voxel(model, point) do
            { :ok, result } -> result
            { :error, { :model, type } } -> raise BoundsError, { model, point }
        end
    end

    @doc """
      Get a voxel in the model.
    """
    @spec voxel!(t, axis, axis, axis) :: Vox.Voxel.t | nil | no_return
    def voxel!(model, x, y, z), do: voxel!(model, { x, y, z })
end
