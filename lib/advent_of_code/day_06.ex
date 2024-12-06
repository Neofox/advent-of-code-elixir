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

    guard_position = Enum.find_value(map, fn {pos, char} -> char == "^" and pos end)

    case move_guard(map, guard_position, :up) do
      {:loop, _, _} ->
        raise "Guard is in a loop"

      {:out_of_bounds, visited_states} ->
        Enum.map(visited_states, fn {pos, _dir} -> pos end)
        |> Enum.uniq_by(fn pos -> pos end)
        |> length()
    end
  end

  def part2(map_input) do
    map = make_map_grid(map_input)
    guard_position = Enum.find_value(map, fn {pos, char} -> char == "^" and pos end)

    # Get the visited positions from the initial guard movement
    {:out_of_bounds, visited_states} = move_guard(map, guard_position, :up)

    # Extract just the positions from the visited states
    visited_positions =
      visited_states
      |> Enum.map(fn {pos, _dir} -> pos end)
      |> Enum.uniq()
      |> Enum.slice(1..-2//1)

    Task.async_stream(
      visited_positions,
      fn position ->
        map_with_obstacle = add_obstacle(map, position)
        move_guard(map_with_obstacle, guard_position, :up)
      end
    )
    |> Enum.filter(fn
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

  defp move_guard(map, guard_position, looking_dir) do
    visited_states = MapSet.new([{guard_position, looking_dir}])

    do_move_guard(
      map,
      guard_position,
      looking_dir,
      visited_states
    )
  end

  defp do_move_guard(map, guard_position, looking_dir, visited_states) do
    next_pos = calculate_next_position(guard_position, looking_dir)

    cond do
      MapSet.member?(visited_states, {next_pos, looking_dir}) ->
        {:loop, visited_states, {next_pos, looking_dir}}

      is_out_of_bounds?(map, next_pos) ->
        {:out_of_bounds, visited_states}

      is_wall?(map, next_pos) ->
        new_direction = turn_left(looking_dir)
        new_state = {guard_position, new_direction}
        do_move_guard(map, guard_position, new_direction, MapSet.put(visited_states, new_state))

      true ->
        do_move_guard(
          map,
          next_pos,
          looking_dir,
          MapSet.put(visited_states, {next_pos, looking_dir})
        )
    end
  end

  defp is_out_of_bounds?(map, {x, y}) do
    not Map.has_key?(map, {x, y})
  end

  defp is_wall?(map, {x, y}) do
    Map.get(map, {x, y}) == "#"
  end

  defp calculate_next_position({x, y}, direction) do
    {dx, dy} = @directions[direction]
    {x + dx, y + dy}
  end

  defp turn_left(direction), do: @turns[direction]

  defp add_obstacle(map, {x, y}) do
    Map.put(map, {x, y}, "#")
  end
end
