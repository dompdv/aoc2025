defmodule AdventOfCode.Solution.Year2025.Day10 do
  @test """
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  """

  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn %{diagram: {target, _}} = machine ->
      Graph.new()
      |> Graph.add_edges(generate_edges(machine))
      |> Graph.dijkstra(0, target)
      |> Enum.count()
      |> then(&(&1 - 1))
    end)
    |> Enum.sum()
  end

  def part2(_input) do
  end

  def generate_edges(%{diagram: {_, size}, buttons: buttons}) do
    Enum.flat_map(0..(size - 1), fn start ->
      for button <- buttons, do: {start, Bitwise.bxor(start, button), weight: 1}
    end)
  end

  def parse(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.reduce(%{diagram: nil, buttons: [], joltage: []}, fn chunk, acc ->
      cond do
        Regex.match?(~r/\[(.*)\]/, chunk) ->
          %{acc | diagram: {parse_diagram(chunk), Integer.pow(2, String.length(chunk) - 2)}}

        Regex.match?(~r/\{(.*)\}/, chunk) ->
          %{acc | joltage: parse_joltage(chunk)}

        true ->
          Map.update(acc, :buttons, [], fn buttons -> [parse_button(chunk) | buttons] end)
      end
    end)
  end

  def parse_diagram(chunk) do
    Regex.run(~r/\[(.*)\]/, chunk, capture: :all_but_first)
    |> hd
    |> to_charlist()
    |> Enum.reduce({0, 1}, fn
      ?., {acc, n} -> {acc, n * 2}
      ?#, {acc, n} -> {acc + n, n * 2}
    end)
    |> elem(0)
  end

  def parse_button(button) do
    Regex.run(~r/\((.*)\)/, button, capture: :all_but_first)
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, fn n, acc -> acc + Integer.pow(2, n) end)
  end

  def parse_joltage(chunk) do
    Regex.run(~r/\{(.*)\}/, chunk, capture: :all_but_first)
    |> hd
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
