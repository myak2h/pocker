defmodule Pocker do
  @values ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
  @value_names ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]
  @suits ["C", "D", "H", "S"]
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

  # this is to generate two random hands - [black, white]
  def generate_hands() do
    @values
    |> Enum.map(fn v -> @suits |> Enum.map(fn s -> v <> s end) end)
    |> Enum.concat()
    |> Enum.take_random(10)
    |> Enum.chunk_every(5)
  end

  # this is to get the index of the value of a card in @values
  defp value_index(card) do
    @values |> Enum.find_index(&(&1 == card |> String.first()))
  end

  # this is to get the index of a kind in @kinds
  defp kind_index(kind) do
    @kinds |> Enum.find_index(&(&1 == kind))
  end

  # checks if a hand has consecutive cards
  defp is_consc(hand) do
    case hand do
      [_ | []] ->
        true

      [h | t] ->
        if value_index(h) == value_index(hd(t)) + 1 do
          is_consc(t)
        else
          false
        end
    end
  end

  # checks if a hand has all same suit
  defp is_flush(hand) do
    hand
    |> Enum.map(&String.last/1)
    |> Enum.uniq()
    |> length() == 1
  end

  # group cards by thier values and puts them in descending order of
  # the length of the group and the value of the group
  # EX: ["9C", "5C", "3H", "5D", "3C"] to [["5C", "5D"], ["3C", "3H"], ["9C"]]
  defp group_by_values(hand) do
    hand
    |> Enum.group_by(&String.first/1)
    |> Map.values()
    |> Enum.sort(fn x, y ->
      if length(x) != length(y) do
        length(x) > length(y)
      else
        value_index(hd(x)) > value_index(hd(y))
      end
    end)
  end

  # returns the kind of a hand
  defp get_kind(hand) do
    hand =
      hand
      |> Enum.sort(&(value_index(&1) > value_index(&2)))

    case group_by_values(hand) |> Enum.map(&length/1) do
      [1, 1, 1, 1, 1] ->
        case {is_flush(hand), is_consc(hand)} do
          {true, true} -> "straight flush"
          {false, true} -> "straight"
          {true, false} -> "flush"
          {false, false} -> "high card"
        end

      [2, 1, 1, 1] ->
        "pair"

      [2, 2, 1] ->
        "two pairs"

      [3, 1, 1] ->
        "three of a kind"

      [3, 2] ->
        "full house"

      [4, 1] ->
        "four of a kind"
    end
  end

  # compare two hands of same type
  defp compare_grouped(hand1, hand2) do
    case {hand1, hand2} do
      {[], []} ->
        %{winner: "tie", high: nil}

      {[h1 | t1], [h2 | t2]} ->
        if(String.first(hd(h1)) == String.first(hd(h2))) do
          compare_grouped(t1, t2)
        else
          if value_index(hd(h1)) > value_index(hd(h2)) do
            %{winner: "black", high: @value_names |> Enum.at(value_index(hd(h1)))}
          else
            %{winner: "white", high: @value_names |> Enum.at(value_index(hd(h2)))}
          end
        end
    end
  end

  # compare two hands and returns the final result
  def compare(hand1, hand2) do
    kind1 = get_kind(hand1)
    kind2 = get_kind(hand2)

    case kind1 == kind2 do
      false ->
        if kind_index(kind1) > kind_index(kind2) do
          "Black wins - #{kind1}"
        else
          "White wins - #{kind2}"
        end

      true ->
        case compare_grouped(group_by_values(hand1), group_by_values(hand2)) do
          %{winner: "black", high: high} -> "Black wins - #{kind1}: #{high}"
          %{winner: "white", high: high} -> "White wins - #{kind2}: #{high}"
          %{winner: "tie", high: _} -> "Tie"
        end
    end
  end

  # checks that a hand is a valid hand
  def is_valid_hand(hand) do
    length(Enum.uniq(hand)) == 5 &&
      hand
      |> Enum.reduce(true, fn x, acc ->
        acc && String.length(x) == 2 && @values |> Enum.member?(String.first(x)) &&
          @suits |> Enum.member?(String.last(x))
      end)
  end

  # checks that two hands dont have same card
  def are_unique(hand1, hand2) do
    hand1
    |> Enum.reduce(true, fn x, acc -> acc && !(hand2 |> Enum.member?(x)) end)
  end
end
