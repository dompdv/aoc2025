defmodule AdventOfCode.Solution.Year2025.Day04Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2025.Day04

  setup do
    [
      input: """
      ..@@.@@@@.
      @@@.@.@.@@
      @@@@@.@.@@
      @.@@@@..@.
      @@.@@@@.@@
      .@@@@@@@.@
      .@.@.@.@@@
      @.@@@.@@@@
      .@@@@@@@@.
      @.@.@@@.@.
      """
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 13
  end

  @tag :skip
  test "part2", %{input: input} do
    result = part2(input)

    assert result
  end
end
