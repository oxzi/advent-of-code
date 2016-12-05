defmodule Day5 do
  defp door_id_md5_after(door, numb) do
    hash = :crypto.hash(:md5, door <> Integer.to_string(numb))
      |> Base.encode16(case: :lower)

    cond do
      numb > 10_000_000_000 ->
        {:err, "I tried~ it was too much ;_;"}
      (hash |> String.slice(0..4) == "00000") ->
        {:ok, hash, numb}
      true ->
        door_id_md5_after(door, numb + 1)
    end
  end

  defp door_a_id(_, _, 8), do: ""
  defp door_a_id(door, numb, digit) do
    case door_id_md5_after(door, numb) do
      {:ok, id, n} ->
        (id |> String.slice(5..5)) <> door_a_id(door, n + 1, digit + 1)
      {:err, msg} ->
        {:err, msg}
    end
  end
  def door_a_id(door) do
    case door_a_id(door, 0, 0) do
      {:err, msg} ->
        {:err, msg}
      numb ->
        {:ok, numb}
    end
  end

  defp door_b_id(door, numb, kywrd) do
    IO.write "\rHacking password: "
    Enum.map(0..7,
      &Keyword.get(kywrd, "k" <> Integer.to_string(&1) |> String.to_atom,
        :rand.uniform(9) |> Integer.to_string))
    |> List.to_string
    |> IO.write

    cond do
      Enum.all?(0..7, &Keyword.has_key?(kywrd, "k" <> Integer.to_string(&1) |> String.to_atom)) ->
        IO.write "\n"

        Enum.map(0..7, &Keyword.get(kywrd, "k" <> Integer.to_string(&1) |> String.to_atom))
        |> List.to_string
      true ->
        {:ok, id, n} = door_id_md5_after(door, numb)
        {pos, chr} = {id |> String.slice(5..5), id |> String.slice(6..6)}
        case Integer.parse(pos) do
          {int_pos, ""} when int_pos <= 7 ->
            door_b_id(door, n + 1, Keyword.put_new(kywrd, String.to_atom("k" <> pos), chr))
          _ ->
            door_b_id(door, n + 1, kywrd)
        end
    end
  end
  def door_b_id(door), do: door_b_id(door, 0, [])
end

input = "abc"
case Day5.door_a_id(input) do
  {:ok, numb} ->
    IO.puts "Task 1: The password is " <> numb
  {:err, msg} ->
    IO.puts "Task 2: It failed: " <> msg
end
IO.puts "Task 2: " <> Day5.door_b_id(input)
