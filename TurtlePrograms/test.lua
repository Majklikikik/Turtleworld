require("req")
readChestFile()
function getFirstMachineStep(machineSteps)
    for _,step in machineSteps do
        for num, machineState in  generalState.machines[step.args[1]] do
            if machineState == -1 then
                step.args[2] = num
                return step
            end
        end
    end
end

function getNextStep()
    local availableSteps = getAvailableSteps(generalState.currentPlan)
    local bestSteps = filterActionsByType(availableSteps,actionTypes.CRAFTING)
    if not isEmpty(bestSteps) then
        return bestSteps[1]
    end

    bestSteps = filterActionsByType(availableSteps,actionTypes.MACHINE_USING)
    if not isEmpty(bestSteps) then
        local machineStep = getFirstMachineStep(bestSteps)
        if machineStep~=nil then return machineStep end
    end

    bestSteps = filterActionsByType(availableSteps,actionTypes.EXECUTING)
    if not isEmpty(bestSteps) then
        return bestSteps[1]
    end


    local farmsteps, gathersteps, minesteps
    farmsteps = filterActionsByType(availableSteps,actionTypes.FARMING)
    for _,j in pairs(farmsteps) do
        if generalState.farmTimestampAvailableList[i.name]<os.clock() and generalState.turtlesFarming[i.name]==0 then
            return j
        end
    end
    gathersteps = filterActionsByType(availableSteps,actionTypes.GATHERING)
    minesteps = filterActionsByType(availableSteps,actionTypes.MINING)
    local sum1 = sumActionTotalCounts(gathersteps)
    local sum2 = sumActionTotalCounts(minesteps)
    if sum1+sum2 == 0 then
        log("No Step Available!")
        return requeueStep()
    end

    if generalState.turtlesGathering+generalState.turtlesMining == 0 then
        if sum1>0 then
            return gathersteps[1]
        else
            return minesteps[1]
        end
    end
    if generalState.turtlesGathering/(generalState.turtlesGathering+generalState.turtlesMining) < sum1 / (sum1+sum2) or sum2 == 0then
        return gathersteps[1]
    else
        return minesteps[1]
    end

end

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


--[[plan=getStep(1)
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
end]]--

--inventur()
--initComputerFile()
--initBossFromFile()
--log("General State:")
--log(generalState)
--log("All possible steps:")
--for i,j in pairs(getAvailableSteps(generalState.currentPlan)) do
--    logActionNoSubsteps(j)
--end
--log("First step:")
--logActionNoSubsteps(getNextStep())

copyProgramsToDisk()