defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["users", "foods"]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, acc -> sum_line(line, acc) end)
  end

  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_higher_cost(_report, _option), do: {:error, "invalid option"}

  def build_report_async(list_files) when not is_list(list_files) do
    {:error, "please provide a list of files"}
  end

  def build_report_async(list_files) do
    result =
      list_files
      |> Task.async_stream(&build/1)
      # |> Enum.map(& &1) // jeito curto de escrever uma funcao e passando um parametro
      |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  def fetch_min_cost(report), do: Enum.min_by(report, fn {_key, value} -> value end)

  defp sum_line([id, food_name, price], %{"foods" => foods, "users" => users} = acc) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    # atualizando o map acumulador
    %{acc | "users" => users, "foods" => foods}
    # map_food_users(foods, users)

    # acc
    # |> Map.put("users", users)
    # |> Map.put("foods", foods)
  end

  defp sum_reports(%{"foods" => foods_accumulator, "users" => users_accumulator}, %{
         "foods" => foods,
         "users" => users
       }) do
    # foods = Map.merge(foods_empty, foods, fn _key, value1, value2 -> value1 + value2 end)
    # users = Map.merge(users_empty, users, fn _key, value1, value2 -> value1 + value2 end)

    foods = build_map_result(foods_accumulator, foods)
    users = build_map_result(users_accumulator, users)
    map_food_users(foods, users)
  end

  defp map_food_users(foods, users), do: %{"foods" => foods, "users" => users}

  def report_acc do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    # gerando um map a partir da lista %{"esfirra" => 0}

    # %{"users" => users, "foods" => foods} - retorno antigo
    map_food_users(foods, users)
  end

  defp build_map_result(map1, map2) do
    Map.merge(map1, map2, fn _key, value_1, value_2 -> value_1 + value_2 end)
  end
end

# metodo de ler arquivo usando case
# {:ok, result} ->
#   result

# {:error, reason} ->
#   reason
# se não dar match ele cai no default value
# _ -> "case default"

# metodo elegante de ler o arquivo
# defp handle_file_content({:ok, file_content}), do: file_content
# defp handle_file_content({:error, _reason}), do: "Error to read file"

# criando funcao de forma implicita.
# & = chama uma funcao
# &String.to_integer/1 chamando essa funcao e passando o unico elemento para ela como primeiro argumento explicitamente
