defmodule Webscraper do
  def build_table(url, primary_keys \\ []) do
    HTTPoison.start
    {:ok, html} = HTTPoison.get(url)
    cols = get_elements(html, "thead tr th")
    rows = get_elements(html, "thead tr td") |> Enum.map(&clean/1) |> Enum.chunk(length(cols))
    Table.new(cols, rows, primary_keys)
  end

  defp get_elements(html, nav) do
    Floki.find(html.body, nav) |> Enum.map(fn(el) -> Floki.text(el) end)
  end

  defp clean(str) do
    cond do
      String.match?(str, ~r/^-?[0-9]+$/) ->
        Integer.parse(str)
      String.match?(str, ~r/b[0-9]+\.([0-9]+\b)?|\.[0-9]+\b/) ->
        Float.parse(str)
      true ->
        str
    end
  end
end
