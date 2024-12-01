defmodule AdventOfCode.Day01 do
  @spec part1(binary()) :: number()
  def part1(location_list) do
    {first_list, second_list} = generate_lists(location_list)
    Enum.sum(add_two_lists(Enum.sort(first_list), Enum.sort(second_list)))
  end

  @spec part2(binary()) :: number()
  def part2(location_list) do
    {first_list, second_list} = generate_lists(location_list)

    Enum.sum(find_similarity(first_list, second_list))
  end

  defp generate_lists(str) do
    String.split(str, "\n")
    |> Enum.map(fn line ->
      case String.split(line, "   ") |> Enum.reject(&(&1 === "")) do
        [first, second] -> {String.to_integer(first), String.to_integer(second)}
        _ -> {0, 0}
      end
    end)
    |> Enum.unzip()
  end

  defp add_two_lists(list1, list2) do
    Enum.zip(list1, list2)
    |> Enum.map(fn {x, y} ->
      cond do
        x == nil -> 0
        y == nil -> 0
        true -> abs(x - y)
      end
    end)
  end

  defp find_similarity(list1, list2) do
    Enum.map(list1, fn
      nil ->
        0

      loc ->
        count = Enum.count(list2, &(&1 == loc))
        count * loc
    end)
  end
end
