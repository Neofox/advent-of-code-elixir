defmodule AdventOfCode.Day03 do
  def part1(instructions) do
    instructions |> extract_params()
  end

  def part2(instructions) do
    instructions |> remove_disabled_instructions() |> extract_params()
  end

  defp extract_params(instruction) do
    ~r/mul\((\d+),(\d+)\)/
    |> Regex.scan(instruction)
    |> Stream.map(fn [_, x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Stream.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  defp remove_disabled_instructions(instruction) do
    ~r/don't\(\)(.*?)do\(\)/s
    |> Regex.replace(instruction, "")
  end
end
