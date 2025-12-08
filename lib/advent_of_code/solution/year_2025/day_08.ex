defmodule AdventOfCode.Solution.Year2025.Day08 do
  # Launch processing for part1 & 2
  def part1(input), do: input |> do_connect(1000) |> mul_3_largest()
  def part2(input), do: input |> do_connect(:full_connect) |> mul_xs()

  # Post processing part 1
  def mul_3_largest(circuits) do
    circuits
    |> Enum.map(fn {_, c} -> MapSet.size(c) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, &(&1 * &2))
  end

  # Post processing part 2
  def mul_xs({[x1, _, _], [x2, _, _]}), do: x1 * x2

  # The common algorithm : preparing the wiring process
  def do_connect(input, stop_at) do
    boxes_i = parse(input)

    sorted_connects =
      for({b1, i1} <- boxes_i, {b2, i2} <- boxes_i, i1 < i2, do: add_distance(b1, b2))
      |> Enum.sort_by(&elem(&1, 2))

    initial_circuits = for {b, i} <- boxes_i, into: %{}, do: {i, MapSet.new([b])}

    wire(sorted_connects, initial_circuits, 0, stop_at, nil)
  end

  def add_distance(b1, b2),
    do: {b1, b2, Enum.zip(b1, b2) |> Enum.map(fn {a, b} -> (a - b) * (a - b) end) |> Enum.sum()}

  # Wiring process itself
  # Stop if there is one circuit left
  def wire(_, circuits, _n, _stop_at, last) when map_size(circuits) == 1, do: last

  # Stop if we reach "stop_at" if stop_at is a number
  def wire(_, circuits, n, stop_at, _last) when stop_at != :full_connect and n == stop_at,
    do: circuits

  def wire([{b1, b2, _} | rest], circuits, n, stop_at, _last) do
    c_b1 = which_circuit(circuits, b1)
    c_b2 = which_circuit(circuits, b2)

    if c_b1 == c_b2 do
      # They are in the same circuit => do nothing
      wire(rest, circuits, n + 1, stop_at, {b1, b2})
    else
      # Different circuit, merge circuit c_b2 into c_b1
      new_circuits =
        circuits |> Map.delete(c_b2) |> Map.update(c_b1, nil, &MapSet.union(&1, circuits[c_b2]))

      wire(rest, new_circuits, n + 1, stop_at, {b1, b2})
    end
  end

  def which_circuit(circuits, b) do
    # returns the index of the circuit containing the box b
    Enum.reduce_while(circuits, nil, fn {i, c}, _acc ->
      if b in c, do: {:halt, i}, else: {:cont, nil}
    end)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
  end
end
