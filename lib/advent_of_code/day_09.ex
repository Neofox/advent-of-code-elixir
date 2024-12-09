defmodule AdventOfCode.Day09 do
  require Integer

  def part1(disk_map) do
    disk_map_to_block(String.replace(disk_map, "\n", ""))
    |> move_file_block()
    |> calculate_checksum()
  end

  def part2(disk_map) do
    disk_map_to_block(String.replace(disk_map, "\n", ""))
    |> move_file_block_full()
    |> calculate_checksum()
  end

  def disk_map_to_block(disk_map) do
    disk_map
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.flat_map(fn {num, index} ->
      num_int = String.to_integer(num)

      if Integer.is_odd(index) do
        # Odd index: produce dots if num_int > 0
        if num_int > 0, do: List.duplicate(".", num_int), else: []
      else
        # Even index: produce digits
        digit = Integer.to_string(div(index, 2))
        List.duplicate(digit, num_int)
      end
    end)
  end

  def move_file_block_full(blocks) do
    do_move_file_block_full(blocks)
  end

  defp do_move_file_block_full(blocks) do
    gap = left_most_gap(blocks)

    case gap do
      nil ->
        blocks

      {gap_start, _gap_end} ->
        case right_most_number(blocks) do
          nil ->
            blocks

          {number_start, number_end} ->
            # Calculate sizes
            number_length = number_end - number_start + 1
            number_value = Enum.at(blocks, number_start)

            # Check if we have enough continuous space
            has_space = Enum.slice(blocks, gap_start, number_length) |> Enum.all?(&(&1 === "."))

            if has_space do
              # Move the entire number
              blocks
              |> fill_range(gap_start, number_length, number_value)
              |> fill_range(number_start, number_length, ".")
              |> do_move_file_block_full()
            else
              blocks
            end
        end
    end
  end

  def move_file_block(blocks) do
    do_move_file_block(blocks)
  end

  defp do_move_file_block(blocks) do
    gap = left_most_gap(blocks)

    case gap do
      nil ->
        blocks

      {gap_start, _gap_end} ->
        {_last_start, last_end} = right_most_number(blocks)
        last_value = Enum.at(blocks, last_end)

        blocks
        |> List.replace_at(gap_start, last_value)
        |> List.replace_at(last_end, ".")
        |> do_move_file_block()
    end
  end

  defp left_most_gap(blocks) do
    start_index = Enum.find_index(blocks, fn num -> num === "." end)

    case start_index do
      nil ->
        nil

      _ ->
        # Find the end of the continuous gap
        end_index =
          Enum.drop(blocks, start_index)
          |> Enum.with_index()
          |> Enum.find(fn {val, _} -> val !== "." end)
          |> case do
            nil -> nil
            {_, offset} -> start_index + offset - 1
          end

        # Only return if end_index is not the last position
        if end_index && end_index < length(blocks) - 1 do
          {start_index, end_index}
        else
          nil
        end
    end
  end

  defp right_most_number(blocks) do
    blocks
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce_while(
      nil,
      fn
        {".", _index}, acc ->
          {:cont, acc}

        {num, index}, _acc when is_binary(num) ->
          reversed_index = length(blocks) - index - 1
          # Find the start by looking ahead until we hit a "." or the start
          start_index =
            blocks
            |> Enum.take(reversed_index + 1)
            |> Enum.reverse()
            |> Enum.find_index(fn x -> x === "." end)
            |> case do
              nil -> 0
              i -> reversed_index - i + 1
            end

          {:halt, {start_index, reversed_index}}
      end
    )
  end

  def calculate_checksum(blocks) do
    blocks
    |> Enum.reject(&(&1 === "."))
    |> Enum.with_index()
    |> Enum.reduce(0, fn {num, index}, acc ->
      acc + String.to_integer(num) * index
    end)
  end

  # Helper function to fill a range with a value
  defp fill_range(blocks, start_index, length, value) do
    Enum.reduce(0..(length - 1), blocks, fn offset, acc ->
      List.replace_at(acc, start_index + offset, value)
    end)
  end
end
