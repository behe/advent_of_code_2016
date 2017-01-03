defmodule AdventOfCode10Test do
  use ExUnit.Case

  @input """
  value 5 goes to bot 2
  bot 2 gives low to bot 1 and high to bot 0
  value 3 goes to bot 1
  bot 1 gives low to output 1 and high to bot 0
  bot 0 gives low to output 2 and high to output 0
  value 2 goes to bot 2
  """

  test "Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip" do
    assert parse(@input) == {
      %{"bot_1" => [3], "bot_2" => [2, 5]},
      [
        "bot 2 gives low to bot 1 and high to bot 0",
        "bot 1 gives low to output 1 and high to bot 0",
        "bot 0 gives low to output 2 and high to output 0"
      ]
    }
  end

  def parse(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.reduce({%{}, []}, &parse_instruction/2)
  end

  def parse_instruction(instruction, {state, instructions}) when is_binary(instruction) do
    case Regex.named_captures(~r/value (?<value>\d+) goes to bot (?<bot>\d+)/, instruction) do
      %{"bot" => bot, "value" => value} ->
        state = Map.update(state, "bot_#{bot}", [String.to_integer(value)], fn(values) ->
          [String.to_integer(value) | values]
        end)
        {state, instructions}
      _ -> {state, instructions ++ [instruction]}
    end
  end

  test "Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0" do
    state = %{
      "bot_1" => [3],
      "bot_2" => [2, 5]
    }
    assert give("bot 2 gives low to bot 1 and high to bot 0", {state, []}) == {:cont, {%{
      "bot_0" => [5],
      "bot_1" => [2, 3],
    }, []}}
  end

  def give(instruction, {state, instructions}) do
    case Regex.named_captures(~r/bot (?<bot>\d+) gives low to (?<low_name>\w+) (?<low>\d+) and high to (?<high_name>\w+) (?<high>\d+)/, instruction) do
      %{"bot" => bot, "low_name" => low_name, "low" => low, "high_name" => high_name, "high" => high} ->
        case Map.get(state, "bot_#{bot}") do
          [17, 61] -> {:halt, {bot, instructions}}
          [_, _] ->
            {values, state} = Map.pop(state, "bot_#{bot}")
            state = state
              |> Map.update("#{low_name}_#{low}", [Enum.min(values)], fn(lows) ->
                [Enum.min(values) | lows]
              end)
              |> Map.update("#{high_name}_#{high}", [Enum.max(values)], fn(highs) ->
                [Enum.max(values) | highs]
              end)
            {:cont, {state, instructions}}
            _ -> {:cont, {state, instructions ++ [instruction]}}
        end
      # otherwise -> IO.inspect(instruction); nil
      # _ -> {state, instructions ++ [instruction]}
    end
  end

  test "Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0" do
    state = %{
      "bot_0" => [5],
      "bot_1" => [2, 3],
    }
    assert give("bot 1 gives low to output 1 and high to bot 0", {state, []}) == {:cont, {%{
      "bot_0" => [3, 5],
      "output_1" => [2],
    }, []}}
  end

  test "Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0" do
    state = %{
      "bot_0" => [3, 5],
      "output_1" => [2],
    }
    assert give("bot 0 gives low to output 2 and high to output 0", {state, []}) == {:cont, {%{
      "output_0" => [5],
      "output_1" => [2],
      "output_2" => [3]
    }, []}}
  end

  test "what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips" do
    state = %{
      "bot_0" => [17, 61],
    }
    assert give("bot 0 gives low to output 2 and high to output 0", {state, []}) == {:halt, {"0", []}}
  end

  test "Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips" do
    assert File.read!("test/fixtures/input10.txt")
    |> parse
    |> give == "98"
  end

  def give({state, instructions}) do
    # IO.inspect length(instructions)
    # Enum.map(state, fn({key, value}) -> IO.inspect({key, Enum.map(value, &Integer.to_string/1)}) end)
    {state, remaining} = instructions
      |> Enum.reduce_while({state, []}, &give/2)
    cond do
      !is_map(state) -> state
      length(instructions) == length(remaining) -> state
      :otherwise -> give({state, remaining})
    end
  end
end
