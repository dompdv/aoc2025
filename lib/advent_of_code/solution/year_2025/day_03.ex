defmodule AdventOfCode.Solution.Year2025.Day03 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn bank ->
      bank |> to_charlist() |> Enum.map(&(&1 - ?0))
    end)
  end

  ### Part 1
  def largest_two(bank) do
    bank_wi = Enum.with_index(bank)
    Enum.max(for {n1, i1} <- bank_wi, {n2, i2} <- bank_wi, i1 < i2, do: n1 * 10 + n2)
  end

  def part1(input), do: parse(input) |> Enum.map(&largest_two/1) |> Enum.sum()

  ### Part 2
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

  def part2(input), do: parse(input) |> Enum.map(&search(&1, 0, 11)) |> Enum.sum()
end
