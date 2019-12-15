defmodule Advent.Intcode do
  alias Advent.Intcode.State

  def execute(program, debug) when is_list(program) do
    State.new(program, debug)
    |> do_execute()
  end

  def execute(program) when is_list(program) do
    State.new(program, false)
    |> do_execute()
  end

  def execute(state) do
    do_execute(state)
  end

  def do_execute(state = %State{program: program, pc: pc, debug: debug}) do
    instruction = State.get_instruction(state)
    instruction = Enum.at(program, pc)
    modes = div(instruction, 100)
    opcode = rem(instruction, 100)
    debug.("  Program Counter: #{pc}")
    debug.("    I: #{instruction} O: #{opcode} M: #{modes}")
    cond do
      opcode == 99 ->
        state
      opcode == 3 ->
        dest = Enum.at(program, pc+1)
        new_state = eval_opcode(state, modes, opcode, dest)
        %{new_state | pc: pc + 2}
        |> do_execute()
      opcode == 4 ->
        dest = get_value(state, rem(modes, 10), Enum.at(program, pc+1))
        new_state = eval_opcode(state, modes, opcode, dest)
        %{new_state | pc: pc + 2}
        |> do_execute()
      opcode in [1,2,3] ->
        larg = get_value(state, rem(modes, 10), Enum.at(program, pc+1))
        rarg = get_value(state, div(modes, 10), Enum.at(program, pc+2))
        dest = Enum.at(program, pc+3)
        new_state = eval_opcode(state, modes, opcode, larg, rarg, dest)
        %{new_state | pc: pc + 4}
        |> do_execute()
      true ->
        IO.puts "PROGRAM ERROR: OPCODE #{opcode} ENCOUNTERED"
        IO.puts "HALTING."
    end
  end

  def eval_opcode(state, _modes, 1, lval, rval, dest) do
    state.debug.("Add #{lval} and #{rval}, store in #{dest}")
    State.patch(state, [{dest, lval + rval}])
  end

  def eval_opcode(state, _modes, 2, lval, rval, dest) do
    state.debug.("Multiply #{lval} and #{rval}, store in #{dest}")
    State.patch(state, [{dest, lval * rval}])
  end

  def eval_opcode(state, _modes, 3, dest) do
    val = IO.gets("Intcode input> ")
          |> String.replace("\n", "")
          |> String.to_integer()
    state.debug.("Store #{val} at #{dest}")
    State.patch(state, [{dest, val}])
  end

  def eval_opcode(state, _modes, 4, val) do
    state.debug.("Read #{val}")
    IO.puts "Intcode output: #{val}"
    state
  end

  def get_value(state, _imm = 0, val) do
    newval = Enum.at(state.program, val)
    state.debug.("  Get value at #{val} (#{newval})")
    newval
  end

  def get_value(_program, _imm = 1, val, debug) do
    debug.("  Literal value #{val}")
    val
  end

  def noop(_), do: nil

  def log(text) when is_binary(text), do: IO.puts("  #{text}")
  def log(other), do: IO.inspect(other)
end
