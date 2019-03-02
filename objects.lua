
local tArgs = { ... }

cat = { 
   name = "lol" , 
   mv = function (self,str) -- works poorly
      self.name = str
   end
}

--[[
change = function (self, str)
   self = str
end
   -- needing to pass in self is stupid...
   mvName = function (self, str) 
      self.name = str
   end
cat.mv = function (str) 
   cat.mvName(cat, str)
end
]]--


print (cat.name)

cat.mv(cat,"bot") -- why...

print (cat.name)

a = cat
b = cat

a.mv(a, "lol")

print (a.name)
print (b.name)
