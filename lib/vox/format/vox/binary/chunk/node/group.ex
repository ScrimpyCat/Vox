defmodule Vox.Format.VOX.Binary.Chunk.Node.Group do
    @moduledoc false
    use Tonic, optimize: true
    import Vox.Format.VOX.Binary.Type

    int32 :node_id
    dict :node_attributes
    uint32 :child_node_count
    repeat :child_nodes, get(:child_node_count), do: int32 :child_node_id
end
