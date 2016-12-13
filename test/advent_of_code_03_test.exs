defmodule AdventOfCode03Test do
  use ExUnit.Case

  test "Invalid triangle" do
    assert "    5   10   25"
    |> triangle? == false
  end

  test "Valid triangle" do
    assert "  419  794  987"
    |> triangle? == true
  end

  def triangle?(input) when is_binary(input) do
    input
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> triangle?
  end

  def triangle?([x, y, z]) when x + y > z and x + z > y and y + z > x, do: true
  def triangle?(_), do: false

  test "How many of the listed triangles are possible?" do
    assert File.read!("test/fixtures/input03.txt")
    |> possible == 983
  end

  def possible(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&triangle?/1)
    |> length
  end

  test "numbers with the same hundreds digit would be part of the same triangle" do
    assert """
101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603
"""
    |> vertically_possible == 6
  end

  def vertically_possible(input) do
    input
    |> String.split("\n")
    |> Enum.chunk(3)
    |> Enum.flat_map(fn(chunk) ->
      [[ax,bx,cx],[ay,by,cy],[az,bz,cz]] = Enum.map(chunk, fn(row) ->
        row
        |> String.split
        |> Enum.map(&String.to_integer/1)
      end)
      [[ax,ay,az],[bx,by,bz],[cx,cy,cz]]
    end)
    |> Enum.filter(&triangle?/1)
    |> length
  end

  test "Instead reading by columns, how many of the listed triangles are possible?" do
    assert File.read!("test/fixtures/input03.txt")
    |> vertically_possible == 1836
  end
end
