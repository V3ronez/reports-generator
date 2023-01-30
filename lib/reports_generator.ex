defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, acc -> sum_line(line, acc) end)
  end

  def fetch_higher_cost(report), do: Enum.max_by(report, fn {_key, value} -> value end)
  def fetch_min_cost(report), do: Enum.min_by(report, fn {_key, value} -> value end)
  defp sum_line([id, _food_name, price], acc), do: Map.put(acc, id, acc[id] + price)
  defp report_acc, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
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
