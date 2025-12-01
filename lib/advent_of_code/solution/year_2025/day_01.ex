defmodule AdventOfCode.Solution.Year2025.Day01 do
  def dial(input, start, mult, counter_func) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "L" <> rest -> -1 * String.to_integer(rest)
      "R" <> rest -> String.to_integer(rest)
    end)
    |> Enum.reduce(
      {start, 0},
      fn delta, {position, score} ->
        {next_position(position, delta, mult), score + counter_func.(position, delta, mult)}
      end
    )
    |> elem(1)
  end

  defp remp(n, p), do: Integer.mod(n, p)
  def next_position(current, delta, mult), do: remp(current + delta, mult)

  # Brute force, but simple
  def count_hits(start, delta, mult) do
    step = if delta < 0, do: -1, else: 1
    Enum.count((start + step)..(start + delta)//step, fn i -> remp(i, mult) == 0 end)
  end

  def stop_at_zero(start, delta, mult) do
    if next_position(start, delta, mult) == 0, do: 1, else: 0
  end

  def part1(input), do: dial(input, 50, 100, &stop_at_zero/3)
  def part2(input), do: dial(input, 50, 100, &count_hits/3)
end
