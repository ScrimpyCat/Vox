defmodule Vox.Format.VOX.Binary.Type do
    @moduledoc false
    import Tonic

    type :nstring, fn data, name, endianness ->
        { buffer, data } = str(data, endianness)
        { { name, buffer }, data }
    end

    defp str(data, endianness) do
        { n, data } = u32(data, endianness)
        <<buffer :: binary-size(n), data :: bitstring>> = data
        { buffer, data }
    end

    defp u32(data, :little) do
        <<v :: integer-size(32)-unsigned-little, data :: bitstring>> = data
        { v, data }
    end
    defp u32(data, :big) do
        <<v :: integer-size(32)-unsigned-big, data :: bitstring>> = data
        { v, data }
    end
    defp u32(data, :native) do
        <<v :: integer-size(32)-unsigned-native, data :: bitstring>> = data
        { v, data }
    end

    type :dict, fn data, name, endianness ->
        { pairs, data } = u32(data, endianness)
        { dict, data } = get_pairs(data, endianness, pairs)

        { { name, dict }, data }
    end

    defp get_pairs(data, endianness, pairs, result \\ [])
    defp get_pairs(data, _, 0, result), do: { Enum.reverse(result), data }
    defp get_pairs(data, endianness, pairs, result) do
        { key, data } = str(data, endianness)
        { value, data } = str(data, endianness)

        get_pairs(data, endianness, pairs - 1, [{ key, value }|result])
    end

    type :rotation, fn <<
        non_zero_index_row_1 :: size(2),
        non_zero_index_row_2 :: size(2),
        sign_row_1 :: size(1),
        sign_row_2 :: size(1),
        sign_row_3 :: size(1),
        data :: bitstring
    >>, name, _ ->
        matrix = {
            row(non_zero_index_row_1, sign_row_1 * -1),
            row(non_zero_index_row_2, sign_row_2 * -1),
            row(0, sign_row_3 * -1)
        }

        { { name, matrix }, data }
    end

    defp row(0, value), do: { value, 0, 0 }
    defp row(1, value), do: { 0, value, 0 }
    defp row(2, value), do: { 0, 0, value }
end
