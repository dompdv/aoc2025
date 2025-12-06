defmodule AdventOfCode.Solution.Year2025.Day06 do
  import Enum, only: [with_index: 1, reduce: 3, sum: 1, take: 2]
  @space 32

  def part1(input), do: sum_mul(input, &parse_part1/1)
  def part2(input), do: sum_mul(input, &parse_part2/1)

  def sum_mul(input, parsing_function) do
    sum(for {op, l} <- parsing_function.(input), do: sum_or_mul(op, l))
  end

  def sum_or_mul(:mul, l), do: mul(l)
  def sum_or_mul(:add, l), do: sum(l)

  def parse_part1(input) do
    # Returns a list of groups like {:mul, [12,1453,23]} (operator, operands)

    String.split(input, "\n", trim: true)
    |> reduce(
      %{},
      fn line, acc ->
        indexed_groups = line |> String.split(" ", trim: true) |> with_index()

        reduce(indexed_groups, acc, fn {chunk, chunk_number}, local_acc ->
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

  def parse_part2(input) do
    # Returns a list of groups like {:mul, [12,1453,23]} (operator, operands)
    lines = input |> String.split("\n", trim: true)
    # Build map of %{column => number in the column}
    numbers =
      reduce(take(lines, length(lines) - 1), %{}, fn line, acc ->
        line
        |> String.codepoints()
        |> with_index()
        |> reduce(acc, fn {c, col}, local_acc ->
          Map.update(local_acc, col, c, &String.trim(&1 <> c))
        end)
      end)
      |> reduce(%{}, fn {col, s}, acc ->
        if s == "", do: acc, else: Map.put(acc, col, String.to_integer(s))
      end)
      |> Map.new()

    # Build the [{operator, list of numbers}]
    List.last(lines)
    |> to_charlist()
    |> with_index()
    |> reduce(%{}, fn
      {@space, _col}, acc ->
        acc

      {op, col}, acc ->
        atom_op = if op == ?*, do: :mul, else: :add
        Map.put(acc, col, {atom_op, gather(numbers, col, [])})
    end)
    |> Map.values()
  end

  def mul(l), do: reduce(l, 1, &(&1 * &2))

  # Gather numbers starting from col till an empty column
  def gather(numbers, col, acc) do
    if Map.has_key?(numbers, col), do: gather(numbers, col + 1, [numbers[col] | acc]), else: acc
  end
end
