defmodule PockerTest do
  use ExUnit.Case
  doctest Pocker

  test "for all senarios" do
    Pocker.Examples.all_scenarios()
    |> Enum.each(fn example ->
      assert Pocker.compare(example.black, example.white) == example.result
    end)
  end
end
