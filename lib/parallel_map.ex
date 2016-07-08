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
        receive do
          {^pid, result} ->
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
        result = fun.(elem)
        send( sender, {self, result} )
    end
  end
end
