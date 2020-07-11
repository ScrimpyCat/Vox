defmodule Vox.Material do
    @type t :: %__MODULE__{ type: atom, properties: map }

    defstruct [type: :diffuse, properties: %{}]
end
