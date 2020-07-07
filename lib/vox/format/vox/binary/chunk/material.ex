defmodule Vox.Format.VOX.Binary.Chunk.Material do
    use Tonic, optimize: true
    import Vox.Format.VOX.Binary.Type

    uint32 :id
    dict :properties
end
