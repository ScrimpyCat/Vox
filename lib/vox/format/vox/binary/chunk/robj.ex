defmodule Vox.Format.VOX.Binary.Chunk.RObj do
    use Tonic, optimize: true
    import Vox.Format.VOX.Binary.Type

    dict :properties
end
