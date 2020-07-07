defmodule Vox.Format.VOX.Binary do
    use Tonic, optimize: true

    endian :little
    group :header do
        string :magic, length: 4
        uint32 :version
    end

    on get(fn [[header: { :header, { :magic, "VOX " }, { :version, version } }]] ->
        version
    end) do
        150 ->
            group :main do
                spec Vox.Format.VOX.Binary.Chunk
            end
    end
end
