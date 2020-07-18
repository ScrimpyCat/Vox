defmodule Vox.Format.VOX.Binary.Chunk.XYZI do
    @moduledoc false
    use Tonic, optimize: true

    uint32 :voxel_count
    repeat :voxel, get(:voxel_count) do
        uint8 :x
        uint8 :y
        uint8 :z
        uint8 :colour_index
    end
end
