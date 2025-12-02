defmodule AdventOfCode.Solution.Year2025.Day02 do
  def parse(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn r ->
      [l, h] = String.split(r, "-")
      {String.to_integer(l), String.to_integer(h)}
    end)
  end

  def is_invalid_old(n) do
    sn = to_string(n) |> to_charlist()
    l = div(length(sn), 2)

    tests =
      for i <- 1..l do
        groups = Enum.chunk_every(sn, i, 1)
        sets = MapSet.new(groups)
        length(groups) != MapSet.size(sets)
      end

    IO.inspect({n, tests})

    if Enum.any?(tests), do: n, else: 0
  end

  def is_invalid(n) do
    sn = to_string(n) |> to_charlist()

    l = length(sn)

    if rem(l, 2) == 1 do
      0
    else
      [a, b] = Enum.chunk_every(sn, div(l, 2))
      if a == b, do: n, else: 0
    end
  end

  def is_invalid2(n) when n < 10 do
    0
  end

  def is_invalid2(n) do
    sn = to_string(n) |> to_charlist()
    l = length(sn)

    all_divs =
      for i <- 2..l do
        if rem(l, i) != 0 do
          false
        else
          chunks = Enum.chunk_every(sn, div(l, i)) |> Enum.uniq()
          length(chunks) == 1
        end
      end

    if Enum.any?(all_divs), do: n, else: 0
  end

  def invalid_id({l, h}) do
    for(i <- l..h, do: is_invalid(i)) |> Enum.sum()
  end

  def invalid_id2({l, h}) do
    for(i <- l..h, do: is_invalid2(i)) |> Enum.sum()
  end

  def part1(input) do
    input |> parse() |> Enum.map(&invalid_id/1) |> Enum.sum()
  end

  def part2(input) do
    input |> parse() |> Enum.map(&invalid_id2/1) |> Enum.sum()
  end
end
