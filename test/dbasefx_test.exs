defmodule DbasefxTest do
  use ExUnit.Case
  doctest Dbasefx

  test "table" do
    pitch_outcomes =
    [
    # Pitch Type, Count, Ball %, Strike %, Swing %, Foul %, Whiffs %, BIP %,  GB %, LD %, FB %,  PU%,  HR %
      ["Fourseam",   3669,  31.43,    29.76,   48.60,  21.70,    11.20, 16.27,  6.27, 3.92, 4.80, 1.28, 0.44],
      ["Sinker",      222,  29.73,    31.98,   44.14,  19.82,     9.01, 16.67, 11.71, 2.70, 1.80, 0.45, 0.45],
      ["Change",      764,  34.56,    28.14,   54.45,  15.31,    17.93, 21.73, 12.17, 4.97, 3.14, 1.44, 0.65],
      ["Slider",     1034,  40.43,    27.95,   48.26,  13.83,    17.80, 17.12,  9.57, 2.61, 3.58, 1.35, 0.29],
      ["Curve",       814,  32.06,    38.33,   43.73,  13.15,    14.37, 16.34,  8.48, 3.93, 2.95, 0.98, 0.61]
    ]

    trajectory_and_movement =
    [
    # Pitch Type,  Count, Freq %, Velo (mph), pfx HMov (in.), pfx VMov (in.), H. Rel (ft.), V. Rel (ft.)
      ["Fourseam",    3669,  56.42,      96.61,          -6.69,           9.41,        -1.26,       6.37],
      ["Sinker",       222,   3.41,      95.90,          -8.50,           7.46,        -1.29,       6.32],
      ["Change",       764,  11.75,      88.28,          -8.95,           5.32,        -1.36,       6.29],
      ["Slider",      1034,  15.90,      90.42,           0.95,           3.93,        -1.24,       6.38],
      ["Curve",        814,  12.52,      84.33,           1.00,          -2.89,        -1.07,       6.53]
    ]

    pitch_outcomes =
    [
    # Pitch Type, Count, Ball %, Strike %, Swing %, Foul %, Whiffs %, BIP %,  GB %, LD %, FB %,  PU%,  HR %
      ["Fourseam",   3669,  31.43,    29.76,   48.60,  21.70,    11.20, 16.27,  6.27, 3.92, 4.80, 1.28, 0.44],
      ["Sinker",      222,  29.73,    31.98,   44.14,  19.82,     9.01, 16.67, 11.71, 2.70, 1.80, 0.45, 0.45],
      ["Change",      764,  34.56,    28.14,   54.45,  15.31,    17.93, 21.73, 12.17, 4.97, 3.14, 1.44, 0.65],
      ["Slider",     1034,  40.43,    27.95,   48.26,  13.83,    17.80, 17.12,  9.57, 2.61, 3.58, 1.35, 0.29],
      ["Curve",       814,  32.06,    38.33,   43.73,  13.15,    14.37, 16.34,  8.48, 3.93, 2.95, 0.98, 0.61]
    ]

    results_and_averages =
    [
    # Pitch Type, Count,  AB,   K, BB, HBP,  1B, 2B, 3B, HR,   BAA,   SLG,   ISO, BABIP
      ["Fourseam",   3669, 814, 211, 63,   9, 137, 38,  4, 16, 0.240, 0.355, 0.116, 0.305],
      ["Sinker",      222,  50,  12,  2,   0,   8,  0,  0,  1, 0.180, 0.240, 0.060, 0.216],
      ["Change",      764, 221,  54,  7,   1,  37,  7,  0,  5, 0.222, 0.321, 0.100, 0.272],
      ["Slider",     1034, 274,  97, 12,   2,  35,  6,  2,  3, 0.168, 0.237, 0.069, 0.247],
      ["Curve",       814, 202,  69,  7,   1,  27,  7,  2,  5, 0.203, 0.332, 0.129, 0.281]
    ]

    table = Table.new(["Pitch", "Count", "Ball", "Strike", "Swing", "Foul", "Whiffs", "BIP", "GB", "LD", "FB", "PU", "HR"], ["Pitch"])
    table = Enum.reduce(pitch_outcomes, table, &Table.insert/2)

    select_table = Dbasefx.select(table, ["Pitch"])
            |> Dbasefx.where(fn(row) -> Enum.any?(row, fn {k, v} -> {k, v} == {"Pitch", "Change"} end) end)
    assert Map.get(select_table, :rows) == [[{"Pitch", "Change"}]]

    table2 = Table.new(["Pitch", "Count", "AB", "K", "BB", "HBP",  "1B", "2B", "3B", "HR", "BA", "SLG", "ISO", "BABIP"], ["Pitch"])
    table2 = Enum.reduce(results_and_averages, table2, &Table.insert/2)

    group_table = Dbasefx.group_by(table2, fn(row) -> String.length(row["Pitch"]) end)
    assert group_table == %{5 => [[{"Pitch", "Curve"}, {"Count", 814}, {"AB", 202}, {"K", 69}, {"BB", 7}, {"HBP", 1},
                                   {"1B", 27}, {"2B", 7}, {"3B", 2}, {"HR", 5}, {"BA", 0.203}, {"SLG", 0.332},
                                   {"ISO", 0.129}, {"BABIP", 0.281}]],
                            6 => [[{"Pitch", "Slider"}, {"Count", 1034}, {"AB", 274}, {"K", 97}, {"BB", 12}, {"HBP", 2},
                                   {"1B", 35}, {"2B", 6}, {"3B", 2}, {"HR", 3}, {"BA", 0.168}, {"SLG", 0.237}, {"ISO", 0.069},
                                   {"BABIP", 0.247}], [{"Pitch", "Change"}, {"Count", 764}, {"AB", 221}, {"K", 54}, {"BB", 7},
                                   {"HBP", 1}, {"1B", 37}, {"2B", 7}, {"3B", 0}, {"HR", 5}, {"BA", 0.222}, {"SLG", 0.321},
                                   {"ISO", 0.1}, {"BABIP", 0.272}], [{"Pitch", "Sinker"}, {"Count", 222}, {"AB", 50}, {"K", 12},
                                   {"BB", 2}, {"HBP", 0}, {"1B", 8}, {"2B", 0}, {"3B", 0}, {"HR", 1}, {"BA", 0.18}, {"SLG", 0.24},
                                   {"ISO", 0.06}, {"BABIP", 0.216}]],
                            8 => [[{"Pitch", "Fourseam"}, {"Count", 3669}, {"AB", 814}, {"K", 211}, {"BB", 63}, {"HBP", 9},
                                   {"1B", 137}, {"2B", 38}, {"3B", 4}, {"HR", 16}, {"BA", 0.24}, {"SLG", 0.355}, {"ISO", 0.116},
                                   {"BABIP", 0.305}]]}

    sort_table = Dbasefx.sort_by(table2, fn(row) -> row["Count"] end)
    assert Map.get(sort_table, :rows) == [[{"Pitch", "Sinker"},   {"Count",  222}, {"AB", 50}, {"K", 12}, {"BB", 2}, {"HBP", 0}, {"1B", 8}, {"2B", 0}, {"3B", 0}, {"HR", 1}, {"BA", 0.18}, {"SLG", 0.24}, {"ISO", 0.06}, {"BABIP", 0.216}],
                                          [{"Pitch", "Change"},   {"Count",  764}, {"AB", 221}, {"K", 54}, {"BB", 7}, {"HBP", 1}, {"1B", 37}, {"2B", 7}, {"3B", 0}, {"HR", 5}, {"BA", 0.222}, {"SLG", 0.321}, {"ISO", 0.1}, {"BABIP", 0.272}],
                                          [{"Pitch", "Curve"},    {"Count",  814}, {"AB", 202}, {"K", 69}, {"BB", 7}, {"HBP", 1}, {"1B", 27}, {"2B", 7}, {"3B", 2}, {"HR", 5}, {"BA", 0.203}, {"SLG", 0.332}, {"ISO", 0.129}, {"BABIP", 0.281}],
                                          [{"Pitch", "Slider"},   {"Count", 1034}, {"AB", 274}, {"K", 97}, {"BB", 12}, {"HBP", 2}, {"1B", 35}, {"2B", 6}, {"3B", 2}, {"HR", 3}, {"BA", 0.168}, {"SLG", 0.237}, {"ISO", 0.069}, {"BABIP", 0.247}],
                                          [{"Pitch", "Fourseam"}, {"Count", 3669}, {"AB", 814}, {"K", 211}, {"BB", 63}, {"HBP", 9}, {"1B", 137}, {"2B", 38}, {"3B", 4}, {"HR", 16}, {"BA", 0.24}, {"SLG", 0.355}, {"ISO", 0.116}, {"BABIP", 0.305}]]

    join_table = Dbasefx.join(table, table2)
    assert Map.get(join_table, :rows) == [[{"Pitch", "Fourseam"}, {"Count", 3669}, {"Ball", 31.43}, {"Strike", 29.76}, {"Swing", 48.6}, {"Foul", 21.7}, {"Whiffs", 11.2}, {"BIP", 16.27}, {"GB", 6.27}, {"LD", 3.92}, {"FB", 4.8}, {"PU", 1.28},
                                           {"HR", 0.44}, {"3B", 4}, {"BA", 0.24}, {"K", 211}, {"BABIP", 0.305}, {"SLG", 0.355}, {"AB", 814}, {"BB", 63}, {"1B", 137}, {"HBP", 9}, {"2B", 38}, {"ISO", 0.116}],
                                          [{"Pitch", "Sinker"}, {"Count", 222}, {"Ball", 29.73}, {"Strike", 31.98}, {"Swing", 44.14}, {"Foul", 19.82}, {"Whiffs", 9.01}, {"BIP", 16.67}, {"GB", 11.71}, {"LD", 2.7}, {"FB", 1.8}, {"PU", 0.45},
                                           {"HR", 0.45}, {"3B", 0}, {"BA", 0.18}, {"K", 12}, {"BABIP", 0.216}, {"SLG", 0.24}, {"AB", 50}, {"BB", 2}, {"1B", 8}, {"HBP", 0}, {"2B", 0}, {"ISO", 0.06}],
                                          [{"Pitch", "Change"}, {"Count", 764}, {"Ball", 34.56}, {"Strike", 28.14}, {"Swing", 54.45}, {"Foul", 15.31}, {"Whiffs", 17.93}, {"BIP", 21.73}, {"GB", 12.17}, {"LD", 4.97}, {"FB", 3.14}, {"PU", 1.44},
                                           {"HR", 0.65}, {"3B", 0}, {"BA", 0.222}, {"K", 54}, {"BABIP", 0.272}, {"SLG", 0.321}, {"AB", 221}, {"BB", 7}, {"1B", 37}, {"HBP", 1}, {"2B", 7}, {"ISO", 0.1}],
                                          [{"Pitch", "Slider"}, {"Count", 1034}, {"Ball", 40.43}, {"Strike", 27.95}, {"Swing", 48.26}, {"Foul", 13.83}, {"Whiffs", 17.8}, {"BIP", 17.12}, {"GB", 9.57}, {"LD", 2.61}, {"FB", 3.58}, {"PU", 1.35},
                                           {"HR", 0.29}, {"3B", 2}, {"BA", 0.168}, {"K", 97}, {"BABIP", 0.247}, {"SLG", 0.237}, {"AB", 274}, {"BB", 12}, {"1B", 35}, {"HBP", 2}, {"2B", 6}, {"ISO", 0.069}],
                                          [{"Pitch", "Curve"}, {"Count", 814}, {"Ball", 32.06}, {"Strike", 38.33}, {"Swing", 43.73}, {"Foul", 13.15}, {"Whiffs", 14.37}, {"BIP", 16.34}, {"GB", 8.48}, {"LD", 3.93}, {"FB", 2.95}, {"PU", 0.98},
                                           {"HR", 0.61}, {"3B", 2}, {"BA", 0.203}, {"K", 69}, {"BABIP", 0.281}, {"SLG", 0.332}, {"AB", 202}, {"BB", 7}, {"1B", 27}, {"HBP", 1}, {"2B", 7}, {"ISO", 0.129}]]
  end
end
