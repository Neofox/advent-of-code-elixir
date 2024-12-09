defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    input = "2333133121414131402"

    result = part1(input)

    assert result === 1928
  end

  test "disk_map_to_block" do
    input = "12345"

    result =
      disk_map_to_block(input)
      |> Enum.join()

    assert result === "0..111....22222"

    input = "2333133121414131402"

    result =
      disk_map_to_block(input)
      |> Enum.join()

    assert result === "00...111...2...333.44.5555.6666.777.888899"
  end

  test "move file block" do
    input = "0..111....22222" |> String.graphemes()

    result = move_file_block(input)

    assert Enum.join(result) === "022111222......"
  end

  test "calculate checksum" do
    input = "0099811188827773336446555566.............." |> String.graphemes()

    result = calculate_checksum(input)

    assert result === 1928
  end

  test "part2" do
    input = "2333133121414131402"

    result = part2(input)

    assert result === 2858
  end
end
