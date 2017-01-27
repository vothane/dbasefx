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

     headers_traj_move = Table.new(trajectory_movement[:columns], [], trajectory_movement[:primary_keys]) 
     table_traj_move = Enum.reduce(trajectory_movement[:rows], headers_traj_move, &Table.insert/2)
     query = Dbasefx.select(table_traj_move, ["Pitch Type"])
          |> Dbasefx.where(fn(row) -> Enum.any?(row, fn {k, v} -> {k, v} == {"Pitch Type", "Change"} end) end)
     
    result = Map.get(query, :rows)

    assert result == [[{"Pitch Type", "Change"}]] # query if David Price has a changeup in repertoire, query indicates TRUE
    
  end
end
