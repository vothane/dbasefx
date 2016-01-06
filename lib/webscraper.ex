defmodule Webscraper do
  def build_table(url) do
    HTTPoison.start
    {:ok, html} = HTTPoison.get(url)
    cols = Floki.find(html.body, "thead tr th") |> Enum.map(fn(el) -> Floki.text(el) end)
    data = Floki.find(html.body, "thead tr td") |> Enum.map(fn(el) -> Floki.text(el) end) |> Enum.chunk(length(cols))
    rows = Enum.map(data, fn(r) -> Enum.map(r, &clean/1) end)
    Table.new(cols, rows)
  end

  defp clean(str) do
    cond do
      String.match?(str, ~r/^-?[0-9]+$/) ->
        List.first(Tuple.to_list(Integer.parse(str)))
      String.match?(str, ~r/b[0-9]+\.([0-9]+\b)?|\.[0-9]+\b/) ->
        List.first(Tuple.to_list(Float.parse(str)))
      true ->
        str
    end
  end
end
