defmodule Vox.Format do
    @callback new(any) :: any

    @callback format?(any) :: boolean
end
