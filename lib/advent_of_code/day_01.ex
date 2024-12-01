defmodule AdventOfCode.Day01 do
  def part1(calibration_string) do
    calibration_string
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.sum()
  end

  # defp parse_line_(line) do
  #   digits = String.graphemes(line)
  #   first = find_first_digit(digits)
  #   last = find_first_digit(Enum.reverse(digits))

  #   String.to_integer(first <> last)
  # end

  defp parse_line(line) do
    digits =
      Regex.scan(~r/\d+/, line)
      |> List.flatten()

    # dbg(digits)
    unless Enum.empty?(digits) do
      first = List.first(digits)
      last = List.last(digits)
      String.to_integer(first <> last)
    else
      0
    end
  end

  # defp find_first_digit(line) do
  #   Enum.find(line, "0", fn char ->
  #     case Integer.parse(char) do
  #       {_, ""} -> true
  #       _ -> false
  #     end
  #   end)
  # end

  def part2(_args) do
  end
end
