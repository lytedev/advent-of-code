defmodule Two do
  def bool_int(true), do: 1
  def bool_int(false), do: 0

  def part1(id_list) do
    id_list
    |> Stream.map(fn id ->
      id
      |> String.codepoints()
      |> Enum.reduce(%{}, fn l, acc -> Map.update(acc, l, 1, &(&1 + 1)) end)
      |> Map.values()
      |> MapSet.new()
    end)
    |> Enum.to_list()
    |> Enum.reduce([0, 0], fn s, [x, y] ->
      [x + bool_int(2 in s), y + bool_int(3 in s)]
    end)
    |> Enum.reduce(1, fn i, a -> a * i end)
  end

  def part2(id_list) do
    id_list
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
    |> permute_all_pairs()
    |> List.flatten()
    |> Enum.reduce_while("", fn {id1, id2}, _ ->
      case String.myers_difference(id1, id2) do
        [eq: p1, del: <<_x::size(8)>>, ins: <<_y::size(8)>>, eq: p2] -> {:halt, p1 <> p2}
        _ -> {:cont, ""}
      end
    end)
  end

  def permute_all_pairs([]), do: []
  def permute_all_pairs(list), do: [permute_pairs(list) | permute_all_pairs(tl(list))]

  def permute_pairs([]), do: []
  def permute_pairs([cur | rest]), do: Enum.map(rest, &{cur, &1})
end
