require("req")
--for i=1,25 do
--    log(textutils.serialize(spiralNumberToCoordinate(i)))
--end

Initiate({0,65,0,"NORTH"})
turn(directions["NORTH"])

moveOverGround()
--for i=1,10 do moveOverGround() end
--lookInCurrentChunkForWood(0,true)

