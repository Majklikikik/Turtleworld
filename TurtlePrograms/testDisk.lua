turtle.forward()
turtle.forward()
turtle.select(1)
turtle.place()
turtle.select(2)
turtle.drop()

if not fs.exists("disk/startup") then
  fs.copy("/diskStartup", "disk/startup")
end
if not fs.exists("disk/turtleStartup") then
  fs.copy("/turtleStartup", "disk/turtleStartup")  
end
local h = fs.open("disk/turtleNumber","w")
h.writeLine("1")
h.close()
os.setComputerLabel("Bob 0")
turtle.back()
turtle.select(3)
turtle.place()
local newbie = peripheral.wrap("front")
newbie.turnOn()
turtle.back()