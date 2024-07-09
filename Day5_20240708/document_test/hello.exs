defmodule Hello do
  def greet do
    # 3. 親プロセスからのメッセージをreceive/1で待ち受ける
    # 5. マッチするメッセージ（ここでは親のプロセスIDと"world"）を受信した場合、親のプロセスに{:ok, "Hello, world"}を送信する
    receive do
      {sender, name} ->
        send(sender, {:ok, "Hello, #{name}"})
        IO.inspect(binding(), label: "Hello.great receive message")
        #再帰
        greet()
    end
  end
end

# 子プロセス作成
pid = spawn(Hello, :greet, [])
IO.inspect(binding(), label: "After the child process is called")
send(pid,{self(),"Thewaggle"})
receive do
  {:ok,message} -> IO.puts(message)
end

send(pid, {self(), "world"})
IO.inspect(binding(), label: "After Send/2 sent to self process")

# 3秒待つ
:timer.sleep(3000)

receive do
  {:ok, message} ->
    IO.puts(message)
    IO.inspect(binding(), label: "receive message")
    # after ミリ秒でタイムアウトする時間を指定できる
after
  3000 ->
    IO.puts("Nothing happened.")
end
