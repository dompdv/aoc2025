defmodule AdventOfCode.Solution.Year2025.Day05 do
  # Part 1
  def in_interval?(i, {l, h}), do: l <= i and i <= h

  def in_any_interval?(ingredient, intervals),
    do: Enum.any?(for interval <- intervals, do: in_interval?(ingredient, interval))

  def part1(input) do
    {intervals, ingredients} = parse(input)
    Enum.count(ingredients, &in_any_interval?(&1, intervals))
  end

  # Part 2
  def distinct?({a, b}, {c, d}), do: b < c or d < a
  def merge_overlapping({a, b}, {c, d}) when c < a, do: merge_overlapping({c, d}, {a, b})
  def merge_overlapping({a, b}, {_c, d}), do: {a, max(b, d)}

  def merge([], intervals_in_stock), do: intervals_in_stock

  def merge([to_add | to_merge], intervals_in_stock) do
    case Enum.split_while(intervals_in_stock, &distinct?(&1, to_add)) do
      {_, []} ->
        merge(to_merge, [to_add | intervals_in_stock])

      {distincts, [overlapping | in_stock]} ->
        merged_interval = merge_overlapping(to_add, overlapping)
        merge([merged_interval | to_merge], distincts ++ in_stock)
    end
  end

  def add_interval_sizes(intervals) do
    intervals |> Enum.map(fn {l, h} -> h - l + 1 end) |> Enum.sum()
  end

  def part2(input) do
    elem(parse(input), 0)
    |> Enum.sort_by(& &1)
    |> merge([])
    |> add_interval_sizes()
  end

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
end
