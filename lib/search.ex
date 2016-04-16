defmodule Search do 
  use GenServer 
  import Dbasefx

  def init(_) do 
    {:ok, Map.new} 
  end 

  def handle_cast({:put, player, player_url}, state) do 
    table_map = %{:trajectory_movement => player_url,
                  :pitch_usage => "#{player_url}&var=usage",
                  :pitch_outcomes => "#{player_url}&var=po",
                  :sabermetric_outcomes => "#{player_url}&var=so",
                  :results_averages => "#{player_url}&var=ra"}
    primary_keys = ["Pitch Type", "Count"]            
    db = Enum.reduce(table_map, %{}, fn({table_name, url}, m) -> 
                                       Map.put(m, table_name, Webscraper.build_table(url, primary_keys))
                                     end)  
    {:noreply, Map.put(state, player, db)} 
  end 

  def handle_call({:get, player, query}, _, state) do
    %{:trajectory_movement => trajectory_movement,
      :pitch_usage => pitch_usage,
      :pitch_outcomes => pitch_outcomes,
      :sabermetric_outcomes => sabermetric_outcomes,
      :results_averagee => results_averages} = Map.get(state, player)
    {:reply, query.(), state} 
  end 
end
