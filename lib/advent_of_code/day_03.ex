defmodule AdventOfCode.Day03 do
  def part1(instructions) do
    instructions |> extract_params()
  end

  def part2(instructions) do
    instructions |> remove_disabled_instructions() |> extract_params()
  end

  defp extract_params(instruction) do
    regex = ~r/mul\((\d+),(\d+)\)/
    all_params = Regex.scan(regex, instruction)

    all_params
    |> Stream.map(fn [_, x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Stream.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  defp remove_disabled_instructions(instruction) do
    regex = ~r/don't\(\)(.*?)do\(\)/s
    Regex.replace(regex, instruction, "")
  end
end
