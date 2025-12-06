defmodule AdventOfCode.Solution.Year2025.Day06 do
  import Enum, only: [with_index: 1, reduce: 3, sum: 1, take: 2]

  def mul(l), do: reduce(l, 1, &(&1 * &2))

  def parse_part1(input) do
    # Returns a list of groups like {:mul, [12,1453,23]} (operator, operands)
    input
    |> String.split("\n", trim: true)
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

  def part1(input) do
    parse_part1(input)
    |> reduce(0, fn
      {op, l}, acc ->
        acc + if op == :mul, do: mul(l), else: sum(l)
    end)
  end

  def parse2(input) do
    lines = input |> String.split("\n", trim: true)

    {
      # map of %{column => number}
      reduce(take(lines, length(lines) - 1), %{}, fn line, acc ->
        line
        |> String.codepoints()
        |> with_index()
        |> reduce(acc, fn {c, col}, local_acc ->
          Map.update(local_acc, col, c, &(&1 <> c))
        end)
      end)
      |> reduce(%{}, fn {col, s}, acc ->
        s = String.trim(s)
        if s == "", do: acc, else: Map.put(acc, col, String.to_integer(s))
      end)
      |> Map.new(),
      # map of %{column => operator}
      List.last(lines)
      |> to_charlist()
      |> with_index()
      |> reduce(%{}, fn {c, col}, acc ->
        if c == 32, do: acc, else: Map.put(acc, col, c)
      end)
    }
  end

  # Find the next element in a list. returns max_length if reaching the end of the list
  def next([val], val, max_length), do: max_length
  def next([val, n | _], val, _max_length), do: n
  def next([_n | r], val, max_length), do: next(r, val, max_length)

  # Gather numbers starting from col till an empty column
  def gather(numbers, col, acc) do
    if Map.has_key?(numbers, col), do: gather(numbers, col + 1, [numbers[col] | acc]), else: acc
  end

  def part2(input) do
    {numbers, operators} = parse2(input)

    reduce(operators, 0, fn {col, op}, acc ->
      l = gather(numbers, col, [])
      acc + if op == ?*, do: mul(l), else: sum(l)
    end)
  end
end
