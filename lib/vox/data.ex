defprotocol Vox.Data do
    @type no_impl :: nil

    @type face :: :left | :right | :bottom | :top | :front | :back
    @type origin :: { face, face, face }

    @spec origin(t) :: origin
    def origin(data)

    @spec models(t) :: [Vox.Model.t]
    def models(data)

    @spec impl(t, :model) :: ((t, Vox.Model.id) -> Vox.Model.t | nil) | no_impl
    @spec impl(t, :model_count) :: (t -> non_neg_integer) | no_impl
    @spec impl(t, :voxel) :: ((t, Vox.Model.id, Vox.Model.axis, Vox.Model.axis, Vox.Model.axis) -> { :ok, Vox.Voxel.t | nil } | Vox.Model.error(Vox.Model.bounds_error | Vox.Model.unknown_error)) | no_impl
    def impl(data, op)
end
