defmodule Advent.Day5 do
  alias Advent.Intcode

  def day5_1 do
    program()
    |> Intcode.execute(false)
  end

  def day5_1_debug do
    program()
    |> Intcode.execute()
  end

  def program do
    {:ok, contents} = File.read("priv/data/day_5.dat")
    contents
    |> String.replace("\n", "")
    |> String.split(",") 
    |> Enum.map(&String.to_integer/1)
  end
end
