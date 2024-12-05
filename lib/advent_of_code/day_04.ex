defmodule AdventOfCode.Day04 do
  @directions [
    # Right
    {1, 0},
    # Left
    {-1, 0},
    # Down
    {0, 1},
    # Up
    {0, -1},
    # Diagonal down-right
    {1, 1},
    # Diagonal down-left
    {-1, 1},
    # Diagonal up-right
    {1, -1},
    # Diagonal up-left
    {-1, -1}
  ]

  def part1(word_puzzle) do
    word_grid = make_word_grid(word_puzzle)
    x_positions = list_of_char_positions(word_grid, "X")

    look_for_xmas(x_positions, word_grid)
  end

  def part2(word_puzzle) do
    word_grid = make_word_grid(word_puzzle)
    a_positions = list_of_char_positions(word_grid, "A")

    look_for_mas_cross(a_positions, word_grid)
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
      pos = {x + dx, y + dy}
      has_char_at?(word_grid, pos, expected_char)
    end)
  end

  defp list_of_char_positions(word_grid, char) do
    word_grid
    |> Enum.filter(fn {_pos, c} -> c == char end)
    |> Enum.map(fn {pos, _c} -> pos end)
  end

  @spec look_for_xmas(list({integer(), integer()}), map()) :: integer()
  defp look_for_xmas(x_positions, word_grid) do
    Enum.map(@directions, fn {dx, dy} ->
      pattern = [
        {dx, dy, "M"},
        {2 * dx, 2 * dy, "A"},
        {3 * dx, 3 * dy, "S"}
      ]

      Enum.count(x_positions, fn pos ->
        matches_pattern?(word_grid, pos, pattern)
      end)
    end)
    |> Enum.sum()
  end

  @spec look_for_mas_cross(list({integer(), integer()}), map()) :: integer()
  defp look_for_mas_cross(a_positions, word_grid) do
    patterns = [
      # Top
      [
        {-1, 1, "M"},
        {1, 1, "M"},
        {-1, -1, "S"},
        {1, -1, "S"}
      ],
      # Bottom
      [
        {-1, -1, "M"},
        {1, -1, "M"},
        {-1, 1, "S"},
        {1, 1, "S"}
      ],
      # Left
      [
        {-1, -1, "S"},
        {-1, 1, "S"},
        {1, -1, "M"},
        {1, 1, "M"}
      ],
      # Right
      [
        {1, -1, "S"},
        {1, 1, "S"},
        {-1, -1, "M"},
        {-1, 1, "M"}
      ]
    ]

    Enum.map(a_positions, fn pos ->
      Enum.count(patterns, fn pattern ->
        matches_pattern?(word_grid, pos, pattern)
      end)
    end)
    |> Enum.sum()
  end

  defp has_char_at?(word_grid, pos, char) do
    Map.get(word_grid, pos) == char
  end
end
