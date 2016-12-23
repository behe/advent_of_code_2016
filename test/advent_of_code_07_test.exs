defmodule AdventOfCode07Test do
  use ExUnit.Case

  @moduletag :wip

  test "abba[mnop]qrst supports TLS (abba outside square brackets)" do
    assert "abba[mnop]qrst"
    |> supports_tls?
    == true
  end

  def supports_tls?(ipv7) do
    {_, ip_parts, hypernet_sequences} = ipv7
    |> String.split(~r/[\[\]]/)
    |> Enum.reduce({true,[],[]}, fn(val, {even, evens, odds}) ->
      if even do
        {!even, [val | evens], odds}
      else
        {!even, evens, [val | odds]}
      end
    end)

    supports_tls?(abba?(ip_parts), abba?(hypernet_sequences))
  end

  def supports_tls?(ip_part_abba, hypernet_abba), do: ip_part_abba && !hypernet_abba

  def abba?(rest), do: abba?([], rest, false)
  def abba?([], [], abba), do: abba

  def abba?([], [current | rest], abba) do
    abba?(to_charlist(current), rest, abba)
  end
  def abba?([a, b, b, a | _], _, _) when a != b do
    true
  end
  def abba?([_ | current], rest, abba) do
    abba?(current, rest, abba)
  end

  # defp supports_tls?(ip_part, ip_parts, hypernet_sequence, hypernet_sequences, ip_part_abba \\ false, hypernet_abba \\ false)
  # defp supports_tls?([], [], [], [], ip_part_abba, hypernet_abba), do: ip_part_abba && !hypernet_abba
  # defp supports_tls?([], [], [a, b, b, a | _], ip_part_abba, _) do
  #   supports_tls?([], [], [], ip_part_abba, true)
  # end
  # defp supports_tls?([], [], [_ | rest], ip_part_abba, hypernet_abba) do
  #   supports_tls?([], [], rest, ip_part_abba, hypernet_abba)
  # end
  # defp supports_tls?([], [ip_part | rest], hypernet_sequence, _, _) do
  #   supports_tls?(to_charlist(ip_part), rest, hypernet_sequence)
  # end
  # defp supports_tls?([a, b, b, a | _], _, hypernet_sequence, _, hypernet_abba) when a != b do
  #   supports_tls?([], [], hypernet_sequence, true, hypernet_abba)
  # end
  # defp supports_tls?([_ | rest], ip_parts, hypernet_sequence, ip_part_abba, hypernet_abba) do
  #   supports_tls?(rest, ip_parts, hypernet_sequence, ip_part_abba, hypernet_abba)
  # end

  test "abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets)" do
    assert "abcd[bddb]xyyx"
    |> supports_tls?
    == false
  end

  test "aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different)" do
    assert "aaaa[qwer]tyui"
    |> supports_tls?
    == false
  end

  test "ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string)" do
    assert "ioxxoj[asdfgh]zxcvbn"
    |> supports_tls?
    == true
  end

  test "ioxxoj[asdfgh]zxcvbn[asdfgh]zxcvbn supports TLS" do
    assert "ioxxoj[asdfgh]zxcvbn[asdfgh]zxcvbn"
    |> supports_tls?
    == true
  end

  test "How many IPs in your puzzle input support TLS?" do
    assert File.read!("test/fixtures/input07.txt")
    |> parse
    |> Enum.filter(&supports_tls?/1)
    |> length
    == 105
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.slice(0..-2)
  end
end
