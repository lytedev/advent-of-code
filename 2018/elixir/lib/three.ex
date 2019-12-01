defmodule Three do
  @dimension_parser ~r/\#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/

  def part1(input_stream) do
    input_stream
    |> Stream.map(&parse_dimensions/1)
    |> Stream.map(&points_in_square/1)
    |> Enum.to_list()
    |> Enum.reduce({MapSet.new([]), MapSet.new([])}, &intersecting_squares/2)
    |> elem(1)
    |> MapSet.to_list()
    |> length()
  end

  def parse_dimensions(str) do
    l = Regex.run(@dimension_parser, str)
    [id, x, y, w, h] = l |> tl() |> Enum.map(&String.to_integer/1)
    {id, x, y, w, h}
  end

  def points_in_square({_, x, y, w, h}) do
    x..(x + w - 1)
    |> Enum.reduce([], fn x, x_set ->
      y..(y + h - 1)
      |> Enum.reduce(x_set, fn y, xy_set ->
        [{x, y} | xy_set]
      end)
    end)
  end

  def intersecting_squares(square_set, {set, intersects}) do
    square_set
    |> Enum.reduce({set, intersects}, fn pos, {set, intersects} ->
      case MapSet.member?(set, pos) do
        true -> {set, MapSet.put(intersects, pos)}
        _ -> {MapSet.put(set, pos), intersects}
      end
    end)
  end

  def intersecting_squares2({id, square_set}, {set, intersects}) do
    square_set
    |> Enum.reduce({set, intersects}, fn pos, {set, intersects} ->
      case MapSet.member?(set, pos) do
        true -> {set, MapSet.put(intersects, pos)}
        _ -> {MapSet.put(set, pos), intersects}
      end
    end)
  end

  # parse input lines
  # for each set of dimensions, check each point in the square
  #   if the point has been recorded already, remove both ids from the set

  def part2(input_stream) do
    square_data =
      input_stream
      |> Stream.map(&parse_dimensions/1)

    square_id_set =
      square_data
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()
      |> MapSet.new()

    square_data
    |> Enum.map(&{elem(&1, 0), points_in_square(&1)})
    |> Enum.reduce({MapSet.new([]), square_id_set}, fn {id, points}, acc -> intersecting_squares2({id, points}, ))
    |> elem(1)
    |> MapSet.to_list()
    |> length()
  end
end
