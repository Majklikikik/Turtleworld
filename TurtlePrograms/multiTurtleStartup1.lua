fs.copy("disk/turtleStartup", "/startup")
fs.copy("disk/communication", "/communication")
fs.copy("disk/generalHelpingFunctions", "/generalHelpingFunctions")
fs.copy("disk/itemstacksizesAndMaxCounts", "/itemstacksizesAndMaxCounts")
fs.copy("disk/logger", "/logger")
fs.copy("disk/standardValues", "/standardValues")
fs.copy("disk/recipes", "/recipes")
fs.copy("disk/init", "/init")
fs.copy("disk/processCommand","/processCommand")
fs.copy("disk/build", "/build")
fs.copy("disk/crafting", "/crafting")
fs.copy("disk/mining", "/mining")
fs.copy("disk/moveInBase", "/moveInBase")
fs.copy("disk/movement", "/movement")
fs.copy("disk/smelting", "/smelting")
fs.copy("disk/farming", "/farming")
fs.copy("disk/req", "/req")
fs.copy("disk/inventory", "/inventory")



require("req")
local h = fs.open("disk/turtleNumber","r")
local num = textutils.unserialize(h.readAll())[1]
h.close()
local h = fs.open("disk/height","r")
local height = textutils.unserialize(h.readAll())[1]
h.close()
h = fs.open("disk/turtleNumber","w")
h.writeLine(textutils.serialize({ num+1 }))
h.close()
initMultiTurtle(num, height)
if num == 1 then sleep(10) end
turtle.equipRight()
navigateCoordinates(25,houseGroundLevel, 5)
navigateCoordinates(basespots_queue.x,houseGroundLevel,5)
turn(directions.NORTH)
while current_pos.z<basespots_queue.z do
    moveOverGround()
end
os.reboot()