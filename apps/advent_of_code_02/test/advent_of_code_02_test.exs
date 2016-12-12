defmodule AdventOfCode02Test do
  use ExUnit.Case
  doctest AdventOfCode02

  test "You start at 5 and move up (to 2), left (to 1), and left (you can't, and stay on 1), so the first button is 1" do
    assert digit("5", "ULL") == "1"
  end

  @moves %{
    "1" => %{"D" => "4", "R" => "2"},
    "2" => %{"D" => "5", "L" => "1", "R" => "3"},
    "3" => %{"D" => "6", "L" => "2"},
    "4" => %{"D" => "7", "R" => "5", "U" => "1"},
    "5" => %{"D" => "8", "L" => "4", "R" => "6", "U" => "2"},
    "6" => %{"D" => "9", "L" => "5", "U" => "3"},
    "7" => %{"R" => "8", "U" => "4"},
    "8" => %{"L" => "7", "R" => "9", "U" => "5"},
    "9" => %{"L" => "8", "U" => "6"}
  }

  def digit(start, input, moves \\ @moves) do
    input
    |> String.split("")
    |> Enum.slice(0, String.length(input))
    |> Enum.reduce(start, fn(move, pos) ->
      moves[pos][move] || pos
    end)
  end

  test "Starting from the previous button (1), you move right twice (to 3) and then down three times (stopping at 9 after two moves and ignoring the third), ending up with 9" do
    assert digit("1", "RRDDD") == "9"
  end

  test "Continuing from 9, you move left, up, right, down, and left, ending with 8" do
    assert digit("9", "LURDL") == "8"
  end

  test "Finally, you move up four times (stopping at 2), then down once, ending with 5" do
    assert digit("8", "UUUUD") == "5"
  end

  test "So, in this example, the bathroom code is 1985" do
    assert code("ULL\nRRDDD\nLURDL\nUUUUD") == "1985"
  end

  def code(input, moves \\ @moves) do
    input
    |> String.split("\n")
    |> Enum.reduce("", fn(input, digits) ->
      curr = (String.at(digits, -1) || "5")
      |> digit(input, moves)
      digits <> curr
    end)
  end

  test "What is the bathroom code?" do
    assert File.read!("test/fixtures/input.txt")
    |> String.trim
    |> code == "97289"
  end

  @fancy_moves %{
    "1" => %{"D" => "3"},
    "2" => %{"D" => "6", "R" => "3"},
    "3" => %{"D" => "7", "L" => "2", "R" => "4", "U" => "1"},
    "4" => %{"D" => "8", "L" => "3"},
    "5" => %{"R" => "6"},
    "6" => %{"D" => "A", "L" => "5", "R" => "7", "U" => "2"},
    "7" => %{"D" => "B", "L" => "6", "R" => "8", "U" => "3"},
    "8" => %{"D" => "C", "L" => "7", "R" => "9", "U" => "4"},
    "9" => %{"L" => "8"},
    "A" => %{"R" => "B", "U" => "6"},
    "B" => %{"D" => "D", "L" => "A", "R" => "C", "U" => "7"},
    "C" => %{"L" => "B", "U" => "8"},
    "D" => %{"U" => "B"},
  }

  test "You start at 5 and don't move at all (up and left are both edges), ending at 5" do
    assert digit("5", "ULL", @fancy_moves) == "5"
  end

  test "Continuing from 5, you move right twice and down three times (through 6, 7, B, D, D), ending at D" do
    assert digit("5", "RRDDD", @fancy_moves) == "D"
  end

  test "Then, from D, you move five more times (through D, B, C, C, B), ending at B" do
    assert digit("D", "LURDL", @fancy_moves) == "B"
  end

  test "Finally, after five more moves, you end at 3" do
    assert digit("B", "UUUUD", @fancy_moves) == "3"
  end

  test "So, given the actual keypad layout, the code would be 5DB3" do
    assert code("ULL\nRRDDD\nLURDL\nUUUUD", @fancy_moves) == "5DB3"
  end

  test "Using the same instructions in your puzzle input, what is the correct bathroom code?" do
    assert File.read!("test/fixtures/input.txt")
    |> String.trim
    |> code(@fancy_moves) == "9A7DC"
  end
end
