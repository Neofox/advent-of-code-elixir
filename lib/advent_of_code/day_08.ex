defmodule AdventOfCode.Day08 do
  @type point :: {integer, integer}
  @type grid :: %{point => String.t()}

  def part1(antenna_input) do
    antenna_map = build_antenna_map(antenna_input)
    antenna_positions = find_antenna_positions(antenna_map)

    find_all_antenna_pairs(antenna_positions)
    |> get_anti_nodes()
    |> Enum.uniq()
    |> Enum.filter(&Map.has_key?(antenna_map, &1))
    |> Enum.count()
  end

  def part2(antenna_input) do
    antenna_map = build_antenna_map(antenna_input)
    antenna_positions = find_antenna_positions(antenna_map)

    find_all_antenna_pairs(antenna_positions)
    |> get_all_anti_nodes(antenna_map)
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.count()
  end

  defp build_antenna_map(map_input) do
    for {line, y} <- map_input |> String.split("\n", trim: true) |> Enum.with_index(),
        {char, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: %{},
        do: {{x, y}, char}
  end

  defp find_antenna_positions(antenna_map) do
    antenna_map
    |> Map.filter(fn {_pos, char} ->
      char =~ ~r/^[a-zA-Z0-9]$/
    end)
  end

  defp find_all_antenna_pairs(antenna_positions) do
    antenna_positions
    |> Enum.group_by(fn {_, char} -> char end, fn {pos, _} -> pos end)
    |> Enum.flat_map(fn {_char, positions} ->
      for pos1 <- positions,
          pos2 <- positions,
          pos1 < pos2,
          do: [pos1, pos2]
    end)
  end

  defp get_anti_nodes(antenna_pairs) do
    antenna_pairs
    |> Enum.flat_map(fn [pos1, pos2] ->
      {dx, dy} = calculate_distance(pos1, pos2)
      {x1, y1} = pos1
      {x2, y2} = pos2

      [
        {x1 - dx, y1 - dy},
        {x2 + dx, y2 + dy}
      ]
    end)
  end

  defp get_all_anti_nodes(antenna_pairs, antenna_map) do
    {max_x, max_y} = Map.keys(antenna_map) |> Enum.max()

    antenna_pairs
    |> Enum.flat_map(fn [pos1, pos2] ->
      {dx, dy} = calculate_distance(pos1, pos2)
      {x1, y1} = pos1
      {x2, y2} = pos2

      # Generate nodes in negative direction from pos1
      negative_nodes =
        Stream.iterate({x1 - dx, y1 - dy}, fn {x, y} -> {x - dx, y - dy} end)
        |> Enum.take_while(fn {x, y} -> x >= 0 and y >= 0 and x <= max_x and y <= max_y end)

      # Generate nodes in positive direction from pos2
      positive_nodes =
        Stream.iterate({x2 + dx, y2 + dy}, fn {x, y} -> {x + dx, y + dy} end)
        |> Enum.take_while(fn {x, y} -> x >= 0 and y >= 0 and x <= max_x and y <= max_y end)

      negative_nodes ++ positive_nodes ++ [pos1, pos2]
    end)
  end

  defp calculate_distance({x1, y1}, {x2, y2}) do
    {x2 - x1, y2 - y1}
  end
end
