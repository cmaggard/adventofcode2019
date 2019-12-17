defmodule Advent.Intcode do
  alias Advent.Intcode.State
  alias Advent.Intcode.Instruction

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

  def do_execute(state) do
    instruction = State.get_instruction(state)
    cond do
      instruction.opcode == 99 ->
        state
      instruction.opcode in 1..8 ->
        state
        |> eval_instruction(instruction)
        |> do_execute()
      true ->
        IO.puts "PROGRAM ERROR: OPCODE #{instruction.opcode} ENCOUNTERED"
        IO.puts "HALTING."
        state
    end
  end

  # Add two values
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 1 do
    dest = Instruction.dest_val(state, instruction)
    lval = Instruction.first_val(state, instruction)
    rval = Instruction.second_val(state, instruction)

    state.debug.("Add #{lval} and #{rval}, store in #{dest}")

    state
    |> State.patch([{dest, lval + rval}])
    |> State.set_pc(state.pc + 4)
  end

  # Multiply two values
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 2 do
    dest = Instruction.dest_val(state, instruction)
    lval = Instruction.first_val(state, instruction)
    rval = Instruction.second_val(state, instruction)

    state.debug.("Multiply #{lval} and #{rval}, store in #{dest}")

    state
    |> State.patch([{dest, lval * rval}])
    |> State.set_pc(state.pc + 4)
  end

  # Input value, store to location
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 3 do
    dest = Instruction.dest_val(state, instruction)

    val = IO.gets("Intcode input> ")
          |> String.replace("\n", "")
          |> String.to_integer()

    state.debug.("Store #{val} at #{dest}")

    state
    |> State.patch([{dest, val}])
    |> State.set_pc(state.pc + 2)
  end

  # Output value of location
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 4 do
    dest = Instruction.moded_dest_val(state, instruction)
    IO.puts "Intcode output: #{dest}"

    state
    |> State.set_pc(state.pc + 2)
  end

  # Jump if true
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 5 do
    dest = Instruction.moded_dest_val(state, instruction)
    lval = Instruction.first_val(state, instruction)

    state.debug.("Jump-if-true on #{lval} to #{dest}")

    if lval != 0 do
      state
      |> State.set_pc(dest)
    else
      state
      |> State.set_pc(state.pc + 3)
    end
  end

  # Jump if false
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 6 do
    dest = Instruction.moded_dest_val(state, instruction)
    lval = Instruction.first_val(state, instruction)

    state.debug.("Jump-if-false on #{lval} to #{dest}")

    if lval == 0 do
      state
      |> State.set_pc(dest)
    else
      state
      |> State.set_pc(state.pc + 3)
    end
  end

  # Less than
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 7 do
    dest = Instruction.dest_val(state, instruction)
    lval = Instruction.first_val(state, instruction)
    rval = Instruction.second_val(state, instruction)

    store = if lval < rval do
      1
    else
      0
    end

    state.debug.("Testing #{lval} < #{rval}, storing #{store} to #{dest}")

    state
    |> State.patch([{dest, store}])
    |> State.set_pc(state.pc + 4)
  end

  # Equals
  def eval_instruction(state, instruction = %{opcode: opcode}) when opcode == 8 do
    dest = Instruction.dest_val(state, instruction)
    lval = Instruction.first_val(state, instruction)
    rval = Instruction.second_val(state, instruction)

    store = if lval == rval do
      1
    else
      0
    end

    state.debug.("Testing #{lval} = #{rval}, storing #{store} to #{dest}")

    state
    |> State.patch([{dest, store}])
    |> State.set_pc(state.pc + 4)
  end
end
