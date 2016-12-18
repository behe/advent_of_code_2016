defmodule AdventOfCode05Test do
  use ExUnit.Case

  @moduletag timeout: 60_000

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
      IO.puts password
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
end
