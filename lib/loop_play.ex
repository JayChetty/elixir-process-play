defmodule LoopPlay do

  # def deal(:ok, data) do
  #
  # end
  #
  # def deal(:error, data) do
  # end
  #
  def loop([])do
    nil
  end

  def loop( [ head | tail ] ) do
    worker = spawn(Worker, :calculate, [])
    send( worker, { self ,head })
    loop( tail )
  end

  def displayCalc do
    receive do
      {result} ->
        IO.puts "Main process displaying output #{inspect result}"
        displayCalc
    end
  end
end
# IO.puts("doing expensive calculation #{inspect output}")
defmodule Worker do
  def calculate do
    receive do
      {master, number} ->
        output = number * 2
        send( master, {output})
    end
  end
end


# my_list = [1,2,3,4]
# tuple = {1,2,3,4}

# LoopPlay.loop( my_list )
# LoopPlay.displayCalc()
