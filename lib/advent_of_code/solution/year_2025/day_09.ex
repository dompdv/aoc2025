defmodule AdventOfCode.Solution.Year2025.Day09 do
  @test """
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """
  def part1(input) do
    tiles = input |> parse()

    for {i1, [x1, y1]} <- tiles,
        {i2, [x2, y2]} <- tiles,
        i1 < i2 do
      (max(x1, x2) - min(x1, x2) + 1) * (max(y1, y2) - min(y1, y2) + 1)
    end
    |> Enum.max()
  end

  def part2(input) do
    points = parse(input)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index(&{&2, &1})
    |> Map.new()
  end
end
