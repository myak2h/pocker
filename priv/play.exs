defmodule Pocker.Play do
  def new() do
    IO.puts("New Game!")
    black = IO.gets("Black: ") |> String.trim() |> String.split(" ")

    if Pocker.is_valid_hand(black) do
      white = IO.gets("White: ") |> String.trim() |> String.split(" ")

      if Pocker.is_valid_hand(white) && Pocker.are_unique(black, white) do
        IO.puts(Pocker.compare(black, white))
      else
        IO.puts("Invalid hand!")
      end
    else
      IO.puts("Invalid hand!")
    end

    if IO.gets("Play again? (y/n): ") |> String.trim() == "y" do
      Pocker.Play.new()
    end
  end
end

Pocker.Play.new()
