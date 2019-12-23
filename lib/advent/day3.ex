defmodule Advent.Day3 do
  def day3_1(input \\ data())  do
    input
    |> parse()
    |> intersections()
    |> nearest()
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn instructions ->
      instructions
      |> String.split(",")
      |> build_path()
    end)
  end

  def build_path(instructions), do: do_build_path(instructions, {0, 0}, [], [])

  def do_build_path([], {_x, _y}, vert, horiz) do
    %{vertical: vert, horizontal: horiz}
  end

  def do_build_path([inst | instructions], {x, y}, vert, horiz) do
    {dir, len} = String.split_at(inst, 1)
    len = String.to_integer(len)

    case dir do
      "U" ->
        do_build_path(instructions, {x,y+len}, [{x, {y, y+len}} | vert], horiz)
      "D" ->
        do_build_path(instructions, {x,y-len}, [{x, {y, y-len}} | vert], horiz)
      "L" ->
        do_build_path(instructions, {x-len, y}, vert, [{y, {x, x-len}} | horiz])
      "R" ->
        do_build_path(instructions, {x+len, y}, vert, [{y, {x, x+len}} | horiz])
    end
  end

  def intersections([wire1, wire2]) do
    ints = Enum.reduce(wire1.vertical, [], fn {pos1, {from1, to1}}, acc ->
      Enum.reduce(wire2.horizontal, acc, fn {pos2, {from2, to2}}, acc2 ->
        if pos1 <= Enum.max([from2, to2]) && pos1 >= Enum.min([from2, to2])
        && pos2 <= Enum.max([from1, to1]) && pos2 >= Enum.min([from1, to1]) do
            [{pos1, pos2} | acc2]
        else
          acc2
        end
      end)
    end)
    Enum.reduce(wire1.horizontal, ints, fn {pos1, {from1, to1}}, acc ->
      Enum.reduce(wire2.vertical, acc, fn {pos2, {from2, to2}}, acc2 ->
        if pos1 <= Enum.max([from2, to2]) && pos1 >= Enum.min([from2, to2])
        && pos2 <= Enum.max([from1, to1]) && pos2 >= Enum.min([from1, to1]) do
            [{pos1, pos2} | acc2]
        else
          acc2
        end
      end)
    end)
  end

  def nearest(intersections) do
    intersections
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.reject(&(&1 == 0))
    |> Enum.min()
  end

  def data do
    {:ok, contents} = File.read("priv/data/day_3.dat")
    contents |> String.slice(0..-2)
  end
end
