defmodule IdenticonRe do
  def hash_input(input) do
    hash =
      :md5
      |> :crypto.hash(input)
      |> :binary.bin_to_list()

      %Identicon.Image{hex: hash}
  end

  def pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _]} = image
    %Identicon.Image{image | color: [r, g, b]}
  end

  def build_grid(image) do
    list =
    image.hex
    |> Enum.chunk_every(3)
    |> List.delete_at(-1)
    |> Enum.map(&IdenticonRe.mirror_row(&1))
    |> List.flatten()
    |> Enum.with_index()

    %Identicon.Image{image | grid: list}

  end

  def mirror_row(row) do
    [data1, data2, _tail] = row
    row ++ [data2, data1]
  end

  def filter_add_cells(image) do
    grid =
      Enum.filter(image.grid, fn {value, _index} -> rem(value, 2) == 0 end)

      %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn{_value, index} ->
      top_left = {rem(index, 5) * 50, div(index, 5) * 50}
      bottom_right = {rem(index, 5) * 50 + 50, div(index, 5) * 50 + 50}
      {top_left, bottom_right} end)

      %Identicon.Image{image | pixel_map: pixel_map}
  end

def build_image(%Identicon.Image{color: color, pixel_map: pixel_map},name) do
  img = :egd.create(250, 250)
  fill = :egd.color({Enum.at(color, 0), Enum.at(color, 1), Enum.at(color, 2)})
  Enum.each(pixel_map, fn {start, stop} ->
    :egd.filledRectangle(img, start, stop, fill) end)
 :egd.save(:egd.render(img), "#{name}.png")
end

def create_image() do
  name =
    IO.gets("")
    |> to_string()
    |> String.trim()

    name
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_add_cells()
    |> build_pixel_map()
    |> build_image(name)
end
end
