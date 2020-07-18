defmodule Vox.Format.VOX.Binary.Chunk.Size do
    @moduledoc false
    use Tonic, optimize: true

    uint32 :width
    uint32 :height
    uint32 :depth
end
