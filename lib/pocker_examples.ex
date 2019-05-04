defmodule Pocker.Examples do
  @kinds [
    "high card",
    "pair",
    "two pairs",
    "three of a kind",
    "straight",
    "flush",
    "full house",
    "four of a kind",
    "straight flush"
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

  # one example for each scenario where the two hands have different kind Ex: flush and pair
  defp diff_kind do
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

  # Examples for scenarios where the two hands are the same e.g high card and high card
  defp high_card_tie do
    [
      %{
        black: ["QS", "4S", "9S", "KC", "AC"],
        white: ["4D", "2S", "3S", "5C", "8C"],
        result: "Black wins - high card: Ace"
      },
      %{
        black: ["QS", "4S", "9S", "KC", "AC"],
        white: ["QD", "4D", "9D", "KH", "AS"],
        result: "Tie"
      }
    ]
  end

  defp pair_tie do
    [
      %{
        black: ["9D", "9H", "8C", "TH", "QH"],
        white: ["TC", "TD", "3S", "5D", "8H"],
        result: "White wins - pair: 10"
      },
      %{
        black: ["9D", "9H", "8C", "TH", "QH"],
        white: ["9C", "9S", "3S", "5D", "8H"],
        result: "Black wins - pair: Queen"
      },
      %{
        black: ["9D", "9H", "8C", "TH", "QH"],
        white: ["9C", "9S", "8D", "TD", "QC"],
        result: "Tie"
      }
    ]
  end

  defp two_pair_tie do
    [
      %{
        black: ["9D", "9H", "8C", "8D", "QH"],
        white: ["TC", "TD", "3S", "3D", "8H"],
        result: "White wins - two pairs: 10"
      },
      %{
        black: ["9D", "9H", "8C", "8D", "QH"],
        white: ["9C", "9S", "3S", "3D", "8H"],
        result: "Black wins - two pairs: 8"
      },
      %{
        black: ["9D", "9H", "8C", "8D", "QH"],
        white: ["9C", "9S", "8S", "8H", "7H"],
        result: "Black wins - two pairs: Queen"
      },
      %{
        black: ["9D", "9H", "8C", "8D", "QH"],
        white: ["9C", "9S", "8S", "8H", "QS"],
        result: "Tie"
      }
    ]
  end

  defp three_of_a_kind_tie do
    [
      %{
        black: ["9D", "9H", "9C", "8D", "QH"],
        white: ["TC", "TD", "TS", "3D", "8H"],
        result: "White wins - three of a kind: 10"
      }
    ]
  end

  defp straight_tie do
    [
      %{
        black: ["2H", "3C", "4D", "5H", "6H"],
        white: ["3C", "4H", "5S", "6D", "7D"],
        result: "White wins - straight: 7"
      },
      %{
        black: ["2H", "3C", "4D", "5H", "6H"],
        white: ["2C", "3D", "4S", "5D", "6D"],
        result: "Tie"
      }
    ]
  end

  defp flush_tie do
    [
      %{
        black: ["2H", "4H", "9H", "5H", "6H"],
        white: ["2C", "3C", "4C", "6C", "9C"],
        result: "Black wins - flush: 5"
      },
      %{
        black: ["2H", "4H", "9H", "5H", "6H"],
        white: ["2C", "5C", "4C", "6C", "9C"],
        result: "Tie"
      }
    ]
  end

  defp full_house_tie do
    [
      %{
        black: ["2H", "2D", "2S", "5H", "5D"],
        white: ["3C", "3D", "3H", "6C", "6D"],
        result: "White wins - full house: 3"
      }
    ]
  end

  defp four_of_a_kind_tie do
    [
      %{
        black: ["2H", "2D", "2S", "2C", "5D"],
        white: ["3C", "3D", "3H", "3S", "6D"],
        result: "White wins - four of a kind: 3"
      }
    ]
  end

  defp straight_flush_tie do
    [
      %{
        black: ["2H", "3H", "4H", "5H", "6H"],
        white: ["3C", "4C", "5C", "6C", "7C"],
        result: "White wins - straight flush: 7"
      },
      %{
        black: ["2H", "3H", "4H", "5H", "6H"],
        white: ["2C", "3C", "4C", "5C", "6C"],
        result: "Tie"
      }
    ]
  end

  def all_scenarios do
    diff_kind() ++
      high_card_tie() ++
      pair_tie() ++
      two_pair_tie() ++
      three_of_a_kind_tie() ++
      straight_tie() ++
      flush_tie() ++ full_house_tie() ++ four_of_a_kind_tie() ++ straight_flush_tie()
  end
end
