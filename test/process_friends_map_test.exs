defmodule ProcessFriendsMapTest do
  use ExUnit.Case

  test "my map" do
    start_list = [1,2,3,4]
    mapping_function = fn(num)-> num * 2 end
    assert MapOrganiser.map_p(start_list, mapping_function)== [2,4,6,8]
  end
end
