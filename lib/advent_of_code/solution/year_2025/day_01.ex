defmodule AdventOfCode.Solution.Year2025.Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "L" <> rest -> -1 * String.to_integer(rest)
      "R" <> rest -> String.to_integer(rest)
    end)
  end

  def operate(input, start, multiple, count_hits) do
    input
    |> parse()
    |> Enum.reduce(
      {start, 0},
      fn delta, {current_position, current_score} ->
        {rem(multiple + delta + current_position, multiple),
         current_score + count_hits.(current_position, delta, multiple)}
      end
    )
    |> elem(1)
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.reduce(
      {50, 0},
      fn
        delta, {current_position, current_score} ->
          new_position = rem(current_position + delta + 100, 100)

          if new_position == 0,
            do: {new_position, current_score + 1},
            else: {new_position, current_score}
      end
    )
    |> elem(1)
  end

  def sgn(x) when x < 0, do: -1
  def sgn(_x), do: 1

  def count_hits2(start, delta, multiple) do
    step = sgn(delta)
    Enum.count((start + step)..(start + delta), fn i -> rem(i, multiple) == 0 end)
  end

  def part2(input) do
    operate(input, 50, 100, &count_hits2/3)
  end
end
