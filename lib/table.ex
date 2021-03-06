defmodule Table do
  def new(columns, rows, primary_keys \\ []) do
    %{:columns => columns, :rows => rows, :primary_keys => primary_keys}
  end

  def insert(row, table) do
    new_row = Enum.zip(Map.get(table, :columns), row)
    %{table | :rows => List.insert_at(Map.get(table, :rows), -1, new_row)}
  end
end

