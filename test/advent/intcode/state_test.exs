defmodule Advent.Intcode.StateTest do
  use ExUnit.Case, async: true

  alias Advent.Intcode.State

  def factory(program), do: State.new(program)

  test "patching" do
    assert State.patch(factory([1]), [{0, 4}]).program == [4]
    assert State.patch(factory([1, 2]), [{0, 0}, {1, 3}]).program == [0, 3]
  end

  test "get_instruction three-param" do
    state = factory([1, 2, 3, 4])
    instruction = State.get_instruction(state)
    assert instruction.opcode == 1
    assert instruction.left_val == 2
    assert instruction.right_val == 3
    assert instruction.dest_val == 4
  end
end
