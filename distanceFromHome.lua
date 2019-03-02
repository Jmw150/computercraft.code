 local home = vector.new(146, 71, 261)
 local position = vector.new(gps.locate(5))
 local displacement = position - home
 
 print("I am ", tostring(displacement), " away from home!!!")
print(c.x,c.y,c.z)

