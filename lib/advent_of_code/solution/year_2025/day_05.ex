defmodule AdventOfCode.Solution.Year2025.Day05 do
  import Enum, only: [map: 2, any?: 1, count: 2, sort: 1, sum: 1]
  # Part 1
  def in_range?(i, {l, h}), do: l <= i and i <= h

  def in_any_range?(ingredient, ranges),
    do: any?(for range <- ranges, do: in_range?(ingredient, range))

  def part1(input) do
    {ranges, ingredients} = parse(input)
    count(ingredients, &in_any_range?(&1, ranges))
  end

  # Part 2
  def distinct?({a, b}, {c, d}), do: b < c or d < a
  def merge_overlapping({a, b}, {c, d}) when c < a, do: merge_overlapping({c, d}, {a, b})
  def merge_overlapping({a, b}, {_c, d}), do: {a, max(b, d)}

  def merge([], ranges_in_stock), do: ranges_in_stock
  def merge([range | to_merge], []), do: merge(to_merge, [range])

  def merge([to_add | to_merge], [top_of_stock | rest] = stock) do
    if distinct?(to_add, top_of_stock),
      do: merge(to_merge, [to_add | stock]),
      else: merge(to_merge, [merge_overlapping(to_add, top_of_stock) | rest])
  end

  def part2(input) do
    elem(parse(input), 0)
    |> sort()
    |> merge([])
    |> map(fn {l, h} -> h - l + 1 end)
    |> sum()
  end

  def parse(input) do
    [p1, p2] = String.split(input, "\n\n") |> map(&String.split(&1, "\n", trim: true))

    {map(p1, &parse_range/1), map(p2, &String.to_integer/1)}
  end

  def parse_range(line) do
    line |> String.split("-") |> map(&String.to_integer/1) |> List.to_tuple()
  end
end
