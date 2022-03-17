require("req")
--for i=1,25 do
--    log(textutils.serialize(spiralNumberToCoordinate(i)))
--end
local arg = { ... }
init_turtle({0,63,0,0})

--moveOverGround()
--for i=1,10 do moveOverGround() end
--lookInCurrentChunkForWood(0,true)



--local chunkNum=arg[1]
--if chunkNum==nil then chunkNum=1  else chunkNum = tonumber(chunkNum) end
--for i=1,20 do
--    mineTunnel(chunkNum, i)
--end


--dropAbundantItemsNoChest()


--toCheck={}
--toCheck["minecraft:lapis_lazuli"]=100
--log(hasAll(toCheck))

--log(setRecipe("computercraft:turtle_mining_crafty"))

log(resourceCosts("computercraft:turtle_mining_crafty", 1, {}))