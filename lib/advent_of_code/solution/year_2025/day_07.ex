defmodule AdventOfCode.Solution.Year2025.Day07 do
  def part1(input), do: input |> fire_beam() |> take_counter()
  def part2(input), do: input |> fire_beam() |> take_timelines() |> Map.values() |> Enum.sum()
  def take_counter(a), do: elem(a, 1)
  def take_timelines(a), do: elem(a, 0)

  def fire_beam(input) do
    [[start] | rows] = parse(input)
    beam(Map.new([{start, 1}]), 0, rows)
  end

  def beam(in_flight, hits_counter, []), do: {in_flight, hits_counter}

  def beam(in_flight, hits_counter, [next_row_splitters | rows]) do
    # in_flight %{column => number of timelines leading to this point}
    # hits_counter : number of hits on a splitter
    {new_in_flight, new_hits} =
      Enum.reduce(in_flight, {%{}, 0}, fn {col, n_timelines}, {next_positions, hits} ->
        if col in next_row_splitters,
          do: {
            next_positions
            |> Map.update(col - 1, n_timelines, &(&1 + n_timelines))
            |> Map.update(col + 1, n_timelines, &(&1 + n_timelines)),
            hits + 1
          },
          else: {Map.update(next_positions, col, n_timelines, &(&1 + n_timelines)), hits}
      end)

    beam(new_in_flight, hits_counter + new_hits, rows)
  end

  def parse(input) do
    # Returns %{row => [list of splitter's columns]}
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, lines ->
      splitter_cols =
        to_charlist(line)
        |> Enum.with_index()
        |> Enum.reduce([], fn
          {?., _}, acc -> acc
          {?^, col}, l -> [col | l]
          {?S, col}, l -> [col | l]
        end)

      if splitter_cols == [], do: lines, else: [splitter_cols | lines]
    end)
    |> Enum.reverse()
  end
end
