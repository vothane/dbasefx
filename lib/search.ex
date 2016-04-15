defmodule Search do 
  use GenServer 
  import Dbasefx

  def init(_) do 
    {:ok, Map.new} 
  end 

  def handle_cast({:put, player, player_url}, state) do 
    table_map = %{"pitch_usage" => player_url,
                  "pitch_outcomes" => "#{player_url}&var=po",
                  "sabermatric_outcomes" => "#{player_url}&var=so"}
    db = Enum.reduce(table_map, %{}, fn({table_name, url}, m) -> 
                                       Map.put(m, table_name, Webscraper.build_table(url))
                                     end  
    {:noreply, Map.put(state, player, db)} 
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
