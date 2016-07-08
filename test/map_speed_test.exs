defmodule Mocks do
  def expensive(number) do
    Enum.reduce(1..100, fn(element, reducer)-> reducer + :math.sqrt(element) * number end)
  end
end

defmodule MapSpeedTest do
  use ExUnit.Case

  test "p map" do
    list = Enum.to_list 1..1000000
    # test_func = fn(a) -> a * 2 end
    mapped = ParallelMap.p_map(list, &Mocks.expensive/1)
    # mapped = Enum.map(list, &Mocks.expensive/1)
    IO.puts( inspect Enum.reduce(mapped, fn(element, reducer)-> reducer + element end) )
  end
end
