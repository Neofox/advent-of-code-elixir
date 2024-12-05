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

  defp parse_input(safety_manual_input) do
    [rules_section, pages_section] = String.split(safety_manual_input, "\n\n", trim: true)

    ordering_rules = parse_ordering_rules(rules_section)
    pages_to_produce = parse_pages_to_produce(pages_section)

    {ordering_rules, pages_to_produce}
  end

  defp parse_ordering_rules(safety_manual_input) do
    safety_manual_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [before_page, after_page] = String.split(line, "|")
      {String.to_integer(before_page), String.to_integer(after_page)}
    end)
    |> MapSet.new()
  end

  defp parse_pages_to_produce(safety_manual_input) do
    safety_manual_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ",") |> Enum.map(&String.to_integer/1)
    end)
  end

  defp safe_to_print?([], _pages_ordering_rules), do: true
  defp safe_to_print?([_page], _pages_ordering_rules), do: true

  defp safe_to_print?([page | following_pages], pages_ordering_rules) do
    not ordering_rule_exists?(page, following_pages, pages_ordering_rules) and
      safe_to_print?(following_pages, pages_ordering_rules)
  end

  defp ordering_rule_exists?(page, list_of_pages, pages_ordering_rules) do
    Enum.any?(list_of_pages, fn page_before ->
      MapSet.member?(pages_ordering_rules, {page_before, page})
    end)
  end

  defp get_page_in_middle(pages_to_produce) do
    Enum.at(pages_to_produce, div(length(pages_to_produce), 2))
  end

  defp fix_pages_order(pages_to_produce, pages_ordering_rules) do
    pages_to_produce
    |> Enum.sort(fn page_before, page_after ->
      {page_before, page_after} in pages_ordering_rules
    end)
  end
end
