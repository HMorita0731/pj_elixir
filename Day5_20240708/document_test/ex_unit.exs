defmodule ExUnit1 do
  def my_func(n) when is_integer(n) do
  n + 1
  end
  def my_funcs(str) when is_binary(str) do
  case Integer.parse(str) do
  {n, ""} -> n + 1
  _ -> raise(ArgumentError)
  end
  end
  end

 ExUnit.start()
  defmodule ExUnit1Test do
    use ExUnit.Case

      test "与えられた引数 + 1" do
        assert ExUnit1.my_func(1) == 2
      end
      test "与えられた引数 + 1 (キーワードリスト)", do: assert(ExUnit1.my_func(1) == 2)
      test "与えられた引数を文字列から数値に変換し + 1" do
        assert ExUnit1.my_funcs("100") == 101
      end

    end
