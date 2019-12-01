defmodule One do
  def part1(list, initial_freq \\ 0), do: initial_freq + Enum.sum(list)

  def part2(list, initial_freq \\ 0) do
    list
    |> Stream.cycle()
    |> Enum.reduce_while({initial_freq, MapSet.new([initial_freq])}, &part2_reducer/2)
  end

  def part2_reducer(i, {last, set}) do
    case (i + last) in set do
      true -> {:halt, i + last}
      _ -> {:cont, {i + last, MapSet.put(set, i + last)}}
    end
  end
end
