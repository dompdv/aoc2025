defmodule AdventOfCode.Solution.Year2025.Day02 do
  def parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn r ->
      [l, h] = String.split(r, "-")
      {String.to_integer(l), String.to_integer(h)}
    end)
  end

  def is_invalid(n, _stop_at) when n < 10, do: false

  def is_invalid(n, stop_at) do
    n_into_chars = n |> to_string() |> to_charlist()
    number_length = length(n_into_chars)
    test_until = if stop_at == nil, do: number_length, else: stop_at

    # Cut into all sizes of pieces
    all_divs =
      for i <- 2..test_until do
        if rem(number_length, i) != 0 do
          # If the number can be cut in equal sizes
          false
        else
          # Test if all chunks are equal
          Enum.chunk_every(n_into_chars, div(number_length, i))
          |> Enum.uniq()
          |> then(&(length(&1) == 1))
        end
      end

    Enum.any?(all_divs)
  end

  def scan(input, stop_at) do
    Enum.sum(
      for {l, h} <- parse(input), n <- l..h, is_invalid(n, stop_at) do
        n
      end
    )
  end

  def part1(input), do: scan(input, 2)
  def part2(input), do: scan(input, nil)
end
