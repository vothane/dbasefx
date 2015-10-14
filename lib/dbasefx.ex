defmodule Dbasefx do

end

defmodule Table do
  def new(columns, rows // []) do
    %{:columns => columns, :rows => rows}
  end

  def insert(table, row) do
    new_row = Enum.zip(Map.fetch(table, :columns), row)
    %{table | :rows => List.insert_at(Map.fetch(:rows), -1, new_row)}
  end
end

