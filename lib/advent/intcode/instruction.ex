defmodule Advent.Intcode.Instruction do
  @enforce_keys [:opcode]

  defstruct opcode: nil, left_val: nil, right_val: nil, dest_val: nil,
    left_mode: nil, right_mode: nil, dest_mode: nil

  def first_val(state, instruction) do
    eval_param(state, instruction.left_val, instruction.left_mode)
  end

  def second_val(state, instruction) do
    eval_param(state, instruction.right_val, instruction.right_mode)
  end

  def dest_val(state, instruction), do: instruction.dest_val

  def moded_dest_val(state, instruction) do
    eval_param(state, instruction.dest_val, instruction.dest_mode)
  end

  # parameter mode
  def eval_param(state, value, _mode = 0) do
    Enum.at(state.program, value)
  end

  # immediate mode
  def eval_param(state, value, _mode), do: value
end
