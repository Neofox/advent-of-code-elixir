defmodule AdventOfCode.Day07 do
  def part1(puzzle_input) do
    for {result, numbers} <- parse_input(puzzle_input),
        result in do_operations(numbers, [:add, :multiply]),
        reduce: 0 do
      acc -> acc + result
    end
  end

  def part2(puzzle_input) do
    for {result, numbers} <- parse_input(puzzle_input),
        result in do_operations(numbers, [:add, :multiply, :concat]),
        reduce: 0 do
      acc -> acc + result
    end
  end

  defp parse_input(puzzle_input) do
    puzzle_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [result, numbers] = String.split(line, ": ")
      {String.to_integer(result), String.split(numbers, " ") |> Enum.map(&String.to_integer/1)}
    end)
  end

  defp do_operations([a, b], operations) do
    Enum.map(operations, &apply_operation(&1, a, b))
  end

  defp do_operations([head | tail], operations) do
    Enum.reduce(tail, [head], fn num, acc_results ->
      Enum.flat_map(acc_results, fn acc ->
        Enum.map(operations, &apply_operation(&1, acc, num))
      end)
    end)
  end

  defp apply_operation(:add, a, b), do: a + b
  defp apply_operation(:multiply, a, b), do: a * b
  defp apply_operation(:concat, a, b), do: String.to_integer("#{a}#{b}")
end
