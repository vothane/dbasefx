defmodule Webscraper do
  def build_table(url, primary_keys \\ []) do
    HTTPoison.start
    {:ok, html} = HTTPoison.get(url)
    cols = get_elements(html, "thead tr th")
    rows = get_elements(html, "thead tr td") |> Enum.map(&clean/1) |> Enum.chunk(length(cols))
    table = Table.new(cols, [], primary_keys)
    Enum.reduce(rows, table, &Table.insert/2)
  end

  defp get_elements(html, nav) do
    Floki.find(html.body, nav) |> Enum.map(fn(el) -> Floki.text(el) end)
  end

  defp clean(str) do
    if String.match?(str, ~r/^\.[0-9]+/), do: str = "#{0}#{str}"
    cond do
      String.match?(str, ~r/^-?[0-9]+$/) ->
        Integer.parse(str) |> Tuple.to_list |> List.first
      String.match?(str, ~r/b[0-9]+\.([0-9]+\b)?|\.[0-9]+\b/) ->
        Float.parse(str) |> Tuple.to_list |> List.first
      true ->
        str
    end
  end
end
