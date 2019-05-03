defmodule Pocker.Examples do
  @kinds [
    "High Card",
    "Pair",
    "Two Pairs",
    "Three of a Kind",
    "Straight",
    "Flush",
    "Full House",
    "Four of a Kind",
    "Straight Flush"
  ]

  @each_kind [
    ["QS", "4S", "9S", "KC", "AC"],
    ["9D", "9H", "8C", "TH", "QH"],
    ["5H", "5S", "6H", "6S", "8S"],
    ["JD", "JH", "JS", "4H", "5D"],
    ["8H", "9C", "TC", "JC", "QC"],
    ["4D", "6D", "8D", "TD", "QD"],
    ["3D", "3H", "3S", "2H", "2S"],
    ["7C", "7D", "7H", "7S", "2D"],
    ["2C", "3C", "4C", "5C", "6C"]
  ]

  def diff_kind do
    Range.new(0, 8)
    |> Enum.map(fn i ->
      if i != 8 do
        Range.new(i + 1, 8)
        |> Enum.map(fn j ->
          %{
            black: Enum.at(@each_kind, i),
            white: Enum.at(@each_kind, j),
            result: "White wins - #{Enum.at(@kinds, j)}"
          }
        end)
      else
        []
      end ++
        if(i != 0) do
          Range.new(0, i - 1)
          |> Enum.map(fn j ->
            %{
              black: Enum.at(@each_kind, i),
              white: Enum.at(@each_kind, j),
              result: "Black wins - #{Enum.at(@kinds, i)}"
            }
          end)
        else
          []
        end
    end)
    |> Enum.concat()
  end

  def high_card_tie do
    [
      %{
        black: ["QS", "4S", "9S", "KC", "AC"],
        white: ["4D", "2S", "3S", "5C", "8C"],
        result: "Black wins - High Card: A"
      },
      %{
        black: ["QS", "4S", "9S", "KC", "AC"],
        white: ["QD", "4D", "9D", "KH", "AS"],
        result: "Tie"
      }
    ]
  end

  def pair_tie do
    [
      %{
        black: ["9D", "9H", "8C", "TH", "QH"],
        white: ["TC", "TD", "3S", "5D", "8H"],
        result: "White wins - Pair: T"
      },
      %{
        black: ["9D", "9H", "8C", "TH", "QH"],
        white: ["9C", "9S", "3S", "5D", "8H"],
        result: "Black wins - Pair: Q"
      },
      %{
        black: ["9D", "9H", "8C", "TH", "QH"],
        white: ["9C", "9S", "8D", "TD", "QC"],
        result: "Tie"
      }
    ]
  end
end
