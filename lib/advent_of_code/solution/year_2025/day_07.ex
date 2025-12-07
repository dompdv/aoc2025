defmodule AdventOfCode.Solution.Year2025.Day07 do
  def part1(input), do: input |> fire_beam() |> take_counter()
  def part2(input), do: input |> fire_beam() |> take_timelines() |> Map.values() |> Enum.sum()

  def fire_beam(input) do
    layout = parse(input)
    last_row = layout |> Map.keys() |> Enum.max()
    [start] = layout[0]
    beam(Map.new([{start, 1}]), 0, last_row, 0, layout)
  end

  def take_counter(a), do: elem(a, 1)
  def take_timelines(a), do: elem(a, 0)

  def beam(in_flight, row, last_row, counter, _layout) when row > last_row,
    do: {in_flight, counter}

  def beam(in_flight, row, last_row, counter, layout) do
    # in_flight %{column => number of timelines leading to this point}
    # counter : number of hits on a splitter
    next_row_splitters = Map.get(layout, row + 2, [])

    {new_in_flight, bings} =
      Enum.reduce(
        in_flight,
        {%{}, 0},
        fn {col, n_timelines}, {next_positions, bings_so_far} ->
          if col in next_row_splitters do
            {
              next_positions
              |> Map.update(col - 1, n_timelines, &(&1 + n_timelines))
              |> Map.update(col + 1, n_timelines, &(&1 + n_timelines)),
              bings_so_far + 1
            }
          else
            {Map.update(next_positions, col, n_timelines, &(&1 + n_timelines)), bings_so_far}
          end
        end
      )

    beam(new_in_flight, row + 2, last_row, counter + bings, layout)
  end

  def parse(input) do
    # Returns %{row => [list of splitter's columns]}
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, row}, lines ->
      splitter_cols =
        to_charlist(line)
        |> Enum.with_index()
        |> Enum.reduce([], fn
          {?., _}, acc -> acc
          {?^, col}, l -> [col | l]
          {?S, col}, l -> [col | l]
        end)

      if splitter_cols == [], do: lines, else: [{row, splitter_cols} | lines]
    end)
    |> Map.new()
  end
end
