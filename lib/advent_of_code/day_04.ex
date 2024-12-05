defmodule AdventOfCode.Day04 do
  @directions [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1},
    {1, 1},
    {-1, 1},
    {1, -1},
    {-1, -1}
  ]

  def part1(word_puzzle) do
    word_grid = make_word_grid(word_puzzle)

    list_of_char_positions(word_grid, "X")
    |> look_for_xmas(word_grid)
    |> Enum.sum()
  end

  def part2(word_puzzle) do
    word_grid = make_word_grid(word_puzzle)

    list_of_char_positions(word_grid, "A")
    |> look_for_mas_cross(word_grid)
    |> Enum.sum()
  end

  defp make_word_grid(word_grid) do
    word_grid
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row) |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Map.new()
  end

  defp matches_pattern?(word_grid, {x, y}, pattern) do
    Enum.all?(pattern, fn {dx, dy, expected_char} ->
      has_char_at?(word_grid, {x + dx, y + dy}, expected_char)
    end)
  end

  defp list_of_char_positions(word_grid, char) do
    word_grid
    |> Enum.filter(fn {_pos, c} -> c == char end)
    |> Enum.map(fn {pos, _c} -> pos end)
  end

  @spec look_for_xmas(list({integer(), integer()}), map()) :: list(integer())
  defp look_for_xmas(x_positions, word_grid) do
    for {dx, dy} <- @directions do
      pattern = [
        {dx, dy, "M"},
        {2 * dx, 2 * dy, "A"},
        {3 * dx, 3 * dy, "S"}
      ]

      Enum.count(x_positions, &matches_pattern?(word_grid, &1, pattern))
    end
  end

  @spec look_for_mas_cross(list({integer(), integer()}), map()) :: list(integer())
  defp look_for_mas_cross(a_positions, word_grid) do
    patterns = [
      [{-1, 1, "M"}, {1, 1, "M"}, {-1, -1, "S"}, {1, -1, "S"}],
      [{-1, -1, "M"}, {1, -1, "M"}, {-1, 1, "S"}, {1, 1, "S"}],
      [{-1, -1, "S"}, {-1, 1, "S"}, {1, -1, "M"}, {1, 1, "M"}],
      [{1, -1, "S"}, {1, 1, "S"}, {-1, -1, "M"}, {-1, 1, "M"}]
    ]

    for pattern <- patterns do
      Enum.count(a_positions, &matches_pattern?(word_grid, &1, pattern))
    end
  end

  defp has_char_at?(word_grid, pos, char) do
    Map.get(word_grid, pos) == char
  end
end
