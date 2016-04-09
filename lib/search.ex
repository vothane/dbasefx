defmodule Search do 
  use GenServer 
  import Dbasefx

  def init(_) do 
    {:ok, Map.new} 
  end 

  def handle_cast({:put, player, url}, state) do 
    table = Webscraper.build_table(url)
    {:noreply, Map.put(state, player, table)} 
  end 

  def handle_call({:get, player, query}, _, state) do
    table = Map.get(state, player)
    query = fn -> Dbasefx.select(table, ["Pitch"])
                  |> Dbasefx.where(fn(row) -> 
                                     Enum.any?(row, fn {k, v} -> 
                                       {k, v} == {"Pitch", "Change"} end) end)
             end                           
    {:reply, query.(), state} 
  end 
end
