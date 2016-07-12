defmodule Mocks do
  def expensive(number) do
    Enum.reduce(1..100000, fn(element, reducer)-> reducer + :math.sqrt(element) * number end)
  end
end
#

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



list = Enum.to_list 1..10

{time, result} = :timer.tc( ParallelMap, :p_map, [list, &Mocks.expensive/1 ])
IO.puts inspect time
sum = Enum.reduce(result, fn(element, reducer)-> reducer + element end)
IO.puts inspect sum


{time, result} = :timer.tc( Enum, :map, [list, &Mocks.expensive/1 ])
IO.puts inspect time
sum = Enum.reduce(result, fn(element, reducer)-> reducer + element end)
IO.puts inspect sum
