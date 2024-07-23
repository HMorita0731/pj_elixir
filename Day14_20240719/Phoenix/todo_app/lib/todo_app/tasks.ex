defmodule TodoApp.Tasks do
  alias TodoApp.Repo
  alias TodoApp.Tasks.Task

  def list_tasks(), do: Repo.all(Task)

  def create_task(attrs \\ %{}) do
    %Task{}
    |>Task.changeset(attrs)
    |>Repo.insert()
  end
  def change_task(%Task{} = task, attrs \\%{}) do
    Task.changeset(task,attrs)
  end
end
