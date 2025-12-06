defmodule AdventOfCode.Solution.Year2025.Day06 do
  # import Enum, only: [map: 2, any?: 1, count: 2, sort: 1, sum: 1]
  import Enum, only: [map: 2, with_index: 1, reduce: 3, sum: 1]

  def parse_part1(input) do
    # Each group of number/operand has a number
    # Returns :  [{operator, operands}] . [{:mul, [12,1453,23]},...]
    input
    |> String.split("\n", trim: true)
    |> reduce(
      %{},
      fn line, acc ->
        line
        |> String.split(" ", trim: true)
        |> with_index()
        |> reduce(acc, fn {chunk, chunk_number}, local_acc ->
          {operator, operands} = Map.get(local_acc, chunk_number, {nil, []})

          case chunk do
            "*" ->
              Map.put(local_acc, chunk_number, {:mul, operands})

            "+" ->
              Map.put(local_acc, chunk_number, {:add, operands})

            number ->
              Map.put(local_acc, chunk_number, {operator, [String.to_integer(number) | operands]})
          end
        end)
      end
    )
    |> Map.values()
  end

  def mul(l), do: reduce(l, 1, &(&1 * &2))

  def part1(input) do
    for {op, l} <- parse_part1(input) do
      if op == :mul, do: mul(l), else: sum(l)
    end
    |> sum()
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
