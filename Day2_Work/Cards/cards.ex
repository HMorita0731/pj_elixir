defmodule Cards do
  def create_deck do
    numbers = [
      "Ace",
      "Two",
      "Three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine",
      "Ten",
      "Jack",
      "Queen",
      "King"
    ]

    suits = ["Spade", "Clover", "Diamond", "Heart"]

    for suit <- suits ,num <- numbers do
      num <> "_of_" <> suit
    end
  end
  def shuffle(deck) do
    Enum.shuffle(deck)
  end
  def deal(deck,deal_size) do
    Enum.split(deck,deal_size)
  end
  def save(deck,file_name) do
    binary = :erlang.term_to_binary(deck)
    File.write(file_name, binary)
  end
  def load(file_name) do
   {status, binary} = File.read(file_name)
   if status == :error do
     "Does not exists such a file"
   else
     :erlang.binary_to_term(binary)
    end
  end
end
