defmodule Advent.IntcodeTest do
  use ExUnit.Case, async: true

  alias Advent.Intcode

  test "execution" do
    assert Intcode.execute([1,0,0,0,99]).program == [2,0,0,0,99]
    assert Intcode.execute([2,3,0,3,99]).program == [2,3,0,6,99]
    assert Intcode.execute([2,4,4,5,99,0]).program == [2,4,4,5,99,9801]

    state = Intcode.execute([1,1,1,4,99,5,6,0,99])
    assert state.pc == 8
    assert state.program == [30,1,1,4,2,5,6,0,99]
  end
end
