defmodule Vox.Format.VOX.Binary.Chunk.RGBA do
    use Tonic, optimize: true

    repeat :palette, 256 do
        uint8 :r
        uint8 :g
        uint8 :b
        uint8 :a
    end
end
