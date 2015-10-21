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

  def join(table, other_table) do
    join_cols = Set.intersection(Enum.into(Map.get(table, :columns), HashSet.new),
                                 Enum.into(Map.get(other_table, :columns), HashSet.new))
    right_cols = Set.difference(Enum.into(Map.get(other_table, :columns), HashSet.new),
                                Enum.into(Map.get(table, :columns), HashSet.new))
    join_table = Table.new(HashSet.to_list(join_cols) ++ HashSet.to_list(right_cols))
    reduce_fn =
      fn(row, table) ->
        is_join? =
          fn(other_row) ->
            Enum.all?(join_cols, fn(col) -> other_row[col] == row[col] end)
          end
        other_rows = Map.get(Dbasefx.where(other_table, is_join?), :rows)
        Enum.reduce(other_rows, join_table,
          fn(r, t) ->
            new_row = row ++ r
            %{t | :rows => List.insert_at(Map.get(t, :rows), -1, new_row)}
          end)
      end
    Enum.reduce(Map.get(table, :columns), join_table, reduce_fn)
  end
end

