defmodule AdventOfCode.Day07 do
  def part1(puzzle_input) do
    String.split(puzzle_input, "\n", trim: true)
    |> Enum.map(fn line ->
      [result, numbers] = String.split(line, ": ")

      {String.to_integer(result), String.split(numbers, " ") |> Enum.map(&String.to_integer/1)}
    end)
    |> Enum.filter(fn {result, numbers} -> find_sum_or_product(result, numbers) end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum()
  end

  def part2(puzzle_input) do
    String.split(puzzle_input, "\n", trim: true)
    |> Enum.map(fn line ->
      [result, numbers] = String.split(line, ": ")

      {String.to_integer(result), String.split(numbers, " ") |> Enum.map(&String.to_integer/1)}
    end)
    |> Enum.filter(fn {result, numbers} -> find_sum_or_product_or_concat(result, numbers) end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum()
  end

  defp find_sum_or_product(result, numbers) do
    do_sum_or_product(numbers) |> Enum.member?(result)
  end

  defp find_sum_or_product_or_concat(result, numbers) do
    do_sum_or_product_or_concat(numbers) |> Enum.member?(result)
  end

  defp do_sum_or_product_or_concat([a, b]), do: [a + b, a * b, String.to_integer("#{a}#{b}")]

  defp do_sum_or_product_or_concat([head | tail]) do
    Enum.reduce(tail, [head], fn num, acc_results ->
      Enum.flat_map(acc_results, fn acc ->
        [acc + num, acc * num, String.to_integer("#{acc}#{num}")]
      end)
    end)
  end

  defp do_sum_or_product([a, b]), do: [a + b, a * b]

  defp do_sum_or_product([head | tail]) do
    Enum.reduce(tail, [head], fn num, acc_results ->
      Enum.flat_map(acc_results, fn acc ->
        [acc + num, acc * num]
      end)
    end)
  end
end
