defmodule AdventOfCode04Test do
  use ExUnit.Case

  test "aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically" do
    assert real_room?("aaaaa-bbb-z-y-x-123[abxyz]") == true
  end

  def real_room?({name, _id, checksum}) do
    checksum(name) == checksum
  end
  def real_room?(room) do
    extract_room_details(room)
    |> real_room?
  end

  def extract_room_details(room) do
    [[_, name, id, checksum]] = Regex.scan(~r/(.*)-(.*)\[(\w{5})\]/, room)
    {name, id, checksum}
  end

  def checksum(name) do
    name
    |> String.replace("-", "")
    |> String.split("")
    |> Enum.slice(0..-2)
    |> Enum.group_by(&(&1))
    |> Enum.sort_by(fn({_, elements}) -> length(elements) end, &>=/2)
    |> Enum.map(fn({key, _}) -> key end)
    |> Enum.take(5)
    |> Enum.join
  end

  test "a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically" do
    assert real_room?("a-b-c-d-e-f-g-h-987[abcde]") == true
  end

  test "not-a-real-room-404[oarel] is a real room" do
    assert real_room?("not-a-real-room-404[oarel]") == true
  end

  test "totally-real-room-200[decoy] is not a real room" do
    assert real_room?("totally-real-room-200[decoy]") == false
  end

  test "Of the real rooms from the list above, the sum of their sector IDs is 1514" do
    assert id_sum("aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]\n") == 1514
  end

  def id_sum(input) do
    input
    |> String.split("\n")
    |> Enum.slice(0..-2)
    |> Enum.map(fn(room) -> extract_room_details(room) end)
    |> Enum.filter(&real_room?/1)
    |> Enum.reduce(0, fn({_, id, _}, sum) -> String.to_integer(id) + sum end)
  end

  test "What is the sum of the sector IDs of the real rooms?" do
    assert File.read!("test/fixtures/input04.txt")
    |> id_sum == 185371
  end

  test "the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name" do
    assert real_name({"qzmt-zixmtkozy-ivhz", "343", "zimth"}) == {"very encrypted name", "343"}
  end

  def real_name({name, id, _checksum}) do
    {real_name(to_charlist(name), String.to_integer(id)), id}
  end

  def real_name(decrypted_name, 0), do: decrypted_name |> to_string
  def real_name(encrypted_name, count) do
    real_name(decrypt(encrypted_name), count - 1)
  end

  def decrypt(_, _ \\ [])
  def decrypt([], decrypted_name), do: decrypted_name |> List.flatten |> Enum.reverse
  def decrypt([?- | encrypted_name], decrypted_name), do: decrypt(encrypted_name, [32, decrypted_name])
  def decrypt([32 | encrypted_name], decrypted_name), do: decrypt(encrypted_name, [?-, decrypted_name])
  def decrypt([encrypted_char | encrypted_name], decrypted_name) do
    decrypted_char = Stream.cycle(?a..?z)
      |> Stream.drop(encrypted_char - ?a + 1)
      |> Enum.take(1)
    decrypt(encrypted_name, [decrypted_char | decrypted_name])
  end

  test "decrypt" do
    assert decrypt(to_charlist("a- z")) == to_charlist("b -a")
  end

  test "What is the sector ID of the room where North Pole objects are stored?" do
    assert File.read!("test/fixtures/input04.txt")
    |> function_name == 984
  end

  def function_name(input) do
    input
    |> String.split("\n")
    |> Enum.slice(0..-2)
    |> Enum.map(fn(room) -> extract_room_details(room) end)
    |> Enum.filter(&real_room?/1)
    |> Enum.map(&real_name/1)
    |> Enum.filter(fn({name, _id}) -> name =~ "northpole-object-storage" end)
    |> List.first
    |> elem(1)
    |> String.to_integer
  end
end
