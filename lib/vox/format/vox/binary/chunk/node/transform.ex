defmodule Vox.Format.VOX.Binary.Chunk.Node.Transform do
    use Tonic, optimize: true
    import Vox.Format.VOX.Binary.Type

    int32 :node_id
    dict :node_attributes
    int32 :child_node_id

    skip int32()

    int32 :layer_id
    uint32 :frame_count
    repeat :frames, get(:frame_count), do: dict :frame_attributes
end
