defmodule Organiser do
  def organise do
    receive do
      {worker, return_value}->
        IO.puts "worker #{inspect worker} return value #{inspect return_value}"
        organise
    end
  end
end


defmodule Friend do
  def ready do
    receive do
      {organiser, number}->
        new_number = number * 2
        send( organiser, {self, new_number} )
        # IO.puts "Worker displaying message #{inspect message}"
        ready
    end
  end
end
#
#
# friend = spawn(Friend, :ready, [])
#
# IO.puts "starting"
# #at this point organiser not waiting for responses
# #assume that the messages store up in a kind of post box and the organiser then
# #handles them when they come in
# send( friend, {self, 1} )
#
# send( friend, {self, 2} )
#
#
# Organiser.organise()
