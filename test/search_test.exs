defmodule SearchTest do
  use ExUnit.Case
  use GenServer
  doctest Search

  test "search" do
    {:ok, pid} = GenServer.start_link(Search, Map.new)
    player = "David Price"
    player_url = "http://www.brooksbaseball.net/tabs.php?player=456034"
     %{:trajectory_movement => trajectory_movement,
       :pitch_outcomes => pitch_outcomes,
       :sabermetric_outcomes => sabermetric_outcomes,
       :results_averages => results_averages} = GenServer.call(pid, {:get, player, player_url})
     
     IO.inspect trajectory_movement
     IO.inspect pitch_outcomes
     IO.inspect sabermetric_outcomes
     IO.inspect results_averages

     query_change = Dbasefx.select(trajectory_movement, ["Pitch Type"])
                 |> Dbasefx.where(fn(row) -> Enum.any?(row, fn {k, v} -> {k, v} == {"Pitch Type", "Change"} end) end)
     
     result_change = Map.get(query_change, :rows)

     assert result_change == [[{"Pitch Type", "Change"}]] # query if David Price has a changeup in repertoire, query indicates TRUE
    
     query_quarter_of = Dbasefx.select(trajectory_movement, ["Pitch Type", "Freq"])
                     |> Dbasefx.where(fn([pitch | freq]) -> elem(List.first(freq), 1) >= 25.0 end)
     
     result_quarter_of = Map.get(query_quarter_of, :rows)

     # query to find all pitches that account for a quarter of his total pitch count percentage
     # they are the fastball (4-seam) and sinker (2-seam)
     assert result_quarter_of == [[{"Pitch Type", "Fourseam"}, {"Freq", 27.45}], [{"Pitch Type", "Sinker"}, {"Freq", 33.85}]]
  end
end
