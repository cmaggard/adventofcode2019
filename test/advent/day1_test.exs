defmodule Advent.Day1Test do
  use ExUnit.Case, async: true

  alias Advent.Day1

  test "fuel should calculate correctly for a mass" do
    assert Day1.fuel_for_mass(14) == 2
    assert Day1.fuel_for_mass(1969) == 654
    assert Day1.fuel_for_mass(100_756) == 33583
  end

  test "fuel requirements < 0 should be set to 0" do
    assert Day1.fuel_for_mass(1) == 0
  end

  test "fuel for multiple masses should calculate correctly" do
    assert Day1.calculate_fuel_for_masses([14, 1969, 100_756]) == 2 + 654 + 33583
  end

  test "recursive fuel count should work" do
    assert Day1.do_day1_2({0, 14}) == 2
    assert Day1.do_day1_2({0, 1969}) == 966
    assert Day1.do_day1_2({0, 100756}) == 50346
  end
end
