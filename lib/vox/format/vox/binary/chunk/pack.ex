defmodule Vox.Format.VOX.Binary.Chunk.Pack do
    use Tonic, optimize: true

    uint32 :model_count
end
