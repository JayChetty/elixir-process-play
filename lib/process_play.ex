defmodule Worker do
  def work do
    receive do
      {sender, text}->
        IO.puts "WORKER with id #{inspect self} #{text}"
        send(sender, {self, "good bro"})
    after
      1_000 -> IO.puts "timing out worker #{inspect self}"
    end
  end
end


defmodule ProcessPlay do
  require IEx
  def my_map([], fun) do
    []
  end

  def my_map( [ head | tail ], fun ) do
    [ fun.(head) | my_map( tail, fun ) ]
  end

  def manage do
    receive do
      {worker, text}->
        IO.puts "Mr Boss man got from worker #{text}"
    end
  end

  def my_map_p( [ head | tail ], fun ) do
    worker = spawn(Worker, :work , [])
    return = send(worker, {self, "sup worker"})
    manage()
  end

  def my_map_p( tuple , fun ) do
    worker = spawn(Worker, :work , [])
    return = send(worker, {self, "sup worker"})
    manage()
  end

end
