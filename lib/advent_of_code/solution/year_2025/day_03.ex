defmodule AdventOfCode.Solution.Year2025.Day03 do
  @pow10 for i <- 0..13, into: %{}, do: {i, Integer.pow(10, i)}
  def pow(n), do: Map.get(@pow10, n)

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn bank ->
      bank |> to_charlist() |> Enum.map(&(&1 - ?0))
    end)
  end

  def largest_two(bank) do
    bank_wi = Enum.with_index(bank)
    Enum.max(for {n1, i1} <- bank_wi, {n2, i2} <- bank_wi, i1 < i2, do: n1 * 10 + n2)
  end

  def base_target(bank) do
    # Take the largest 12 elements
    # This is a reachable target to prune the tree quickly
    IO.inspect(bank, label: "base_target")

    bank
    |> Enum.with_index()
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.take(12)
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.reduce({0, 1}, fn {n, _}, {total, i} -> {total + i * n, i * 10} end)
    |> elem(0)
    |> IO.inspect(label: "base_target=")
  end

  def search(_, -1, cumul_so_far, best_so_far) do
    if cumul_so_far > best_so_far, do: cumul_so_far, else: best_so_far
  end

  def search([], _, _, _), do: nil

  def search(l_bank, switches_left, _cumul_so_far, _best_so_far)
      when length(l_bank) < switches_left, do: nil

  def search([n | rest], switches_left, cumul_so_far, best_so_far) do
    if switches_left >= 9, do: IO.inspect({n, rest, switches_left, cumul_so_far, best_so_far})

    current_switch_value = pow(switches_left)
    new_cumul_with = cumul_so_far + n * current_switch_value

    search_with =
      if new_cumul_with + current_switch_value - 1 < best_so_far,
        do: nil,
        else: search(rest, switches_left - 1, new_cumul_with, max(new_cumul_with, best_so_far))

    best_so_far = if search_with == nil, do: best_so_far, else: max(search_with, best_so_far)

    search_without =
      if cumul_so_far + 10 * current_switch_value - 1 < best_so_far,
        do: nil,
        else: search(rest, switches_left, cumul_so_far, max(cumul_so_far, best_so_far))

    if search_without == nil, do: best_so_far, else: max(search_without, best_so_far)
  end

  def launch_search(bank) do
    accessible = base_target(bank)
    search(bank, 11, 0, 0)
  end

  def part1(input) do
    parse(input) |> Enum.map(&largest_two/1) |> Enum.sum()
  end

  def part2(input) do
    parse(input) |> Enum.map(&launch_search/1) |> IO.inspect() |> Enum.sum()
  end
end
