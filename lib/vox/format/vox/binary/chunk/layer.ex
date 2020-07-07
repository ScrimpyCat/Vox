defmodule Vox.Format.VOX.Binary.Chunk.Layer do
    use Tonic, optimize: true
    import Vox.Format.VOX.Binary.Type

    uint32 :id
    dict :attributes
    skip int32()
end
