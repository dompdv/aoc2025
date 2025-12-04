defmodule AdventOfCode.Solution.Year2025.Day04 do
  import Enum, only: [flat_map: 2, with_index: 1, sum: 1, filter: 2, count: 1]

  def parse(input) do
    # Create a MapSet of the {row,col} of the rolls
    with_index(String.split(input, "\n", trim: true))
    |> flat_map(fn {line, row} ->
      for {c, col} <- with_index(to_charlist(line)), c == ?@, do: {row, col}
    end)
    |> MapSet.new()
  end

  def vec_sum({a, b}, {c, d}), do: {a + c, b + d}

  @around for r <- -1..1, c <- -1..1, {r, c} != {0, 0}, do: {r, c}
  def liftable(roll, rolls) do
    sum(for delta <- @around, vec_sum(roll, delta) in rolls, do: 1) < 4
  end

  def part1(input) do
    rolls = parse(input)
    rolls |> filter(&liftable(&1, rolls)) |> count()
  end

  def remove_all(rolls, counter \\ 0) do
    # Identify the removable rolls
    removable = for roll <- rolls, liftable(roll, rolls), into: MapSet.new(), do: roll
    # If nothing to remove, we're done, else remove the removable rolls and increment the counter
    if MapSet.size(removable) == 0,
      do: counter,
      else: remove_all(MapSet.difference(rolls, removable), counter + MapSet.size(removable))
  end

  def part2(input), do: input |> parse() |> remove_all()
end
