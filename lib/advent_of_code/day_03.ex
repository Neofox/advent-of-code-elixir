defmodule AdventOfCode.Day03 do
  @mul_regex ~r/mul\((\d+),(\d+)\)/
  @disable_regex ~r/don't\(\)(.*?)do\(\)/s

  def part1(instructions) do
    instructions
    |> extract_params()
    |> Enum.sum()
  end

  def part2(instructions) do
    instructions
    |> remove_disabled_instructions()
    |> extract_params()
    |> Enum.sum()
  end

  defp extract_params(instruction) do
    for [_mul, x, y] <- Regex.scan(@mul_regex, instruction) do
      String.to_integer(x) * String.to_integer(y)
    end
  end

  defp remove_disabled_instructions(instruction) do
    @disable_regex
    |> Regex.replace(instruction, "")
  end
end
