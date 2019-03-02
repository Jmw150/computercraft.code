function dig100()
  for i=1,100 do
    turtle.dig()
    turtle.attack()
    turtle.digUp()
    turtle.forward()
  end
end

function place()
  for i=1,16 do
    turtle.select(i)
    turtle.dropDown()
  end
end

dig100()
turtle.turnRight()
turtle.turnRight()
dig100()
place()
