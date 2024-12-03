defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    result = part1(input)

    assert result === 2
  end

  test "part2" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    result = part2(input)
    assert result === 4

    input_custom = """
    3 6 7 9 11 8
    84 86 85 82 81 79 76 75
    1 3 1 4 6 7
    1 5 7 8 9
    22 20 1 18 16
    10 7 5 4 4 3
    9 8 7 6 5 4 9
    """

    result_custom = part2(input_custom)

    assert result_custom === 7
  end
end
