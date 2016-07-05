defmodule ParallelMap do
  def p_map(list, fun) do
    # me = self
    list
    |> Enum.map( fn(elem)->
      # spawn fn -> ( send me, { self, fun.(elem)} )end
      worker = spawn( MapWorker, :work, [] )
      send( worker, {self, fun, elem} ) #Currently main process is not expecting to receive results.  Race condition?
      worker
    end)
    |> Enum.map(
      fn(pid)->
        IO.puts "Making receive block #{inspect pid}"
        #How does the map know to wait until receive block is completed
        receive do
          {^pid, result} ->
            IO.puts "Received result#{inspect pid} #{inspect result}"
            result
        end
      end
    )
  end
end


defmodule MapWorker do
  def work do
    receive do
      {sender, fun, elem} ->
        IO.puts "Worker doing elem #{inspect elem}"
        result = fun.(elem)
        IO.puts "Worker made result #{inspect result}"
        send( sender, {self, result} )
    end
  end
end
