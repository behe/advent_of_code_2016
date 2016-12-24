defmodule AdventOfCode07Test do
  use ExUnit.Case

  test "abba[mnop]qrst supports TLS (abba outside square brackets)" do
    assert supports_tls?("abba[mnop]qrst") == true
  end

  def supports_tls?(ipv7) do
    {_, supernet_sequences, hypernet_sequences} = ipv7
    |> String.split(~r/[\[\]]/)
    |> Enum.reduce({true, [], []}, fn(val, {even, evens, odds}) ->
      if even do
        {!even, [val | evens], odds}
      else
        {!even, evens, [val | odds]}
      end
    end)

    supports_tls?(abba?(supernet_sequences), abba?(hypernet_sequences))
  end

  def supports_tls?(supernet_sequence_abba, hypernet_abba), do: supernet_sequence_abba && !hypernet_abba

  def abba?(rest), do: abba?([], rest, false)

  def abba?([], [], abba), do: abba
  def abba?([], [current | rest], abba) do
    abba?(to_charlist(current), rest, abba)
  end
  def abba?([a, b, b, a | _], _, _) when a != b, do: true
  def abba?([_ | current], rest, abba) do
    abba?(current, rest, abba)
  end

  test "abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets)" do
    assert supports_tls?("abcd[bddb]xyyx") == false
  end

  test "aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different)" do
    assert supports_tls?("aaaa[qwer]tyui") == false
  end

  test "ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string)" do
    assert supports_tls?("ioxxoj[asdfgh]zxcvbn") == true
  end

  test "ioxxoj[asdfgh]zxcvbn[asdfgh]zxcvbn supports TLS" do
    assert supports_tls?("ioxxoj[asdfgh]zxcvbn[asdfgh]zxcvbn") == true
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

  test "aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets)" do
    assert supports_ssl?("aba[bab]xyz") == true
  end

  def supports_ssl?(ipv7) do
    {_, supernet_sequences, hypernet_sequences} = ipv7
    |> String.split(~r/[\[\]]/)
    |> Enum.reduce({true,[],[]}, fn(val, {even, evens, odds}) ->
      if even do
        {!even, [val | evens], odds}
      else
        {!even, evens, [val | odds]}
      end
    end)

    aba(supernet_sequences)
    |> supports_ssl?(hypernet_sequences)
  end

  def aba(supernet_sequences) do
    supernet_sequences
    |> Enum.flat_map(fn(supernet_sequence) ->
      supernet_sequence
      |> to_charlist
      |> Enum.chunk(3, 1)
    end)
    |> Enum.filter(&aba?/1)
    |> Enum.map(&to_string/1)
  end

  def aba?([]), do: false
  def aba?([a, b, a | _]) when a != b, do: true
  def aba?([_ | rest]), do: aba?(rest)

  def supports_ssl?(abas, hypernet_sequences) do
    babs = aba(hypernet_sequences)
    abas
    |> Enum.any?(fn(aba) ->
      [a, b, a] = aba |> to_charlist
      bab = [b,a,b] |> to_string
      Enum.member?(babs, bab)
    end)
  end

  test "xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy)" do
    assert supports_ssl?("xyx[xyx]xyx") == false
  end

  test "aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different)" do
    assert supports_ssl?("aaa[kek]eke") == true
  end

  test "zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap)" do
    assert supports_ssl?("zazbz[bzb]cdb") == true
  end

  test "How many IPs in your puzzle input support SSL?" do
    assert File.read!("test/fixtures/input07.txt")
    |> parse
    |> Enum.filter(&supports_ssl?/1)
    |> length
    == 258
  end
end
