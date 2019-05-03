defmodule Pocker do
  @values ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
  @suits ["C", "D", "H", "S"]
  @kinds [
    "High Card",
    "Pair",
    "Two Pairs",
    "Three of a Kind",
    "Straight",
    "Flush",
    "Full House",
    "Four of a Kind",
    "Strait Flush"
  ]

  def generate_hands() do
    @values
    |> Enum.map(fn v -> @suits |> Enum.map(fn s -> v <> s end) end)
    |> Enum.concat()
    |> Enum.take_random(10)
    |> Enum.chunk_every(5)
  end

  defp value_index(card) do
    @values |> Enum.find_index(&(&1 == card |> String.first()))
  end

  defp kind_index(kind) do
    @kinds |> Enum.find_index(&(&1 == kind))
  end

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

  defp is_flush(hand) do
    hand
    |> Enum.map(&String.last/1)
    |> Enum.uniq()
    |> length() == 1
  end

  defp get_kind(hand) do
    hand =
      hand
      |> Enum.sort(&(value_index(&1) > value_index(&2)))

    case group_by_values(hand) |> Enum.map(&length/1) do
      [1, 1, 1, 1, 1] ->
        case {is_flush(hand), is_consc(hand)} do
          {true, true} -> "Straight Flush"
          {false, true} -> "Straight"
          {true, false} -> "Flush"
          {false, false} -> "High Card"
        end

      [2, 1, 1, 1] ->
        "Pair"

      [2, 2, 1] ->
        "Two Pairs"

      [3, 1, 1] ->
        "Three of a Kind"

      [3, 2] ->
        "Full House"

      [4, 1] ->
        "Four of a Kind"
    end
  end

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

  defp compare_grouped(hand1, hand2) do
    case {hand1, hand2} do
      {[], []} ->
        %{winner: "tie", high: nil}

      {[h1 | t1], [h2 | t2]} ->
        if(String.first(hd(h1)) == String.first(hd(h2))) do
          compare_grouped(t1, t2)
        else
          if value_index(hd(h1)) > value_index(hd(h2)) do
            %{winner: "black", high: String.first(hd(h1))}
          else
            %{winner: "white", high: String.first(hd(h2))}
          end
        end
    end
  end

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
end
