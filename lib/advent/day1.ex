defmodule Advent.Day1 do
  def day1_1 do
    fuel = fuel_for_initial_masses()
    IO.puts "Fuel requirement: #{fuel}"
  end

  def day1_2 do
    fuel = part_masses()
    |> Enum.map(&(calculate_recursive_fuel_for_mass(&1)))
    |> Enum.reduce(&+/2)
  end

  def calculate_fuel_for_masses(masses) when is_list(masses) do
    masses
    |> Enum.map(&(fuel_for_mass(&1)))
    |> Enum.reduce(&+/2)
  end

  def calculate_fuel_for_mass(mass) do
    fuel_for_mass(mass)
  end

  def calculate_recursive_fuel_for_mass(mass) do
    do_calculate_recursive_fuel_for_mass(0, mass)
  end

  def do_calculate_recursive_fuel_for_mass(acc, mass) do
    fuel = calculate_fuel_for_mass(mass)
    if mass <= 0 or fuel <= 0 do
      acc
    else
      do_calculate_recursive_fuel_for_mass(acc + fuel, fuel)
    end
  end

  def fuel_for_initial_masses do
    part_masses()
    |> Enum.map(&(calculate_fuel_for_masses([&1])))
    |> Enum.reduce(&+/2)
  end

  def part_masses do
    {:ok, contents} = File.read("priv/data/day_1_1.dat")
    contents |> String.slice(0..-2)
           |> String.split("\n")
           |> Enum.map(&(String.to_integer(&1)))
  end

  def fuel_for_mass(mass) do
    Enum.max([Integer.floor_div(mass, 3) - 2, 0])
  end
end
