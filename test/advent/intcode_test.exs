defmodule Advent.IntcodeTest do
  use ExUnit.Case, async: true

  alias Advent.Intcode

  test "patching" do
    assert Intcode.patch([1], [{0, 4}]) == [4]
    assert Intcode.patch([1, 2], [{0, 0}, {1, 3}]) == [0, 3]
  end

  test "execution" do
    assert Intcode.execute([1,0,0,0,99]) == [2,0,0,0,99]
    assert Intcode.execute([2,3,0,3,99]) == [2,3,0,6,99]
    assert Intcode.execute([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
    assert Intcode.execute([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
  end
end
