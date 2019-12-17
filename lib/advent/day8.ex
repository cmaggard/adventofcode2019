defmodule Advent.Day8 do
  def day8_1 do
    needle = Enum.chunk_every(data(), 25 * 6)
    |> Enum.map(&__MODULE__.count_all/1)
    |> Enum.sort(&(Map.get(&1, 0) < Map.get(&2, 0)))
    |> Enum.at(0)
    result = Map.get(needle, 1) * Map.get(needle, 2)
    IO.puts "Result: #{result}"
  end

  def day8_2 do
    message = Enum.chunk_every(data(), 25 * 6)
    |> Enum.zip()
    |> Enum.map(&(Tuple.to_list(&1)))
    |> Enum.map(fn pixel_layers ->
      Enum.find(pixel_layers, &(&1 in [0, 1]))
    end)
    |> Enum.chunk_every(25)
    |> Enum.each(fn list ->
      Enum.each(list, fn pixel ->
        x = cond do
          pixel == 0 -> " "
          pixel == 1 -> "O"
        end
        IO.write x
      end)
      IO.write "\n"
    end)
  end

  def count_all(range) do
    range
    |> Enum.sort()
    |> Enum.chunk_by(&(&1))
    |> Enum.map(fn list ->
      %{Enum.at(list, 0) => Enum.count(list)}
    end)
    |> Enum.reduce(%{}, &(Map.merge(&1, &2)))
  end

  def data do
    {:ok, contents} = File.read("priv/data/day_8.dat")
    contents
    |> String.replace("\n", "")
    |> String.split("", [trim: true])
    |> Enum.map(&String.to_integer/1)
  end
end
