defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

    result = part1(input)

    assert result === 161
  end

  test "part2" do
    input = """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

    result = part2(input)

    assert result === 48

    custom_input = """
    mul(2,3) don't()mul(4,5)do() mul(6,7) don't()mul(8,9)do()
    """

    result_custom = part2(custom_input)

    assert result_custom === 48
  end
end
