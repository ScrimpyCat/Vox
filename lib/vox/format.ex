defmodule Vox.Format do
    @moduledoc """
      Behaviour for representing different voxel formats.
    """

    @doc """
      Implement the behaviour creating interfaceable voxel data from an
      underlying voxel format.

      Return the interfaceable voxel data.
    """
    @callback new(any) :: Vox.Data.t

    @doc """
      Implement the behaviour for determining whether the data is in the
      format by this behaviour.

      If the data is in the format of this behaviour then return `true`,
      otherwise return `false`.
    """
    @callback format?(any) :: boolean
end
