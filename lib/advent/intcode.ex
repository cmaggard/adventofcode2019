defmodule Advent.Intcode do
  def execute(program, debug \\ true) do
    debugger = case debug do
      true -> &__MODULE__.log/1
      false -> &__MODULE__.noop/1
    end
    do_execute(program, 0, debugger)
  end

  def do_execute(program, pc, debug) do
    debug.(program)
    instruction = Enum.at(program, pc)
    modes = div(instruction, 100)
    opcode = rem(instruction, 100)
    debug.("  Program Counter: #{pc}")
    debug.("    I: #{instruction} O: #{opcode} M: #{modes}")
    cond do
      opcode == 99 ->
        program
      opcode == 3 ->
        dest = Enum.at(program, pc+1)
        eval_opcode(program, modes, opcode, dest, debug)
        |> do_execute(pc + 2, debug)
      opcode == 4 ->
        dest = get_value(program, rem(modes, 10), Enum.at(program, pc+1), debug)
        eval_opcode(program, modes, opcode, dest, debug)
        |> do_execute(pc + 2, debug)
      opcode in [1,2,3] ->
        larg = get_value(program, rem(modes, 10), Enum.at(program, pc+1), debug)
        rarg = get_value(program, div(modes, 10), Enum.at(program, pc+2), debug)
        dest = Enum.at(program, pc+3)
        eval_opcode(program, modes, opcode, larg, rarg, dest, debug)
        |> do_execute(pc + 4, debug)
      true ->
        IO.puts "PROGRAM ERROR: OPCODE #{opcode} ENCOUNTERED"
        IO.puts "HALTING."
    end
  end

  def eval_opcode(program, _modes, 1, lval, rval, dest, debug) do
    debug.("Add #{lval} and #{rval}, store in #{dest}")
    patch(program, [{dest, lval + rval}])
  end

  def eval_opcode(program, _modes, 2, lval, rval, dest, debug) do
    debug.("Multiply #{lval} and #{rval}, store in #{dest}")
    patch(program, [{dest, lval * rval}])
  end

  def eval_opcode(program, _modes, 3, dest, debug) do
    val = IO.gets("Intcode input> ")
          |> String.replace("\n", "")
          |> String.to_integer()
    debug.("Store #{val} at #{dest}")
    patch(program, [{dest, val}])
  end

  def eval_opcode(program, _modes, 4, val, debug) do
    debug.("Read #{val}")
    IO.puts "Intcode output: #{val}"
    program
  end

  def get_value(program, _imm = 0, val, debug) do
    newval = Enum.at(program, val)
    debug.("  Get value at #{val} (#{newval})")
    newval
  end

  def get_value(_program, _imm = 1, val, debug) do
    debug.("  Literal value #{val}")
    val
  end

  def patch(program, []), do: program

  def patch(program, [{at, val} | patches]) do
    new_program = program 
    |> List.replace_at(at, val)
    |> patch(patches)
  end

  def noop(text), do: nil

  def log(text) when is_binary(text), do: IO.puts("  #{text}")

  def log(other), do: IO.inspect(other)
end
