defmodule Vox.Format.VOX.Binary.Chunk.Node.Shape do
    use Tonic, optimize: true
    import Vox.Format.VOX.Binary.Type

    int32 :node_id
    dict :node_attributes
    uint32 :model_count
    repeat :models, get(:model_count) do
        int32 :model_id
        dict :model_attributes
    end
end
