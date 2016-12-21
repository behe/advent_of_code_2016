defmodule AdventOfCode06Test do
  use ExUnit.Case

  @test_input ~s"""
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
"""

  test "The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter" do
    assert most_common(@test_input) == "easter"
  end

  def most_common(input) do
    input
    |> sort_column_by_ocurrence
    |> Enum.map(&List.first/1)
    |> Enum.join
  end

  defp sort_column_by_ocurrence(input) do
    lines = input
      |> String.split("\n")
      |> Enum.slice(0..-2)
    chars = lines
      |> List.first
      |> String.length
    for i <- 0..(chars-1) do
      Enum.map(lines, fn(line) ->
        String.at(line, i)
      end)
      |> Enum.group_by(&(&1))
      |> Enum.sort_by(fn({_, elements}) -> length(elements) end, &>=/2)
      |> Enum.map(fn({key, _}) -> key end)
    end
  end

  test "Given the recording in your puzzle input, what is the error-corrected version of the message being sent?" do
    assert File.read!("test/fixtures/input06.txt")
    |> most_common
    == "xhnqpqql"
  end

  test "In the above example, the least common character in the first column is a; in the second, d, and so on. Repeating this process for the remaining characters produces the original message, advent" do
    assert least_common(@test_input) == "advent"
  end

  def least_common(input) do
    input
    |> sort_column_by_ocurrence
    |> Enum.map(&List.last/1)
    |> Enum.join
  end

  test "Given the recording in your puzzle input and this new decoding methodology, what is the original message that Santa is trying to send?" do
    assert File.read!("test/fixtures/input06.txt")
    |> least_common
    == "brhailro"
  end
end
