defmodule Advent.IntcodeTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Advent.Intcode
  alias Advent.Intcode.State

  test "execution" do
    assert Intcode.execute(State.new([1,0,0,0,99])).program == [2,0,0,0,99]
    assert Intcode.execute([2,3,0,3,99]).program == [2,3,0,6,99]
    assert Intcode.execute([2,4,4,5,99,0]).program == [2,4,4,5,99,9801]

    state = Intcode.execute([1,1,1,4,99,5,6,0,99])
    assert state.pc == 8
    assert state.program == [30,1,1,4,2,5,6,0,99]
  end

  test "i/o execution" do
    # [JUMP] If input is 0, output 0 (positional mode)
    assert capture_io([input: "0", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]))
    end) == "Intcode output: 0\n"
    assert capture_io([input: "1", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]))
    end) == "Intcode output: 1\n"

    # [JUMP] If input is 0, output 0 (immediate mode)
    assert capture_io([input: "0", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,3,1105,-1,9,1101,0,0,12,4,12,99,1]))
    end) == "Intcode output: 0\n"
    assert capture_io([input: "1", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,3,1105,-1,9,1101,0,0,12,4,12,99,1]))
    end) == "Intcode output: 1\n"

    # If input < 8, output 1 (positional mode)
    assert capture_io([input: "7", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,9,7,9,10,9,4,9,99,-1,8]))
    end) == "Intcode output: 1\n"
    assert capture_io([input: "8", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,9,7,9,10,9,4,9,99,-1,8]))
    end) == "Intcode output: 0\n"

    # If input < 8, output 1 (immediate mode)
    assert capture_io([input: "7", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,3,1107,-1,8,3,4,3,99]))
    end) == "Intcode output: 1\n"
    assert capture_io([input: "8", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,3,1107,-1,8,3,4,3,99]))
    end) == "Intcode output: 0\n"

    # If input == 8, output 1 (positional mode)
    assert capture_io([input: "8", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,9,8,9,10,9,4,9,99,-1,8]))
    end) == "Intcode output: 1\n"
    assert capture_io([input: "1", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,9,8,9,10,9,4,9,99,-1,8]))
    end) == "Intcode output: 0\n"

    # If input == 8, output 1 (immediate mode)
    assert capture_io([input: "8", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,3,1108,-1,8,3,4,3,99]))
    end) == "Intcode output: 1\n"
    assert capture_io([input: "1", capture_prompt: false], fn ->
      Intcode.execute(State.new([3,3,1108,-1,8,3,4,3,99]))
    end) == "Intcode output: 0\n"
  end
end
