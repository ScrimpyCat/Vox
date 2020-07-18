defmodule Vox.Format.VOX.Binary.Chunk do
    @moduledoc false
    use Tonic, optimize: true

    string :id, length: 4
    uint32 :size
    uint32 :child_size

    chunk get(:size) do
        on get(:id) do
            "MAIN" -> spec Vox.Format.VOX.Binary.Chunk.Main
            "PACK" -> spec Vox.Format.VOX.Binary.Chunk.Pack
            "SIZE" -> spec Vox.Format.VOX.Binary.Chunk.Size
            "XYZI" -> spec Vox.Format.VOX.Binary.Chunk.XYZI
            "RGBA" -> spec Vox.Format.VOX.Binary.Chunk.RGBA
            "MATT" -> spec Vox.Format.VOX.Binary.Chunk.Deprecated.Material
            "nTRN" -> spec Vox.Format.VOX.Binary.Chunk.Node.Transform
            "nGRP" -> spec Vox.Format.VOX.Binary.Chunk.Node.Group
            "nSHP" -> spec Vox.Format.VOX.Binary.Chunk.Node.Shape
            "MATL" -> spec Vox.Format.VOX.Binary.Chunk.Material
            "LAYR" -> spec Vox.Format.VOX.Binary.Chunk.Layer
            "rOBJ" -> spec Vox.Format.VOX.Binary.Chunk.RObj
            _ -> skip group(:unknown)
        end
    end

    chunk get(:child_size) do
        repeat do
            spec Vox.Format.VOX.Binary.Chunk
        end
    end
end
