defmodule Vox.Colour do
    @type t :: %__MODULE__{ r: float, g: float, b: float, a: float }

    defstruct [r: 0.0, g: 0.0, b: 0.0, a: 1.0]
end
