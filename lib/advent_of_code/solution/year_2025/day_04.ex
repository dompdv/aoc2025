defmodule AdventOfCode.Solution.Year2025.Day04 do
  def parse(input) do
    # Create a MapSet of the {row,col} of the rolls
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> to_charlist()
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {?., _}, acc -> acc
        {?@, col}, acc -> [{row, col} | acc]
      end)
    end)
    |> MapSet.new()
  end

  @around for r <- -1..1, c <- -1..1, {r, c} != {0, 0}, do: {r, c}

  def liftable({r_roll, c_roll}, rolls) do
    Enum.sum(for {r, c} <- @around, {r_roll + r, c_roll + c} in rolls, do: 1) < 4
  end

  def part1(input) do
    rolls = parse(input)
    Enum.filter(rolls, &liftable(&1, rolls)) |> Enum.count()
  end

  def remove_process(rolls, counter) do
    # Identify the removable rolls
    removable = for roll <- rolls, liftable(roll, rolls), into: MapSet.new(), do: roll
    # If nothing to remove, we're done, else remove the removable rolls and increment the counter
    if MapSet.size(removable) == 0,
      do: counter,
      else: remove_process(MapSet.difference(rolls, removable), counter + MapSet.size(removable))
  end

  def part2(input), do: remove_process(parse(input), 0)
end
