defmodule ReportsGenerator do
  def build(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Enum.reduce(report_acc(), fn line, acc ->
      [id, _food_name, price] = parse_line(line)
      Map.put(acc, id, acc[id] + price)
    end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end

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
