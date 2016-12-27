defmodule AdventOfCode08Test do
  use ExUnit.Case

  @start_screen [
    "..................................................",
    "..................................................",
    "..................................................",
    "..................................................",
    "..................................................",
    "..................................................",
  ]

  @line_fill "##################################################"

  test "rect 3x2 creates a small rectangle in the top-left corner" do
    assert draw("rect 3x2") == [
      "###...............................................",
      "###...............................................",
      "..................................................",
      "..................................................",
      "..................................................",
      "..................................................",
    ]
  end

  def draw(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> draw(@start_screen)
  end

  def draw([], screen), do: screen
  def draw([instruction | rest], screen) do
    draw(rest, draw(instruction, screen))
  end

  def draw("rect " <> size, screen) do
    [x, y] = String.split(size, "x") |> Enum.map(&String.to_integer/1)
    draw_rect(x, y, screen)
  end
  def draw("rotate column x=" <> size, screen) do
    [col, pixels] = String.split(size, " by ") |> Enum.map(&String.to_integer/1)
    shift_column(col, pixels, screen)
  end
  def draw("rotate row y=" <> size, screen) do
    [row, pixels] = String.split(size, " by ") |> Enum.map(&String.to_integer/1)
    shift_row(row, pixels, screen)
  end

  def draw_rect(x, y, screen) do
    screen
    |> Enum.with_index
    |> Enum.map(fn({line, i}) ->
      case i < y do
        true ->
          String.slice(@line_fill, 0, x) <> String.slice(line, x, 50 - x)
        _ -> line
      end
    end)
  end

  test "rotate column x=1 by 1 rotates the second column down by one pixel" do
    assert draw("rect 3x2\nrotate column x=1 by 1") == [
      "#.#...............................................",
      "###...............................................",
      ".#................................................",
      "..................................................",
      "..................................................",
      "..................................................",
    ]
  end

  def shift_column(col, pixels, screen) do
    screen
    |> Enum.with_index
    |> Enum.map(fn({line, i}) ->
      {line, Enum.at(screen, i - pixels)}
    end)
    |> Enum.map(fn({line, replacement_line}) ->
      [String.slice(line, 0, col), String.slice(replacement_line, col, 1), String.slice(line, col + 1, 50 - col)]
      |> Enum.join
    end)
  end

  test "rotate row y=0 by 4 rotates the top row right by four pixels" do
    assert draw("rect 3x2\nrotate column x=1 by 1\nrotate row y=0 by 48") == [
      "#...............................................#.",
      "###...............................................",
      ".#................................................",
      "..................................................",
      "..................................................",
      "..................................................",
    ]
  end

  def shift_row(row, pixels, screen) do
    screen
    |> Enum.with_index
    |> Enum.map(fn({line, i}) ->
      case i == row do
        true ->
          String.slice(line, 50 - pixels, pixels) <> String.slice(line, 0, 50 - pixels)
        _ -> line
      end
    end)
  end

  test "rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top" do
    assert draw("rect 3x2\nrotate column x=1 by 1\nrotate row y=0 by 48\nrotate column x=1 by 4") == [
      "##..............................................#.",
      "#.#...............................................",
      "..................................................",
      "..................................................",
      "..................................................",
      ".#................................................",
    ]
  end

  test "after you swipe your card, if the screen did work, how many pixels should be lit?" do
    assert File.read!("test/fixtures/input08.txt")
    |> draw
    |> Enum.map(fn(line) ->
      String.replace(line, ".", "")
    end)
    |> Enum.join
    |> String.length
    == 110
  end

  test "After you swipe your card, what code is the screen trying to display?" do
    assert File.read!("test/fixtures/input08.txt")
    |> draw == [
      "####...##.#..#.###..#..#..##..###..#....#...#..##.",
      "...#....#.#..#.#..#.#.#..#..#.#..#.#....#...#...#.",
      "..#.....#.####.#..#.##...#....#..#.#.....#.#....#.",
      ".#......#.#..#.###..#.#..#....###..#......#.....#.",
      "#....#..#.#..#.#.#..#.#..#..#.#....#......#..#..#.",
      "####..##..#..#.#..#.#..#..##..#....####...#...##..",
    ]
  end
end
