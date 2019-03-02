local tArgs = { ... }

cat = {
   name = "lol",
   race = "meow",
   alive = true
}

function cat:rename (str)
   .name = str
end

function new (ob)
   return ob
end

a = new(cat) --reference

rename (a,"oooooooo")

print (a.name)

print (cat.name)



