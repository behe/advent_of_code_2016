defmodule AdventOfCode01Test do
  use ExUnit.Case
  doctest AdventOfCode01

  test "Following R2 from start position leaves you facing east two blocks east" do
    assert move(0, {0, 0}, "R2") == [1, {2, 0}, [{2, 0}, {1, 0}, {0, 0}]]
  end

  test "Following L3 when facing east leaves you facing north three blocks north" do
    assert move(1, {2, 0}, "L3") == [0, {2, 3}, [{2, 3}, {2, 2}, {2, 1}, {2, 0}]]
  end

  test "Following L2 from start position leaves you facing west two blocks west" do
    assert move(0, {0, 0}, "L2") == [3, {-2, 0}, [{-2, 0}, {-1, 0}, {0, 0}]]
  end

  test "Following L3 after R2 leaves you 2 blocks East and 3 blocks North" do
    assert move(1, {2, 0}, "L3", [{2, 0}, {1, 0}, {0, 0}]) == [0, {2, 3}, [{2, 3}, {2, 2}, {2, 1}, {2, 0}, {1, 0}, {0, 0}]]
  end

  def move(_, _, _, moves \\ [])
  def move(heading, {x, y}, "R" <> steps, moves) do
    move(heading, x, y, 1, String.to_integer(steps), moves)
  end
  def move(heading, {x, y}, "L" <> steps, moves) do
    move(heading, x, y, -1, String.to_integer(steps), moves)
  end

  def move(heading, x, y, direction, steps, moves) do
    {heading, delta_x, delta_y} = heading(heading, direction)
    moves = case moves do
      [] -> [{x, y}]
      moves -> moves
    end
    moves = Enum.reduce(1..steps, moves, fn(_, moves = [{x, y} | _]) ->
      position = {x + delta_x, y + delta_y}
      [position | moves]
    end)
    position = List.first(moves)
    [heading, position, moves]
  end

  @directions 4
  def heading(heading, direction) do
    case rem(@directions + heading + direction, @directions) do
      0 -> {0, 0, 1}
      1 -> {1, 1, 0}
      2 -> {2, 0, -1}
      3 -> {3, -1, 0}
    end
  end

  test "Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away" do
    assert blocks("R2, L3") == 5
  end

  test "R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away" do
    assert blocks("R2, R2, R2") == 2
  end

  test "R5, L5, R5, R3 leaves you 12 blocks away" do
    assert blocks("R5, L5, R5, R3") == 12
  end

  def blocks(input) do
    input
    |> String.split(", ")
    |> Enum.reduce([0, {0, 0}, []], fn(direction, [heading, {x, y}, moves]) ->
      move(heading, {x, y}, direction, moves)
    end)
    |> Enum.at(1)
    |> distance
  end

  def distance(block) do
    block
    |> Tuple.to_list
    |> Enum.map(&Kernel.abs/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  test "How many blocks away is Easter Bunny HQ" do
    assert File.read!("test/fixtures/input.txt")
    |> String.trim
    |> blocks == 243
  end

  test "R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East" do
    assert twice("R8, R4, R4, R8") == {4, 0}
  end

  def twice(input) do
    input
    |> String.split(", ")
    |> Enum.reduce_while([0, {0, 0}, []], fn(direction, [heading, {x, y}, moves]) ->
      move_blocks = move(heading, {x, y}, direction, moves)
      move_blocks
      |> Enum.at(2)
      |> Enum.reverse
      |> Enum.reduce_while([], fn(pos, acc) ->
        case Enum.member?(acc, pos) do
          true -> {:halt, pos}
          false -> {:cont, [pos | acc]}
        end
      end)
      |> case do
        list when is_list(list) -> {:cont, move_blocks}
        pos -> {:halt, pos}
      end
    end)
  end

  test "How many blocks away is the first location you visit twice?" do
    assert File.read!("test/fixtures/input.txt")
    |> String.trim
    |> twice
    |> distance == 142
  end
end
