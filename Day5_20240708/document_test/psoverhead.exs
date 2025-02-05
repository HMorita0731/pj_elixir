defmodule Psoverhead do
  def counter(next_pid) do
    receive do
      n -> send(next_pid,n + 1)
    end
  end

  def create_processes(n) do
    code_to_run =
      fn(_,send_to) ->
        spawn(Psoverhead, :counter,[send_to])
      end

      last = Enum.reduce(1..n,self(),code_to_run)
      send(last,0)

      receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect(final_answer)}"
      end
    end

    def run(n) do
      IO.inspect(:timer.tc(Psoverhead, :create_processes,[n] ))
    end
  end
