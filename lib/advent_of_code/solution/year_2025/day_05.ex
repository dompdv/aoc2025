defmodule AdventOfCode.Solution.Year2025.Day05 do
  def parse(input) do
    [intervals, ingredients] = String.split(input, "\n\n", trim: true)

    p_intervals =
      for int <- String.split(intervals, "\n") do
        [l, h] = String.split(int, "-")
        {String.to_integer(l), String.to_integer(h)}
      end

    p_ingredients =
      for ing <- String.split(ingredients, "\n", trim: true), do: String.to_integer(ing)

    {p_intervals, p_ingredients}
  end

  # Part 1
  def in_interval?(i, {l, h}), do: l <= i and i <= h

  def in_any_interval?(ingredient, intervals),
    do: Enum.any?(for interval <- intervals, do: in_interval?(ingredient, interval))

  def part1(input) do
    {intervals, ingredients} = parse(input)
    Enum.count(ingredients, &in_any_interval?(&1, intervals))
  end

  ## Merge interval utility function
  # Go back to a reference case
  def merge_int({a, b}, {c, d}) when c < a, do: merge_int({c, d}, {a, b})

  def merge_int({_a, b}, {c, _d}) when c > b, do: :distinct
  def merge_int({a, b}, {c, d}) when c <= b, do: {:merged, {a, max(b, d)}}

  def merge_or_add_one_interval(new_interval, intervals) do
    {merged_list, a_merge_happened} =
      Enum.reduce(intervals, {[], false}, fn existing_interval, {accumulator, a_merge_happened} ->
        case merge_int(existing_interval, new_interval) do
          :distinct -> {[existing_interval | accumulator], a_merge_happened}
          {:merged, merged_interval} -> {[merged_interval | accumulator], true}
        end
      end)

    if a_merge_happened,
      do: {merged_list, true},
      else: {[new_interval | merged_list], false}
  end

  def merge_all_intervals_together(intervals) do
    # Start with an empty list and add one interval after another to this list
    Enum.reduce(intervals, {[], false}, fn interval_to_add,
                                           {accumulator, a_merge_happened_so_far} ->
      {merged_list, a_new_merge_happened} =
        merge_or_add_one_interval(interval_to_add, accumulator)

      {merged_list, a_new_merge_happened or a_merge_happened_so_far}
    end)
  end

  # Merge all intervals iteratively till they are all distinct
  def merge_until_stable(intervals) do
    {new_intervals, a_merge_happened} = merge_all_intervals_together(intervals)
    if a_merge_happened, do: merge_until_stable(new_intervals), else: new_intervals
  end

  def add_interval_sizes(intervals) do
    intervals |> Enum.map(fn {l, h} -> h - l + 1 end) |> Enum.sum()
  end

  def part2(input) do
    elem(parse(input), 0)
    |> merge_until_stable()
    |> add_interval_sizes()
  end
end
