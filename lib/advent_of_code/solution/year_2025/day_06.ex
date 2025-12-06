defmodule AdventOfCode.Solution.Year2025.Day06 do
  # import Enum, only: [map: 2, any?: 1, count: 2, sort: 1, sum: 1]
  import Enum, only: [map: 2]

  @val """
  123 328  51 64
   45 64  387 23
    6 98  215 314
  *   +   *   +
  """

  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.with_index()
    |> map(fn {n, col} -> {col, String.to_integer(n)} end)
  end

  def parse(input) do
    [ops | rest] = input |> String.split("\n", trim: true) |> Enum.reverse()

    rest =
      rest
      |> Enum.reverse()
      |> map(&parse_line/1)
      |> List.flatten()
      |> Enum.group_by(&elem(&1, 0))

    ops =
      ops
      |> String.split(" ", trim: true)
      |> Enum.with_index()
      |> map(fn
        {"*", i} -> {i, :mul}
        {"+", i} -> {i, :add}
      end)
      |> Map.new()

    cols = map_size(ops)

    {rest, ops, cols}
  end

  def part1(input) do
    {numbers, operators, cols} = input |> parse()

    for i <- 0..(cols - 1) do
      op = Map.get(operators, i)

      Enum.reduce(
        Map.get(numbers, i),
        if(op == :mul, do: 1, else: 0),
        fn {_, n}, acc ->
          if op == :mul, do: acc * n, else: acc + n
        end
      )
    end
    |> Enum.sum()
  end

  def parse2(input) do
    lines = input |> String.split("\n", trim: true)

    numbers =
      Enum.take(lines, length(lines) - 1)
      |> Enum.with_index()
      |> map(fn {line, row} ->
        to_charlist(line)
        |> Enum.with_index()
        |> map(fn {c, col} -> {{row, col}, c} end)
      end)
      |> List.flatten()
      |> Map.new()

    operators =
      List.last(lines)
      |> to_charlist()
      |> Enum.with_index()
      |> Enum.reduce([], fn {c, col}, acc ->
        if c == 32, do: acc, else: [{col, c} | acc]
      end)
      |> Enum.reverse()

    line_size = map(lines, &String.length/1) |> Enum.max()
    {numbers, operators, line_size, length(lines) - 1}
  end

  def part2(input) do
    {numbers, operators, line_size, rows} = parse2(input)
    start_cols = map(operators, &elem(&1, 0))
    blocks = Enum.chunk_every(start_cols ++ [line_size + 1], 2, 1)
    blocks = List.delete_at(blocks, length(blocks) - 1) |> IO.inspect()
    m_operators = Map.new(operators)

    for [c1, c2] <- blocks do
      op = m_operators[c1]

      IO.inspect(op)

      for c <- c1..(c2 - 2) do
        for(row <- 0..(rows - 1), do: Map.get(numbers, {row, c}, 32))
        |> to_string()
        |> String.trim()
        |> String.to_integer()
      end
      |> IO.inspect()
      |> Enum.reduce(
        if(op == ?*, do: 1, else: 0),
        fn n, acc -> if op == ?*, do: n * acc, else: n + acc end
      )
      |> IO.inspect()
    end
    |> Enum.sum()
  end
end
