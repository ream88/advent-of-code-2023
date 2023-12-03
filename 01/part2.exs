#!/usr/bin/env elixir

Mix.install([:nimble_parsec])

defmodule Parser do
  import NimbleParsec

  number_words = ~w(zero one two three four five six seven eight nine)

  number_word =
    choice(
      for {word, index} <- Enum.with_index(number_words),
          do: word |> string() |> replace(index)
    )

  reversed_number_word =
    choice(
      for {word, index} <- Enum.with_index(number_words),
          do: word |> String.reverse() |> string() |> replace(index)
    )

  number_literal =
    choice(
      for {word, index} <- Enum.with_index(~w(0 1 2 3 4 5 6 7 8 9)),
          do: word |> String.reverse() |> string() |> replace(index)
    )

  first_number = choice([number_word, number_literal])
  last_number = choice([reversed_number_word, number_literal])

  defparsec(:first_number, eventually(first_number))
  defparsec(:last_number, eventually(last_number))
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn string ->
  {:ok, [first_number], _, _, _, _} = Parser.first_number(string)
  {:ok, [second_number], _, _, _, _} = Parser.last_number(String.reverse(string))

  first_number * 10 + second_number
end)
|> Enum.reduce(0, &(&1 + &2))
|> IO.inspect(label: "result")
