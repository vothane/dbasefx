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
    
     IO.inspect GenServer.call(pid, {:get, player, player_url})
     query = Dbasefx.select(trajectory_movement, ["Pitch"])
          |> Dbasefx.where(fn(row) -> Enum.any?(row, fn {k, v} -> {k, v} == {"Pitch", "Change"} end) end)
     
    result = Map.get(query, :rows)
    assert result == []
    
  end
end
