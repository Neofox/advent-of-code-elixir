defmodule AdventOfCode.Day06 do
  @directions %{
    up: {0, -1},
    down: {0, 1},
    left: {1, 0},
    right: {-1, 0}
  }

  @turns %{
    up: :left,
    left: :down,
    down: :right,
    right: :up
  }

  def part1(map_input) do
    map = make_map_grid(map_input)
    guard_pos = Enum.find_value(map, fn {pos, char} -> char == "^" and pos end)

    {:out_of_bounds, visited} = move_guard(map, guard_pos, :up)

    visited
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.uniq()
    |> length()
  end

  def part2(map_input) do
    map = make_map_grid(map_input)
    guard_pos = Enum.find_value(map, fn {pos, char} -> char == "^" and pos end)

    {:out_of_bounds, visited} = move_guard(map, guard_pos, :up)

    visited
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.uniq()
    |> Enum.slice(1..-2//1)
    |> Task.async_stream(fn position ->
      map_with_obstacle = Map.put(map, position, "#")
      move_guard(map_with_obstacle, guard_pos, :up)
    end)
    |> Stream.filter(fn
      {:ok, {:loop, _, _}} -> true
      _ -> false
    end)
    |> Enum.count()
  end

  defp make_map_grid(map_input) do
    for {line, y} <- map_input |> String.split("\n", trim: true) |> Enum.with_index(),
        {char, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: %{},
        do: {{x, y}, char}
  end

  defp move_guard(map, guard_pos, looking_dir) do
    visited = MapSet.new([{guard_pos, looking_dir}])
    do_move_guard(map, guard_pos, looking_dir, visited)
  end

  defp do_move_guard(map, guard_pos, looking_dir, visited) do
    next_pos = calculate_next_position(guard_pos, looking_dir)

    cond do
      MapSet.member?(visited, {next_pos, looking_dir}) ->
        {:loop, visited, {next_pos, looking_dir}}

      !Map.has_key?(map, next_pos) ->
        {:out_of_bounds, visited}

      Map.get(map, next_pos) == "#" ->
        new_dir = turn_left(looking_dir)
        do_move_guard(map, guard_pos, new_dir, MapSet.put(visited, {guard_pos, new_dir}))

      true ->
        do_move_guard(map, next_pos, looking_dir, MapSet.put(visited, {next_pos, looking_dir}))
    end
  end

  defp turn_left(direction), do: @turns[direction]

  defp calculate_next_position({x, y}, direction) do
    {dx, dy} = @directions[direction]
    {x + dx, y + dy}
  end
end
