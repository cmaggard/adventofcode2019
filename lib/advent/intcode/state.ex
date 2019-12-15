defmodule Advent.Intcode.State do
  @enforce_keys [:program]
  defstruct program: nil, pc: 0, debug: nil

  def new(program, debug \\ false) do
    debugger = case debug do
      true -> &__MODULE__.log/1
      false -> &__MODULE__.noop/1
    end

    %__MODULE__{program: program, debug: debugger}
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

  def noop(_), do: nil

  def log(text) when is_binary(text), do: IO.puts("  #{text}")
  def log(other), do: IO.inspect(other)
end
