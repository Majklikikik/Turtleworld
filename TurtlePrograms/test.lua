require("req")
readChestFile()

--[[
local state = {}
state.turtleCount = 1
state.resources = getTotalItemCounts()
state.resources["computercraft:turtle_normal"] = state.resources["computercraft:turtle_normal"] - 1
state.resources["minecraft:diamond_pickaxe"] = state.resources["minecraft:diamond_pickaxe"] - 1
state.stage = 1
local str = textutils.serialize(state)


local h=fs.open("uncompressed","w")
h.write(str)
h.close()


local str2= compress(str)
h=fs.open("compressed","w")
h.write(str2)
h.close()

h=fs.open("decompressed","w")
h.write(uncompress(str2))
h.close()
]]--
initiateRecipes()
initGatherableAndMineableResources()
plan=getStep(1)
log("Plan at start:")
log(plan)
local addItems= {}
addItems["minecraft:cobblestone"]=20
addItems["minecraft:iron_ingot"]=30
addItems[woodsName] = 10
log("Adding: ")
log(addItems)
addItemsToPlanAndCalculateAvailableSteps(plan,addItems)
log("New Plan:")
log(plan)

local possibleActions=getAvailableSteps(plan)
log("Available actions:")
--log(possibleActions)
for i,j in pairs(possibleActions) do
    logActionNoSubsteps(j)
end