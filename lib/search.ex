defmodule Search do 
  use GenServer 
  import Dbasefx

  def handle_call({:get, player, player_url}, _, state) do
    tables = case Map.has_key?(state, player) do
               false -> table_map = %{:trajectory_movement => player_url,
                                      :pitch_outcomes => "#{player_url}&var=po",
                                      :sabermetric_outcomes => "#{player_url}&var=so",
                                      :results_averages => "#{player_url}&var=ra"}
                        primary_keys = ["Pitch Type", "Count"]            
                        Enum.reduce(table_map, %{}, fn({table_name, url}, m) -> 
                                                      Map.put(m, table_name, Webscraper.build_table(url, primary_keys))
                                                    end)  
               true -> Map.get(state, player)
             end
    {:reply, tables, state} 
  end 
end
