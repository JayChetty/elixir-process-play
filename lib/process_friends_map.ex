defmodule MapOrganiser do
  def gather([]) do
    []
  end
  def gather( [ head | tail ] ) do
    IO.puts "creating receive block for worker #{ inspect head}"
    # This will happen sequentially,  organiser waits for the response and then fills it in. Nature of the list.
    # If mapping a tuple ( array ) can handle in any order, using the index.
    value = receive do
      {^head, return_value}->
        IO.puts "organiser got value from worker #{inspect head} return value #{inspect return_value}"
        return_value
    end
    [ value | gather( tail ) ]
  end

  def create_workers([], fun) do
    []
  end
  def create_workers([head | tail], fun) do
    worker = spawn(WorkerFriend, :ready, [])
    send( worker, {self, head, fun} )
    [ worker | create_workers( tail, fun ) ]
  end

  def map_p( start_list, fun ) do
    workers = MapOrganiser.create_workers( start_list, fun )
    mapped_array = MapOrganiser.gather(workers)
  end

end


defmodule WorkerFriend do
  def ready do
    receive do
      {organiser, number, fun}->
        IO.puts "Worker doing the calc for #{inspect number}"
        new_number = fun.(number)
        send( organiser, {self, new_number} )
    end
  end
end


# start_list = [1,2,3,4]
#
# IO.puts "starting"
#
# workers = MapOrganiser.create_workers( start_list )
# mapped_array = MapOrganiser.organise(workers)
#
# IO.puts "Mapped array #{inspect mapped_array }"
