defmodule AdventOfCode05Test do
  use ExUnit.Case

  @moduletag timeout: 120_000

  describe "if the Door ID is abc" do
    test "the first character of the password, is 1" do
      assert next_character("abc") == {"1", 3231929}
    end

    test "the second character of the password is 8" do
      assert next_character("abc", 3231929) == {"8", 5017308}
    end

    test "The third time a hash starts with five zeroes is for abc5278568, discovering the character f" do
      assert next_character("abc", 5017308) == {"f", 5278568}
    end

    test "the password is 18f47a30" do
      assert password("abc") == "18f47a30"
    end
  end

  test "Given the actual Door ID, what is the password?" do
    assert password("uqwqemis") == "1a3099aa"
  end

  def password(door_id) do
    1..8
    |> Enum.reduce({"", -1}, fn(_, {password, index}) ->
      {char, index} = next_character(door_id, index)
      password = password <> char
      {password, index}
    end)
    |> elem(0)
  end

  def next_character(door_id, index \\ -1), do: next_character("", door_id, index)

  defp next_character("00000" <> char, _door_id, index), do: {String.at(char, 0), index}
  defp next_character(_hash, door_id, index) do
    index = index + 1
    [door_id, to_string(index)]
    |> :erlang.md5
    |> Base.encode16(case: :lower)
    |> next_character(door_id, index)
  end

  describe "hash now also indicates the position within the password to fill" do
    test "The first interesting hash is from abc3231929, which produces 0000015...; so, 5 goes in position 1" do
      assert next_position_character("abc") == {%{"1" => "5"}, 3231929}
    end

    test "The second interesting hash is at index 5357525, which produces 000004e" do
      assert next_position_character("abc", %{"1" => "5"}, 3231929) == {%{"1" => "5", "4" => "e"}, 5357525}
    end

    test "You almost choke on your popcorn as the final character falls into place, producing the password 05ace8e3" do
      assert password2("abc") == "05ace8e3"
    end
  end

  test "Given the actual Door ID and this new method, what is the password?" do
    assert password2("uqwqemis") == "694190cd"
  end

  def password2(door_id) do
    1..8
    |> Enum.reduce({%{}, -1}, fn(_, {map, index}) ->
      {map, index} = next_position_character(door_id, map, index)
      IO.puts password_for(map)
      {map, index}
    end)
    |> elem(0)
    |> password_for
  end

  def password_for(map) do
    0..7
    |> Enum.map(fn(key) ->
      Map.get(map, to_string(key), "_")
    end)
    |> to_string
  end

  def next_position_character(door_id, map \\ %{}, index \\ -1), do: next_position_character("", map, door_id, index)

  defp next_position_character("00000" <> char, map, door_id, index) do
    with(position = String.at(char, 0),
      true <- position in (0..7 |> Enum.map(&Integer.to_string/1)),
      false <- Map.has_key?(map, position)) do
      {Map.put(map, position, String.at(char, 1)), index}
    else
      _ ->
        next_position_character("", map, door_id, index)
    end
  end
  defp next_position_character(_hash, map, door_id, index) do
    index = index + 1
    [door_id, to_string(index)]
    |> :erlang.md5
    |> Base.encode16(case: :lower)
    |> next_position_character(map, door_id, index)
  end
end
