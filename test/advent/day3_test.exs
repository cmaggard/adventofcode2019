defmodule Advent.Day3Test do
  use ExUnit.Case, async: true

  alias Advent.Day3

  test "input parsing" do
    test1 = "U3,R3\nD4,L4"
    assert Day3.parse(test1) == [
      %{vertical: [{0, {0, 3}}], horizontal: [{3, {0, 3}}]},
      %{vertical: [{0, {0, -4}}], horizontal: [{-4, {0, -4}}]},
    ]
  end

  test "it should calculate the nearest intersection" do
    test0 = "R8,U5,L5,D3\nU7,R6,D4,L4"
    assert Day3.day3_1(test0) == 6
    test1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
    assert Day3.day3_1(test1) == 159
    test2 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    assert Day3.day3_1(test2) == 135
  end
end

