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
    for {line, y} <- word_grid |> String.split("\n", trim: true) |> Enum.with_index(),
        {char, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: %{},
        do: {{x, y}, char}
  end

  defp matches_pattern?(word_grid, {x, y}, pattern) do
    Enum.all?(pattern, fn {dx, dy, expected_char} ->
      Map.get(word_grid, {x + dx, y + dy}) === expected_char
    end)
  end

  defp list_of_char_positions(word_grid, char) do
    word_grid
    |> Map.filter(fn {_pos, c} -> c == char end)
    |> Map.keys()
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
end
