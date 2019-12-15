defmodule Advent.Intcode.State do
  @enforce_keys [:program]
  defstruct program: nil, pc: 0, debug: nil

  alias Advent.Intcode.Instruction

  def new(program, debug \\ false) do
    debugger = case debug do
      true -> &__MODULE__.log/1
      false -> &__MODULE__.noop/1
    end

    %__MODULE__{program: program, debug: debugger}
  end

  def get_instruction(state = %__MODULE__{program: program, pc: pc}) do
    inst_num = Enum.at(program, pc)
    opcode = rem(inst_num, 100)
    modes = div(inst_num, 100)
    first_mode = rem(modes, 10)
    second_mode = div(modes, 10)
    third_mode = div(modes, 100)
    instruction = %Instruction{opcode: opcode}
    cond do
      opcode == 99 ->
        instruction
      opcode in [1,2,5,6,7,8] ->
        %{instruction | left_val: Enum.at(program, pc + 1),
          right_val: Enum.at(program, pc + 2),
          dest_val: Enum.at(program, pc + 3),
          left_mode: first_mode,
          right_mode: second_mode,
          dest_mode: third_mode}
      opcode in [3, 4] ->
        %{instruction | opcode: opcode,
          dest_val: Enum.at(program, pc + 1),
          dest_mode: first_mode}
    end
  end

  def patch(state, []), do: state

  def patch(state, [{at, val} | patches]) do
    state.debug.("Patching #{at} with #{val}")
    new_program = List.replace_at(state.program, at, val)
    state.debug.(state.program)
    state.debug.(new_program)
    #%{state | program: new_program}
    #|> patch(patches)
    new_state = %{state | program: new_program}
    state.debug.(state)
    state.debug.(new_state)
    new_state |> patch(patches)
  end

  def get_memory_value(state, loc), do: Enum.at(state.program, loc)

  def noop(_), do: nil

  def log(text) when is_binary(text), do: IO.puts("  #{text}")
  def log(other), do: IO.inspect(other)
end
