
defmodule Mocks do
  def expensive(number) do
    Enum.reduce(1..100, fn(element, reducer)-> reducer + :math.sqrt(element) * number end)
  end
end

defmodule ParallelSumma do
  def receive 
end

defmodule Summa do

  def sum( [], acc ) do
    acc
  end

  def sum( [ head | tail ], acc) do
    added = acc + Mocks.expensive(head)
    sum( tail, added )
  end

  # def sum(list) do
  #   sum = 4
  #   Enum.each( list, fn(num)-> sum = sum + 9 end )
  #   # fn(num)-> num * 2 end
  #   sum
  # end
end


# Summa.closure_play()
sum = Summa.sum( Enum.to_list(1..100000), 0 )
IO.puts( inspect sum )
