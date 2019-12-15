defmodule Advent.Day2 do
  def day2_1 do
    result = program()
             |> patch([{1, 12}, {2, 2}])
             |> execute
             |> Enum.at(0)
    IO.puts "Value at location 0 is #{result}"
  end

  def day2_2 do
    do_day2_2(program(), 0, 0)
  end

  def do_day2_2(program, a, 100), do: do_day2_2(program, a+1, 0)
  def do_day2_2(program, a, b) do
    val = program
          |> patch([{1, a}, {2, b}])
          |> execute
          |> Enum.at(0)
    case val do
      19690720 ->
        result = a * 100 + b
        IO.puts "#{result}"
      _ ->
        do_day2_2(program, a, b+1)
    end
  end

  def execute(program) do
    do_execute(program, 0)
  end

  def do_execute(program, pc) do
    case opcode = Enum.at(program, pc*4) do
      99 ->
        program
      _ ->
        lloc = Enum.at(program, pc*4+1)
        rloc = Enum.at(program, pc*4+2)
        dest = Enum.at(program, pc*4+3)
        eval_opcode(program, opcode, lloc, rloc, dest)
        |> do_execute(pc + 1)
    end
  end

  def eval_opcode(program, 1, lloc, rloc, dest) do
    lval = Enum.at(program, lloc)
    rval = Enum.at(program, rloc)
    patch(program, [{dest, lval + rval}])
  end

  def eval_opcode(program, 2, lloc, rloc, dest) do
    lval = Enum.at(program, lloc)
    rval = Enum.at(program, rloc)
    patch(program, [{dest, lval * rval}])
  end

  def patch(program, []), do: program

  def patch(program, [{at, val} | patches]) do
    program 
    |> List.replace_at(at, val)
    |> patch(patches)
  end

  def program do
    {:ok, contents} = File.read("priv/data/day_2.dat")
    contents
    |> String.replace("\n", "")
    |> String.split(",") 
    |> Enum.map(&String.to_integer/1)
  end
end
