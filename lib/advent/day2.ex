defmodule Advent.Day2 do
  alias Advent.Intcode
  alias Advent.Intcode.State

  def day2_1 do
    result = State.new(program())
             |> State.patch([{1, 12}, {2, 2}])
             |> Intcode.execute()
             |> State.get_memory_value(0)
    IO.puts "Value at location 0 is #{result}"
  end

  def day2_2 do
    do_day2_2(program(), 0, 0)
  end

  def do_day2_2(program, a, 100), do: do_day2_2(program, a+1, 0)
  def do_day2_2(program, a, b) do
    val = State.new(program())
          |> State.patch([{1, a}, {2, b}])
          |> Intcode.execute()
          |> State.get_memory_value(0)
    case val do
      19690720 ->
        result = a * 100 + b
        IO.puts "#{result}"
      _ ->
        do_day2_2(program, a, b+1)
    end
  end

  def program do
    {:ok, contents} = File.read("priv/data/day_2.dat")
    contents
    |> String.replace("\n", "")
    |> String.split(",") 
    |> Enum.map(&String.to_integer/1)
  end
end
