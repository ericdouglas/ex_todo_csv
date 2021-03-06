defmodule TodoList do
  @moduledoc """
  Todo list application to work with .csv files through IEx.
  """
  defstruct last_id: 0, todos: %{}

  @path_env %{dev: ["lib", "todos.csv"], test: ["lib", "todos_test.csv"]}
  @path Path.join(@path_env[Mix.env])

  @doc """
  Read the .csv file and return its content formatted

  ## Examples

      iex> TodoList.init
      %TodoList{
        last_id: 1,
        todos: %{
          1 => %Todo{
            id: 1,
            task: "Study Erlang",
            date: "2018-01-01",
            status: "todo"
          }
        }
      }
  """
  def init do
    @path
    |> read_file!
    |> format_to_work
  end

  defp read_file!(path) do
    path
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp format_to_work(input) do
    format_todos = fn(el, acc) ->
      [id, task, date, status] = String.split(el, ",")
      id = String.to_integer(id)

      Map.put(acc, id, %Todo{id: id, task: task, date: date, status: status})
    end

    todos   = Enum.reduce(input, %{}, format_todos)
    last_id = Map.keys(todos) |> Enum.max

    %TodoList{last_id: last_id, todos: todos}
  end
end
