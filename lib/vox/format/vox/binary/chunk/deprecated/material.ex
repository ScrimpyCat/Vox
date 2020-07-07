defmodule Vox.Format.VOX.Binary.Chunk.Deprecated.Material do
    use Tonic, optimize: true

    int32 :id
    int32 :type, fn
        { label, 0 } -> { label, :diffuse }
        { label, 1 } -> { label, :metal }
        { label, 2 } -> { label, :glass }
        { label, 3 } -> { label, :emissive }
        value -> value
    end
    float32 :weight
    chunk 4 do
        bit :plastic
        bit :roughness
        bit :specular
        bit :ior
        bit :attenuation
        bit :power
        bit :glow
        bit :is_total_power
    end

    repeat do: float32()
end
