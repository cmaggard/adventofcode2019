defmodule Advent.Day1 do
  def day1_1 do
    {:ok, contents} = File.read("priv/data/day_1_1.dat")
    nums = contents |> String.slice(0..-2)
           |> String.split("\n")
           |> Enum.map(&(String.to_integer(&1)))
    fuel = nums |> Enum.map(&(calculate_fuel(&1)))
           |> Enum.reduce(&+/2)
    IO.puts "Fuel requirement: #{fuel}"
  end

  defp calculate_fuel(num) do
    Integer.floor_div(num, 3) - 2
  end
end
