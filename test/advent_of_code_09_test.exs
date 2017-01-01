defmodule AdventOfCode09Test do
  use ExUnit.Case

  @moduletag :wip

  test "ADVENT contains no markers and decompresses to itself with no changes, resulting in a decompressed length of 6" do
    assert decompress("ADVENT") == 6
  end

  def decompress(input) when is_binary(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.reduce(0, fn(line, acc) ->
      line
      |> String.codepoints
      |> decompress
      |> Kernel.+(acc)
    end)
  end

  def decompress(compressed, decompressed_length \\ 0)
  def decompress([], decompressed_length), do: decompressed_length
  def decompress(["(" | compressed], decompressed_length) do
    {length, compressed} = extract_length(compressed)
    {times, compressed} = extract_times(compressed)

    decompress(Enum.drop(compressed, length), length * times + decompressed_length)
  end
  def decompress([_ | compressed], decompressed_length) do
    decompress(compressed, decompressed_length + 1)
  end

  def extract_length(compressed, length \\ [])
  def extract_length(["x" | compressed], length) do
    length = length
      |> Enum.reverse
      |> Enum.join
      |> String.to_integer
    {length, compressed}
  end
  def extract_length([char | compressed], length) do
    extract_length(compressed, [char | length])
  end

  def extract_times(compressed, times \\ [])
  def extract_times([")" | compressed], times) do
    times = times
      |> Enum.reverse
      |> Enum.join
      |> String.to_integer
    {times, compressed}
  end
  def extract_times([char | compressed], times) do
    extract_times(compressed, [char | times])
  end

  test "A(1x5)BC repeats only the B a total of 5 times, becoming ABBBBBC for a decompressed length of 7" do
    assert decompress("A(1x5)BC") == 7
  end

  test "(3x3)XYZ becomes XYZXYZXYZ for a decompressed length of 9" do
    assert decompress("(3x3)XYZ") == 9
  end

  test "A(2x2)BCD(2x2)EFG doubles the BC and EF, becoming ABCBCDEFEFG for a decompressed length of 11" do
    assert decompress("A(2x2)BCD(2x2)EFG") == 11
  end

  test "(6x1)(1x3)A simply becomes (1x3)A - the (1x3) looks like a marker, but because it's within a data section of another marker, it is not treated any differently from the A that comes after it. It has a decompressed length of 6" do
    assert decompress("(6x1)(1x3)A") == 6
  end

  test "X(8x2)(3x3)ABCY becomes X(3x3)ABC(3x3)ABCY (for a decompressed length of 18), because the decompressed data from the (8x2) marker (the (3x3)ABC) is skipped and not processed further" do
    assert decompress("X(8x2)(3x3)ABCY") == 18
  end

  test "decompress multiline" do
    assert decompress("(6x1)(1x3)A\nX(8x2)(3x3)ABCY") == 24
  end

  test "What is the decompressed length of the file" do
    assert File.read!("test/fixtures/input09.txt")
    |> decompress == 107035
  end
end
