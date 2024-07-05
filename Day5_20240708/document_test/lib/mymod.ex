defmodule Mymod do
  @moduledoc """
  Add one to an integer and String number
  """
  def my_func(n) when is_integer(n) do
    n + 1
  end

  def my_funcs(str) when is_binary(str) do
    # StringをIntegerに変換する
    case Integer.parse(str) do
      {n, ""} -> n + 1
      _ -> raise(ArgumentError)
    end
  end
end
