defmodule TodoAppRe.Tasks do
  alias TodoAppRe.Repo
  alias TodoAppRe.Tasks.Task

  def list_tasks(), do: Repo.all(Task)

  def get_task!(id), do: Repo.get!(Task, id)

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def update_task(%Task{}=task,attrs) do
    task
    |>Task.changeset(attrs)
    |>Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end
end
