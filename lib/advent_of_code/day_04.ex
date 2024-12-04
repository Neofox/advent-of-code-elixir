defmodule AdventOfCode.Day04 do
  def part1(word_puzzle) do
    word_grid = make_word_grid(word_puzzle)

    x_positions =
      word_grid
      |> list_of_char_positions("X")

    look_for_xmas(x_positions, word_grid) |> Enum.sum()
  end

  def part2(word_puzzle) do
    word_grid = make_word_grid(word_puzzle)

    a_positions = word_grid |> list_of_char_positions("A")

    look_for_mas_cross(a_positions, word_grid) |> Enum.sum()
  end

  defp make_word_grid(word_grid) do
    word_grid
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row) |> Enum.map(fn {char, x} -> {char, {x, y}} end)
    end)
  end

  defp list_of_char_positions(word_grid, char) do
    word_grid
    |> Enum.filter(fn {c, _} -> c == char end)
    |> Enum.map(fn {_, {x, y}} -> {x, y} end)
  end

  defp look_for_xmas(x_positions, word_grid) do
    x_positions
    |> Enum.map(fn {x, y} ->
      [
        # Right
        has_char_at?({x + 1, y}, "M", word_grid) and
          has_char_at?({x + 2, y}, "A", word_grid) and
          has_char_at?({x + 3, y}, "S", word_grid),

        # Left
        has_char_at?({x - 1, y}, "M", word_grid) and
          has_char_at?({x - 2, y}, "A", word_grid) and
          has_char_at?({x - 3, y}, "S", word_grid),

        # Down
        has_char_at?({x, y + 1}, "M", word_grid) and
          has_char_at?({x, y + 2}, "A", word_grid) and
          has_char_at?({x, y + 3}, "S", word_grid),

        # Up
        has_char_at?({x, y - 1}, "M", word_grid) and
          has_char_at?({x, y - 2}, "A", word_grid) and
          has_char_at?({x, y - 3}, "S", word_grid),

        # Diagonal down-right
        has_char_at?({x + 1, y + 1}, "M", word_grid) and
          has_char_at?({x + 2, y + 2}, "A", word_grid) and
          has_char_at?({x + 3, y + 3}, "S", word_grid),

        # Diagonal down-left
        has_char_at?({x - 1, y + 1}, "M", word_grid) and
          has_char_at?({x - 2, y + 2}, "A", word_grid) and
          has_char_at?({x - 3, y + 3}, "S", word_grid),

        # Diagonal up-right
        has_char_at?({x + 1, y - 1}, "M", word_grid) and
          has_char_at?({x + 2, y - 2}, "A", word_grid) and
          has_char_at?({x + 3, y - 3}, "S", word_grid),

        # Diagonal up-left
        has_char_at?({x - 1, y - 1}, "M", word_grid) and
          has_char_at?({x - 2, y - 2}, "A", word_grid) and
          has_char_at?({x - 3, y - 3}, "S", word_grid)
      ]
      |> Enum.count(& &1)
    end)
  end

  defp look_for_mas_cross(a_positions, word_grid) do
    a_positions
    |> Enum.map(fn {x, y} ->
      [
        # Top
        has_char_at?({x - 1, y + 1}, "M", word_grid) and
          has_char_at?({x + 1, y + 1}, "M", word_grid) and
          has_char_at?({x - 1, y - 1}, "S", word_grid) and
          has_char_at?({x + 1, y - 1}, "S", word_grid),

        # Bottom
        has_char_at?({x - 1, y - 1}, "M", word_grid) and
          has_char_at?({x + 1, y - 1}, "M", word_grid) and
          has_char_at?({x - 1, y + 1}, "S", word_grid) and
          has_char_at?({x + 1, y + 1}, "S", word_grid),

        # Left
        has_char_at?({x - 1, y - 1}, "S", word_grid) and
          has_char_at?({x - 1, y + 1}, "S", word_grid) and
          has_char_at?({x + 1, y - 1}, "M", word_grid) and
          has_char_at?({x + 1, y + 1}, "M", word_grid),

        # Right
        has_char_at?({x + 1, y - 1}, "S", word_grid) and
          has_char_at?({x + 1, y + 1}, "S", word_grid) and
          has_char_at?({x - 1, y - 1}, "M", word_grid) and
          has_char_at?({x - 1, y + 1}, "M", word_grid)
      ]
      |> Enum.count(& &1)
    end)
  end

  defp has_char_at?({x, y}, char, word_grid) do
    case Enum.find(word_grid, fn {c, pos} -> pos == {x, y} and c == char end) do
      nil -> false
      _ -> true
    end
  end
end
