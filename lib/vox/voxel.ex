defmodule Vox.Voxel do
    @type t :: %__MODULE__{ colour: Vox.Colour.t, material: Vox.Material.t }

    defstruct [colour: %Vox.Colour{}, material: %Vox.Material{}]
end
