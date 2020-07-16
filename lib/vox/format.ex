defmodule Vox.Format do
    @callback new(any) :: Vox.Data.t

    @callback format?(any) :: boolean
end
