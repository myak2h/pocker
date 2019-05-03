defmodule PockerTest do
  use ExUnit.Case
  doctest Pocker

  test "greets the world" do
    assert Pocker.hello() == :world
  end
end
