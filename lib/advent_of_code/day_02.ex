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
    cond do
      dampened -> check_dampened?(report)
      true -> check_regular?(report)
    end
  end

  defp check_dampened?(report) do
    [
      check_levels?(report, :decreasing, true),
      check_levels?(tl(report), :decreasing, true, true),
      check_levels?(report, :increasing, true),
      check_levels?(tl(report), :increasing, true, true)
    ]
    |> Enum.any?()
  end

  defp check_regular?(sequence) do
    check_levels?(sequence, :decreasing, false) || check_levels?(sequence, :increasing, false)
  end

  defp check_levels?([head | tail], direction, dampened, checked \\ false) do
    do_check_levels?(head, tail, direction, dampened, checked)
  end

  defp do_check_levels?(_val, [], _direction, _dampened, _checked), do: true

  defp do_check_levels?(val, [head | tail], direction, dampened, checked) do
    diff = get_diff(val, head, direction)
    valid? = diff >= 1 and diff <= 3

    cond do
      valid? -> do_check_levels?(head, tail, direction, dampened, checked)
      dampened and not checked -> do_check_levels?(val, tail, direction, dampened, true)
      true -> false
    end
  end

  defp get_diff(val, head, :decreasing), do: val - head
  defp get_diff(val, head, :increasing), do: head - val
end
