defmodule Hello do
  def greet do
    receive do
      {sender, name} ->
        send(sender, {:ok, "Hello, #{name}"})
        IO.inspect(binding(), label: "Hello.great receive message")
        greet()
    end
  end
end

pid = spawn(Hello, :greet, [])
IO.inspect(binding(), label: "After the child process is called")
send(pid,{self(),"Thewaggle"})
receive do
  {:ok,message} -> IO.puts(message)
end

send(pid, {self(), "world"})
IO.inspect(binding(), label: "After Send/2 sent to self process")

:timer.sleep(3000)

receive do
  {:ok, message} ->
    IO.puts(message)
    IO.inspect(binding(), label: "receive message")
after
  3000 ->
    IO.puts("Nothing happened.")
end
