defmodule Table do
  def new(columns, primary_keys \\ [], rows \\ []) do
    %{:columns => columns, :primary_keys => primary_keys, :rows => rows}
  end

  def insert(row, table) do
    new_row = Enum.zip(Map.get(table, :columns), row)
    %{table | :rows => List.insert_at(Map.get(table, :rows), -1, new_row)}
  end
end

