defmodule AdventOfCode2018Test do
  use ExUnit.Case, async: true

  @doc "https://adventofcode.com/2018/day/1"
  test "Day 1" do
    input_stream =
      File.stream!("./inputs/one.txt", [:read])
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.map(&String.to_integer/1)

    assert One.part1(input_stream) == 416
    assert One.part2(input_stream) == 56752
  end

  @doc "https://adventofcode.com/2018/day/2"
  test "Day 2" do
    input_stream = File.stream!("./inputs/two.txt", [:read])

    assert Two.part1(input_stream) == 6696
    assert Two.part2(input_stream) == "bvnfawcnyoeyudzrpgslimtkj"
  end

  @tag :current_day
  @doc "https://adventofcode.com/2018/day/3"
  test "Day 3" do
    test_input =
      """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """
      |> String.split("\n", trim: true)

    # expected_result = MapSet.new([{4, 4}, {5, 4}, {4, 5}, {5, 5}])
    expected_result_part1 = 4
    expected_result_part2 = 3

    assert Three.part1(test_input) == expected_result_part1
    assert Three.part2(test_input) == expected_result_part2
  end
end
