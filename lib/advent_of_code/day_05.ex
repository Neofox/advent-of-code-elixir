defmodule AdventOfCode.Day05 do
  def part1(safety_manual_input) do
    {ordering_rules, pages_to_produce} = parse_input(safety_manual_input)

    pages_to_produce
    |> Enum.filter(&safe_to_print?(&1, ordering_rules))
    |> Enum.map(&get_page_in_middle/1)
    |> Enum.sum()
  end

  def part2(safety_manual_input) do
    {ordering_rules, pages_to_produce} = parse_input(safety_manual_input)

    pages_to_produce
    |> Enum.reject(&safe_to_print?(&1, ordering_rules))
    |> Enum.map(&fix_pages_order(&1, ordering_rules))
    |> Enum.map(&get_page_in_middle/1)
    |> Enum.sum()
  end

  defp parse_input(input) do
    [rules, pages] = String.split(input, "\n\n", trim: true)
    {parse_ordering_rules(rules), parse_pages_to_produce(pages)}
  end

  defp parse_ordering_rules(safety_manual_input) do
    for line <- String.split(safety_manual_input, "\n", trim: true) do
      String.split(line, "|") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end
    |> MapSet.new()
  end

  defp parse_pages_to_produce(safety_manual_input) do
    for line <- String.split(safety_manual_input, "\n", trim: true) do
      String.split(line, ",") |> Enum.map(&String.to_integer/1)
    end
  end

  defp safe_to_print?([], _ordering_rules), do: true
  defp safe_to_print?([_page], _ordering_rules), do: true

  defp safe_to_print?([page | following_pages], ordering_rules) do
    not ordering_rule_exists?(page, following_pages, ordering_rules) and
      safe_to_print?(following_pages, ordering_rules)
  end

  defp ordering_rule_exists?(page, list_of_pages, ordering_rules) do
    Enum.any?(list_of_pages, &MapSet.member?(ordering_rules, {&1, page}))
  end

  defp get_page_in_middle(pages_to_produce) do
    Enum.at(pages_to_produce, div(length(pages_to_produce), 2))
  end

  defp fix_pages_order(pages_to_produce, ordering_rules) do
    Enum.sort(pages_to_produce, &MapSet.member?(ordering_rules, {&1, &2}))
  end
end
