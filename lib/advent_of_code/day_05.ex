defmodule AdventOfCode.Day05 do
  def part1(safety_manual_input) do
    [pages_ordering_rules, pages_to_produce] = String.split(safety_manual_input, "\n\n")

    parsed_pages_ordering_rules = parse_ordering_rules(pages_ordering_rules)

    pages_to_produce
    |> parse_pages_to_produce()
    |> Enum.filter(&safe_to_print?(&1, parsed_pages_ordering_rules))
    |> Enum.map(&get_page_in_middle/1)
    |> Enum.sum()
  end

  def part2(safety_manual_input) do
    [pages_ordering_rules, pages_to_produce] = String.split(safety_manual_input, "\n\n")

    parsed_pages_ordering_rules = parse_ordering_rules(pages_ordering_rules)

    pages_to_produce
    |> parse_pages_to_produce()
    |> Enum.reject(&safe_to_print?(&1, parsed_pages_ordering_rules))
    |> Enum.map(&fix_pages_order(&1, parsed_pages_ordering_rules))
    |> Enum.map(&get_page_in_middle/1)
    |> Enum.sum()
  end

  defp parse_ordering_rules(safety_manual_input) do
    safety_manual_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [page_before, page_after] =
        String.split(line, "|")
        |> Enum.map(&String.to_integer/1)

      {page_before, page_after}
    end)
  end

  defp parse_pages_to_produce(safety_manual_input) do
    safety_manual_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  defp safe_to_print?([page | following_pages], pages_ordering_rules) do
    not ordering_rule_exists?(page, following_pages, pages_ordering_rules) and
      safe_to_print?(following_pages, pages_ordering_rules)
  end

  defp safe_to_print?([], _pages_ordering_rules), do: true

  defp ordering_rule_exists?(page, list_of_pages, pages_ordering_rules) do
    Enum.any?(pages_ordering_rules, fn {page_before, page_after} ->
      page_after === page and page_before in list_of_pages
    end)
  end

  defp get_page_in_middle(pages_to_produce) do
    length = length(pages_to_produce)
    pages_to_produce |> Enum.at(div(length, 2))
  end

  defp fix_pages_order(pages_to_produce, pages_ordering_rules) do
    pages_to_produce
    |> Enum.sort(fn page_before, page_after ->
      {page_before, page_after} in pages_ordering_rules
    end)
  end
end
