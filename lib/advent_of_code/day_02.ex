defmodule AdventOfCode.Day02 do
  def part1(unusual_data) do
    unusual_data |> make_report() |> Enum.count(&report_safe?/1)
  end

  def part2(unusual_data) do
    unusual_data |> make_report() |> Enum.count(&report_dampened_safe?/1)
  end

  defp make_report(unusual_data) do
    unusual_data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  defp report_safe?(report) do
    check_levels(report, :decreasing, []) ||
      check_levels(report, :increasing, [])
  end

  defp report_dampened_safe?(report) do
    Enum.any?([
      check_levels(report, :decreasing, allow_skip: true),
      check_levels(tl(report), :decreasing, allow_skip: true, skipped: true),
      check_levels(report, :increasing, allow_skip: true),
      check_levels(tl(report), :increasing, allow_skip: true, skipped: true)
    ])
  end

  defp check_levels([head | tail], direction, opts) do
    do_check_levels(head, tail, direction, opts)
  end

  defp do_check_levels(_val, [], _direction, _opts), do: true

  defp do_check_levels(val, [head | tail], direction, opts) do
    allow_skip = Keyword.get(opts, :allow_skip, false)
    skipped = Keyword.get(opts, :skipped, false)

    case get_diff(val, head, direction) do
      diff when diff >= 1 and diff <= 3 ->
        do_check_levels(head, tail, direction, opts)

      _ when allow_skip and not skipped ->
        do_check_levels(val, tail, direction, Keyword.put(opts, :skipped, true))

      _ ->
        false
    end
  end

  defp get_diff(first_val, second_val, :decreasing), do: first_val - second_val
  defp get_diff(first_val, second_val, :increasing), do: second_val - first_val
end
