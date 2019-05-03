defmodule PockerTest do
  use ExUnit.Case
  doctest Pocker
  alias Pocker.Examples

  test "for diff kind" do
    Examples.diff_kind()
    |> Enum.each(fn example ->
      assert Pocker.compare(example.black, example.white) == example.result
    end)
  end

  test "for both high cards" do
    Examples.high_card_tie()
    |> Enum.each(fn example ->
      assert Pocker.compare(example.black, example.white) == example.result
    end)
  end

  test "for both pair" do
    Examples.pair_tie()
    |> Enum.each(fn example ->
      assert Pocker.compare(example.black, example.white) == example.result
    end)
  end
end
