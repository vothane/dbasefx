defmodule Dbasefx do
  import Table
  import Webscraper

  def select(table, show_columns \\ []) do
    reduce_fn = fn(row, table) ->
                  new_row = Enum.filter(row, fn {k, v} -> Enum.member?(show_columns, k) end)
                  %{table | :rows => List.insert_at(Map.get(table, :rows), -1, new_row)}
                end
    Enum.reduce(Map.get(table, :rows), Table.new(show_columns, [], Map.get(table, :primary_keys)), reduce_fn)
  end

  def where(table, predicate) do
    result_rows = Enum.filter(Map.get(table, :rows), predicate)
    Table.new(Map.get(table, :columns), result_rows, Map.get(table, :primary_keys))
  end

  def group_by(table, group_fn) do
    Enum.group_by(Map.get(table, :rows), group_fn)
  end

  def sort_by(table, sort_fn) do
    sorted_rows = Enum.sort_by(Map.get(table, :rows), sort_fn)
    Table.new(Map.get(table, :columns), sorted_rows, Map.get(table, :primary_keys))
  end

  def join(table, other_table) do
    join_cols = Set.intersection(Enum.into(Map.get(table, :primary_keys), HashSet.new),
                                 Enum.into(Map.get(other_table, :primary_keys), HashSet.new))
                |> HashSet.to_list

    right_cols = Set.difference(Enum.into(Map.get(other_table, :columns), HashSet.new),
                                Enum.into(Map.get(table, :columns), HashSet.new))
                 |> HashSet.to_list

    {:ok, join_table} = Agent.start_link(fn -> Table.new(Map.get(table, :columns) ++ right_cols, [], Map.get(table, :primary_keys)) end)

    for row <- Map.get(table, :rows) do
      is_join? = fn(other_row) -> Enum.all?(for col <- join_cols, do: other_row[col] == row[col]) end
      other_rows = Map.get(Dbasefx.where(other_table, is_join?), :rows)
      for other_row <- other_rows do
        left = for c <- Map.get(table, :columns), do: row[c]
        right = for c <- right_cols, do: other_row[c]
        Agent.update(join_table, fn t -> Table.insert(left ++ right, t) end)
      end
    end
    Agent.get(join_table, fn t -> t end)
  end
end

