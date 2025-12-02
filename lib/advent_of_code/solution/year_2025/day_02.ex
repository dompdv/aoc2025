defmodule AdventOfCode.Solution.Year2025.Day02 do
  import Enum, only: [map: 2, chunk_every: 2, any?: 1, sum: 1]

  def parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> map(fn r ->
      [l, h] = String.split(r, "-")
      {String.to_integer(l), String.to_integer(h)}
    end)
  end

  # Alternative: def uniform_list?(l), do: length(Enum.uniq(l)) == 1
  def uniform_list?([_a]), do: true
  def uniform_list?([a, b | _r]) when a != b, do: false
  def uniform_list?([_a, b | r]), do: uniform_list?([b | r])

  def is_invalid(n, _stop_at) when n <= 9, do: false

  def is_invalid(n, stop_at) do
    n_into_chars = n |> to_string() |> to_charlist()
    number_length = length(n_into_chars)
    test_until = if stop_at == :number_length, do: number_length, else: stop_at

    # Cut into all sizes of equal pieces (length must be divisible into equal size)
    for i <- 2..test_until, rem(number_length, i) == 0 do
      n_into_chars |> chunk_every(div(number_length, i)) |> uniform_list?()
    end
    |> any?()
  end

  def scan(input, stop_at) do
    sum(for {l, h} <- parse(input), n <- l..h, is_invalid(n, stop_at), do: n)
  end

  def part1(input), do: scan(input, 2)
  def part2(input), do: scan(input, :number_length)
end
