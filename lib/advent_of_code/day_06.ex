defmodule AdventOfCode.Day06 do
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
    visited_positions = Enum.map(visited_states, fn {pos, _dir} -> pos end) |> Enum.uniq() |> tl()

    for position <- visited_positions do
      Task.async(fn ->
        # IO.inspect(position, label: "obstacle position for task #{inspect(self())}")

        map = add_obstacle(map, position)
        result = move_guard(map, guard_position, :up)
        # IO.inspect(result, label: "result for task #{inspect(self())}")
        result
      end)
    end
    |> Enum.map(&Task.await/1)
    |> Enum.count(fn
      {:loop, _, _} -> true
      {:out_of_bounds, _} -> false
    end)
  end

  defp make_map_grid(map_input) do
    map_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row) |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Map.new()
  end

  defp move_guard(map, guard_position, looking_direction) do
    visited_states = MapSet.new([{guard_position, looking_direction}])

    do_move_guard(
      map,
      guard_position,
      looking_direction,
      visited_states
    )
  end

  defp do_move_guard(map, guard_position, looking_direction, visited_states) do
    {x, y} = guard_position

    next_pos =
      case looking_direction do
        :up -> {x, y - 1}
        :down -> {x, y + 1}
        :left -> {x + 1, y}
        :right -> {x - 1, y}
      end

    cond do
      is_loop?({next_pos, looking_direction}, visited_states) ->
        {:loop, visited_states, {next_pos, looking_direction}}

      is_out_of_bounds?(map, next_pos) ->
        {:out_of_bounds, visited_states}

      is_wall?(map, next_pos) ->
        new_direction = turn_left(looking_direction)
        new_state = {guard_position, new_direction}

        do_move_guard(
          map,
          guard_position,
          new_direction,
          MapSet.put(visited_states, new_state)
        )

      true ->
        do_move_guard(
          map,
          next_pos,
          looking_direction,
          MapSet.put(visited_states, {next_pos, looking_direction})
        )
    end
  end

  defp is_loop?({next_pos, looking_direction}, visited_states) do
    MapSet.member?(visited_states, {next_pos, looking_direction}) and
      MapSet.size(visited_states) > 4
  end

  defp is_out_of_bounds?(map, {x, y}) do
    not Map.has_key?(map, {x, y})
  end

  defp is_wall?(map, {x, y}) do
    Map.get(map, {x, y}) == "#"
  end

  defp turn_left(:up), do: :left
  defp turn_left(:left), do: :down
  defp turn_left(:down), do: :right
  defp turn_left(:right), do: :up

  defp add_obstacle(map, {x, y}) do
    Map.put(map, {x, y}, "#")
  end
end
