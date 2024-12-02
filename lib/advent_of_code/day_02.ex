defmodule AdventOfCode.Day02 do
  def part1(unusual_data) do
    make_report(unusual_data) |> Enum.count(&report_safe?/1)
  end

  def part2(unusual_data) do
    make_report(unusual_data) |> Enum.count(&report_safe?(&1, true))
  end

  defp make_report(unusual_data) do
    unusual_data
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reject(&(&1 === []))
  end

  defp parse_line(line) do
    line
    |> String.split()
    |> Enum.reject(&(&1 === ""))
    |> Enum.map(&String.to_integer/1)
  end

  defp report_safe?(report, dampened \\ false) when is_list(report) do
    case dampened do
      true ->
        all_levels_decreasing?(report, dampened) ||
          all_levels_decreasing?(tl(report), dampened, true) ||
          all_levels_increasing?(report, dampened) ||
          all_levels_increasing?(tl(report), dampened, true)

      false ->
        all_levels_decreasing?(report) ||
          all_levels_increasing?(report)
    end
  end

  defp all_levels_decreasing?([head | tail], dampened \\ false, problem_dampened \\ false) do
    if dampened do
      do_all_levels_decreasing_dampened?(head, tail, problem_dampened)
    else
      do_all_levels_decreasing?(head, tail)
    end
  end

  ### Non-dampened
  defp do_all_levels_decreasing?(_val, []), do: true

  defp do_all_levels_decreasing?(val, [head | tail]) do
    case val - head >= 1 && val - head <= 3 do
      true -> do_all_levels_decreasing?(head, tail)
      false -> false
    end
  end

  ### Dampened
  defp do_all_levels_decreasing_dampened?(_val, [], _), do: true

  defp do_all_levels_decreasing_dampened?(val, [head | tail], problem_dampened) do
    case val - head >= 1 && val - head <= 3 do
      true -> do_all_levels_decreasing_dampened?(head, tail, problem_dampened)
      false when problem_dampened -> false
      false -> do_all_levels_decreasing_dampened?(val, tail, true)
    end
  end

  defp all_levels_increasing?([head | tail], dampened \\ false, problem_dampened \\ false) do
    if dampened do
      do_all_levels_increasing_dampened?(head, tail, problem_dampened)
    else
      do_all_levels_increasing?(head, tail)
    end
  end

  ### Non-dampened
  defp do_all_levels_increasing?(_val, []), do: true

  defp do_all_levels_increasing?(val, [head | tail]) do
    case head - val >= 1 && head - val <= 3 do
      true -> do_all_levels_increasing?(head, tail)
      false -> false
    end
  end

  ### Dampened
  defp do_all_levels_increasing_dampened?(_val, [], _), do: true

  defp do_all_levels_increasing_dampened?(val, [head | tail], problem_dampened) do
    case head - val >= 1 && head - val <= 3 do
      true -> do_all_levels_increasing_dampened?(head, tail, problem_dampened)
      false when problem_dampened -> false
      false -> do_all_levels_increasing_dampened?(val, tail, true)
    end
  end
end
