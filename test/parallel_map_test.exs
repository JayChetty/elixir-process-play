defmodule ParallelMapTest do
  use ExUnit.Case

  test "p map" do
    list = [1,2,3]
    test_func = fn(a) -> a * 2 end
    assert ParallelMap.p_map(list, test_func) == [2,4,6]
  end
end
