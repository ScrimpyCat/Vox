defprotocol Vox.Data do
    @moduledoc """
      Generic interface for voxel data.
    """
    @type no_impl :: nil

    @type face :: :left | :right | :bottom | :top | :front | :back
    @type origin :: { face, face, face }

    @doc """
      Gets the orientation of the coordinate system the voxel data uses.
    """
    @spec origin(t) :: origin
    def origin(data)

    @doc """
      Gets all the models represented by the voxel data
    """
    @spec models(t) :: [Vox.Model.t]
    def models(data)

    @doc """
      Get the implementation for any optional functions.
    """
    @spec impl(t, :model) :: ((t, Vox.Model.id) -> Vox.Model.t | nil) | no_impl
    @spec impl(t, :model_count) :: (t -> non_neg_integer) | no_impl
    @spec impl(t, :voxel) :: ((t, Vox.Model.id, Vox.Model.axis, Vox.Model.axis, Vox.Model.axis) -> { :ok, Vox.Voxel.t | nil } | Vox.Model.error(Vox.Model.bounds_error | Vox.Model.unknown_error)) | no_impl
    def impl(data, op)
end
