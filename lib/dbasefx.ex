defmodule Dbasefx do
  import Table

  def select(table, show_columns \\ []) do
    result_table = Table.new(show_columns)
    reduce_fn =
      fn(row, table) ->
        new_row = Enum.filter(row, fn {k, v} -> Enum.member?(show_columns, k) end)
        %{table | :rows => List.insert_at(Map.get(table, :rows), -1, new_row)}
      end
    Enum.reduce(Map.get(table, :rows), result_table, reduce_fn)
  end

  def where(table, predicate) do
    result_rows =
      Enum.filter(Map.get(table, :rows),
        fn(row) -> Enum.any?(row, predicate) end)
    Table.new(Map.get(table, :columns), result_rows)
  end
end

