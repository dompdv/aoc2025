defmodule AdventOfCode.Solution.Year2025.Day01 do
  def next_position(current, delta, multiple), do: rem(current + delta + multiple, multiple)

  def dial(input, start, multiple, count_hits) do
    # Parse
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "L" <> rest -> -1 * String.to_integer(rest)
      "R" <> rest -> String.to_integer(rest)
    end)
    # Dial
    |> Enum.reduce(
      {start, 0},
      fn delta, {current_position, current_score} ->
        {next_position(current_position, delta, multiple),
         current_score + count_hits.(current_position, delta, multiple)}
      end
    )
    # Take the score
    |> elem(1)
  end

  def count_hits(start, delta, multiple) do
    step = if delta < 0, do: -1, else: 1
    Enum.count((start + step)..(start + delta)//step, fn i -> rem(i, multiple) == 0 end)
  end

  def stop_at_zero(start, delta, multiple) do
    if next_position(start, delta, multiple) == 0, do: 1, else: 0
  end

  def part1(input), do: dial(input, 50, 100, &stop_at_zero/3)
  def part2(input), do: dial(input, 50, 100, &count_hits/3)
end
