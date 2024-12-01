defmodule AdventOfCode.Day01 do
  def part1(location_list) do
    lists = generate_lists(location_list)
    first_list = lists |> Enum.map(&List.first/1) |> Enum.sort()

    second_list =
      lists |> Enum.map(&List.last/1) |> Enum.sort()

    Enum.sum(add_two_lists(first_list, second_list))
  end

  defp generate_lists(str) do
    String.split(str, "\n")
    |> Enum.map(fn line ->
      String.split(line, "   ")
      |> Enum.reject(&(&1 === ""))
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp add_two_lists(list1, list2), do: do_add_two_lists(list1, list2, [])

  defp do_add_two_lists([h1 | t1], [h2 | t2], acc) do
    val =
      case h1 do
        nil -> 0
        _ -> abs(h1 - h2)
      end

    do_add_two_lists(t1, t2, [val | acc])
  end

  defp do_add_two_lists([], [], acc), do: Enum.reverse(acc)

  def part2(location_list) do
    lists = generate_lists(location_list)
    first_list = lists |> Enum.map(&List.first/1) |> Enum.sort()

    second_list =
      lists |> Enum.map(&List.last/1) |> Enum.sort()

    Enum.sum(find_similarity(first_list, second_list))
  end

  defp find_similarity(list1, list2) do
    Enum.map(list1, fn loc ->
      cond do
        loc == nil -> 0
        Enum.member?(list2, loc) -> Enum.count(list2, fn loc2 -> loc == loc2 end) * loc
        true -> 0
      end
    end)
  end
end
