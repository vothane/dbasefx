defmodule DbasefxTest do
  use ExUnit.Case
  doctest Dbasefx

trajectory_and_movement =
[
# Pitch Type,  Count, Freq %, Velo (mph), pfx HMov (in.), pfx VMov (in.), H. Rel (ft.), V. Rel (ft.)
  [Fourseam,    3669,  56.42,      96.61,          -6.69,           9.41,        -1.26,       6.37],
  [Sinker,       222,   3.41,      95.90,          -8.50,           7.46,        -1.29,       6.32],
  [Change,       764,  11.75,      88.28,          -8.95,           5.32,        -1.36,       6.29],
  [Slider,      1034,  15.90,      90.42,           0.95,           3.93,        -1.24,       6.38],
  [Curve,        814,  12.52,      84.33,           1.00,          -2.89,        -1.07,       6.53]
]

pitch_outcomes =
[
# Pitch Type, Count, Ball %, Strike %, Swing %, Foul %, Whiffs %, BIP %,  GB %, LD %, FB %,  PU%,  HR %
  [Fourseam,   3669,  31.43,    29.76,   48.60,  21.70,    11.20, 16.27,  6.27, 3.92, 4.80, 1.28, 0.44],
  [Sinker,      222,  29.73,    31.98,   44.14,  19.82,     9.01, 16.67, 11.71, 2.70, 1.80, 0.45, 0.45],
  [Change,      764,  34.56,    28.14,   54.45,  15.31,    17.93, 21.73, 12.17, 4.97, 3.14, 1.44, 0.65],
  [Slider,     1034,  40.43,    27.95,   48.26,  13.83,    17.80, 17.12,  9.57, 2.61, 3.58, 1.35, 0.29],
  [Curve,       814,  32.06,    38.33,   43.73,  13.15,    14.37, 16.34,  8.48, 3.93, 2.95, 0.98, 0.61]
]

results_and_averages =
[
# Pitch Type, Count,  AB,   K, BB, HBP,  1B, 2B, 3B, HR,   BAA,   SLG,   ISO, BABIP
  [Fourseam,   3669, 814, 211, 63,   9, 137, 38,  4, 16, 0.240, 0.355, 0.116, 0.305],
  [Sinker,      222,  50,  12,  2,   0,   8,  0,  0,  1, 0.180, 0.240, 0.060, 0.216],
  [Change,      764, 221,  54,  7,   1,  37,  7,  0,  5, 0.222, 0.321, 0.100, 0.272],
  [Slider,     1034, 274,  97, 12,   2,  35,  6,  2,  3, 0.168, 0.237, 0.069, 0.247],
  [Curve,       814, 202,  69,  7,   1,  27,  7,  2,  5, 0.203, 0.332, 0.129, 0.281]
]

  test "table" do
pitch_outcomes =
[
# Pitch Type, Count, Ball %, Strike %, Swing %, Foul %, Whiffs %, BIP %,  GB %, LD %, FB %,  PU%,  HR %
  [Fourseam,   3669,  31.43,    29.76,   48.60,  21.70,    11.20, 16.27,  6.27, 3.92, 4.80, 1.28, 0.44],
  [Sinker,      222,  29.73,    31.98,   44.14,  19.82,     9.01, 16.67, 11.71, 2.70, 1.80, 0.45, 0.45],
  [Change,      764,  34.56,    28.14,   54.45,  15.31,    17.93, 21.73, 12.17, 4.97, 3.14, 1.44, 0.65],
  [Slider,     1034,  40.43,    27.95,   48.26,  13.83,    17.80, 17.12,  9.57, 2.61, 3.58, 1.35, 0.29],
  [Curve,       814,  32.06,    38.33,   43.73,  13.15,    14.37, 16.34,  8.48, 3.93, 2.95, 0.98, 0.61]
]
    table = Table.new(["Pitch", "Count", "Ball", "Strike", "Swing", "Foul", "Whiffs", "BIP", "GB", "LD", "FB", "PU", "HR"])
    table = Enum.reduce(pitch_outcomes, table, &Table.insert/2)
    #assert table == []
    table = Dbasefx.select(table, ["Pitch"])
    assert table == []
  end
end
