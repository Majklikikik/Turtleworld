require("recipesInitiation")
require("resourceCalculator")
require("communication")
require("generalHelpingFunctions")
require("itemstacksizesAndMaxCounts")
require("logger")
require("standardValues")
require("recipes")
require("init")
require("mainPlanner")
function getNextStep()
    local availableSteps = getAvailableSteps(generalState.currentPlan)
    local bestSteps = filterActionsByType(availableSteps,actionTypes.CRAFTING)
    if not isEmpty(bestSteps) then
        return bestSteps[1]
    end

    bestSteps = filterActionsByType(availableSteps,actionTypes.MACHINE_USING)
    if not isEmpty(bestSteps) then
        return bestSteps[1]
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

function executeNextStep()

end

resetLog()
initBossFromFile()
log(generalState)

local nextStep
while true do
    nextStep = getNextStep()
    executeNextStep(nextStep)
    if generalState.currentPlan.totalActionCount == generalState.currentPlan.itemsDone then
        generalState.progress=generalState.progress + 1
        generalState.currentPlan=getStep(generalState.progress)
        addItemsToPlanAndCalculateAvailableSteps(generalState.currentPlan, getTotalItemCounts())
    end
end



