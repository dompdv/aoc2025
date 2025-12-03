defmodule AdventOfCode.Solution.Year2025.Day03 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn bank ->
      bank |> to_charlist() |> Enum.map(&(&1 - ?0))
    end)
  end

  # End of recursion: all switches are activated
  def search(_, cumul, -1), do: cumul

  def search(rest, cumul, n_switches) do
    # Consider the max number on the right (keeping enough numbers for all the switches that are still to activate)
    max_in_remaining = rest |> Enum.slice(0..(length(rest) - n_switches - 1)) |> Enum.max()
    # Drop the numbers to the right until (and including) this max
    {_, [_max_in_remaining | r]} = Enum.split_while(rest, &(&1 != max_in_remaining))
    # Loop recursively
    search(r, cumul + max_in_remaining * Integer.pow(10, n_switches), n_switches - 1)
  end

  def part1(input), do: parse(input) |> Enum.map(&search(&1, 0, 1)) |> Enum.sum()
  def part2(input), do: parse(input) |> Enum.map(&search(&1, 0, 11)) |> Enum.sum()
end
