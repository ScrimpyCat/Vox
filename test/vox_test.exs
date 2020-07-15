defmodule VoxTest do
    use ExUnit.Case
    doctest Vox

    def point({ w, h, d }, n), do: { rem(n, w), rem(div(n, w), h), rem(div(n, w * h), d) }

    describe "vox" do
        test "opening vox2x2x2-glass.vox" do
            data = File.read!("test/vox2x2x2-glass.vox")
            vox = Vox.Format.VOX.new(data)

            assert 1 == Vox.model_count(vox)
            model = Vox.model(vox, 0)
            assert [model] == Vox.models(vox)
            assert { 2, 2, 2 } == model.size
            assert Map.new(Enum.map(0..7, &({ point(model.size, &1), Vox.voxel!(vox, 0, point(model.size, &1)) }))) == Vox.model(vox, 0).voxels
            assert %Vox.Model.BoundsError{} = catch_error Vox.voxel!(vox, 0, 0, 0, 2)
            assert %Vox.NoModelError{} = catch_error Vox.voxel!(vox, 1, 0, 0, 0)

            solid = %Vox.Voxel{
                colour: %Vox.Colour{ r: 0.6, g: 0.8, b: 0.8 },
                material: %Vox.Material{
                    type: :diffuse,
                    properties: %{
                        "_att" => "0",
                        "_flux" => "0",
                        "_g0" => "-0.5",
                        "_g1" => "0.8",
                        "_gw" => "0.7",
                        "_ior" => "0.3",
                        "_ldr" => "0",
                        "_rough" => "0.1",
                        "_spec" => "0.5",
                        "_spec_p" => "0.5",
                        "_weight" => "1"
                    }
                }
            }
            glass = %Vox.Voxel{
                colour: %Vox.Colour{ r: 0.8, g: 0.0, b: 0.0 },
                material: %Vox.Material{
                    type: :glass,
                    properties: %{
                        "_att" => "0",
                        "_flux" => "0",
                        "_g0" => "-0.5",
                        "_g1" => "0.8",
                        "_gw" => "0.7",
                        "_ior" => "0.3",
                        "_ldr" => "0",
                        "_rough" => "0.1",
                        "_spec" => "0.5",
                        "_spec_p" => "0.5",
                        "_weight" => "0.86"
                    }
                }
            }

            assert solid == Vox.voxel!(vox, 0, 0, 0, 0)
            assert solid == Vox.voxel!(vox, 0, 1, 0, 0)
            assert solid == Vox.voxel!(vox, 0, 0, 0, 1)
            assert glass == Vox.voxel!(vox, 0, 1, 0, 1)
            assert solid == Vox.voxel!(vox, 0, 0, 1, 0)
            assert solid == Vox.voxel!(vox, 0, 1, 1, 0)
            assert solid == Vox.voxel!(vox, 0, 0, 1, 1)
            assert glass == Vox.voxel!(vox, 0, 1, 1, 1)

            transformed = Vox.transform(vox, :left, :bottom, :front)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 0)
            assert glass == Vox.voxel!(transformed, 0, 1, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 1)
            assert glass == Vox.voxel!(transformed, 0, 1, 1, 1)

            transformed = Vox.transform(transformed, :back, :right, :bottom)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 0)
            assert glass == Vox.voxel!(transformed, 0, 0, 0, 1)
            assert glass == Vox.voxel!(transformed, 0, 1, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 1)
            assert solid == Vox.voxel!(transformed, 0, 1, 1, 1)

            transformed = Vox.transform(vox, :back, :right, :bottom)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 0)
            assert glass == Vox.voxel!(transformed, 0, 0, 0, 1)
            assert glass == Vox.voxel!(transformed, 0, 1, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 1)
            assert solid == Vox.voxel!(transformed, 0, 1, 1, 1)

            transformed = Vox.transform(vox, :back, :bottom, :left)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 1, 0)
            assert glass == Vox.voxel!(transformed, 0, 0, 1, 1)
            assert glass == Vox.voxel!(transformed, 0, 1, 1, 1)

            transformed = Vox.transform(vox, :back, :bottom, :right)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 0, 1)
            assert solid == Vox.voxel!(transformed, 0, 1, 0, 1)
            assert glass == Vox.voxel!(transformed, 0, 0, 1, 0)
            assert glass == Vox.voxel!(transformed, 0, 1, 1, 0)
            assert solid == Vox.voxel!(transformed, 0, 0, 1, 1)
            assert solid == Vox.voxel!(transformed, 0, 1, 1, 1)
        end
    end
end
