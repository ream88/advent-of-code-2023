#!/usr/bin/env elixir

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn string ->
  numbers =
    string
    |> String.codepoints()
    |> Enum.map(&Integer.parse/1)
    |> Enum.filter(&is_tuple/1)
    |> Enum.map(&elem(&1, 0))

  hd(numbers) * 10 + List.last(numbers)
end)
|> Enum.reduce(0, &(&1 + &2))
|> IO.inspect(label: "result")
