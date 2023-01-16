--[[Useful Functions:
getFirstMachineStep(machineSteps) : Marks the first machine which the steps needs as "in Use", accordingly modifies the steps
getNextStep(): Returns the step, which should be done next
processAnswer(): Processes the answer of the slave-turtle
sendUseMachine(step): Sends the slave to use a machine
executeNextStep(step): executes the step in the parameter
]] --

require("req")

function getFirstMachineStep(machineSteps)
    for _, step in pairs(machineSteps) do
        for num, machineState in pairs(generalState.machines[step.args[1]]) do
            if machineState == -1 then
                step.args[2] = num
                return step
            end
        end
    end
end

function getNextStep()
    --[[
     Priority:
     1) Crafting, as it can be done quickly and instantly
     2) Using machines, as it is done quickly by the turtle, but may take some time until the machine is done
     3) Executing: Building any special stuff or so
     4) Farming, Gathering or Mining, here trying to optimize the ratio so that not all turtles are doing the same (if different activities are neeeded)
     ]] --
    local availableSteps = getAvailableSteps(generalState.currentPlan)
    local bestSteps = filterActionsByType(availableSteps, actionTypes.CRAFTING)
    if not isEmpty(bestSteps) then
        return bestSteps[1]
    end

    bestSteps = filterActionsByType(availableSteps, actionTypes.MACHINE_USING)
    if not isEmpty(bestSteps) then
        local machineStep = getFirstMachineStep(bestSteps)
        if machineStep ~= nil then return machineStep end
    end

    bestSteps = filterActionsByType(availableSteps, actionTypes.EXECUTING)
    if not isEmpty(bestSteps) then
        return bestSteps[1]
    end


    local farmsteps, gathersteps, minesteps
    farmsteps = filterActionsByType(availableSteps, actionTypes.FARMING)
    for _, j in pairs(farmsteps) do
        if generalState.farmTimestampAvailableList[i.name] < os.clock() and generalState.turtlesFarming[i.name] == 0 then
            return j
        end
    end
    gathersteps = filterActionsByType(availableSteps, actionTypes.GATHERING)
    minesteps = filterActionsByType(availableSteps, actionTypes.MINING)
    local sum1 = sumActionTotalCounts(gathersteps)
    local sum2 = sumActionTotalCounts(minesteps)
    if sum1 + sum2 == 0 then
        log("No Step Available!")
        return requeueStep()
    end

    if generalState.turtlesGathering + generalState.turtlesMining == 0 then
        if sum1 > 0 then
            return gathersteps[1]
        else
            return minesteps[1]
        end
    end
    if generalState.turtlesGathering / (generalState.turtlesGathering + generalState.turtlesMining) <
        sum1 / (sum1 + sum2
        ) or sum2 == 0 then
        return gathersteps[1]
    else
        return minesteps[1]
    end
end

--Processes the answer of a slave turtles
function processAnswer()
    gotoCommunication()
    local answer = uncompressMessage(textutils.unserialize(uncompress(comm_getMessage())))
    log("Turtle returned with Answer:")
    log(answer)
    return answer.turtleName
end

function sendUseMachine(step)
    local msg = {}
    msg.type = actionTypes.useMachine
    setRecipe(step.name)

    msg.itemsNeeded = itemsNeededForExecutingMaxOneStack(step)

    local count = math.min(step.availableActionCount, recipe_maxCount)

    msg.machine = step.args
    generalState.machines[step.args[1]][step.args[2]] = -2
    step.activeActionCount = step.activeActionCount + count
    step.availableActionCount = step.availableActionCount - count
    msg.stepNum = #generalState.activeActions + 1
    generalState.activeActions[#generalState.activeActions + 1] = step
    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            turtle.drop()
        end
    end
    log(msg)
    log(compress(textutils.serialize(compressMessage(msg))))
    comm_sendMessage(compress(textutils.serialize(compressMessage(msg))))
end

function executeNextStep(step)
    if step.type == actionTypes.CRAFTING then
        --just craft
        turn(directions.NORTH)
        while current_pos.z < basespots_chestBase.z do move_forward() end
        craft(step.name, step.availableSteps * step.outMult)
        step.itemsDone = step.itemsDone + step.availableSteps * step.outMult
        step.availableSteps = 0
        addItemsToPlanAndCalculateAvailableSteps(generalState.currentPlan)
        return
    end

    local turtleName = processAnswer()
    if step.type == actionTypes.MACHINE_USING then
        gotoChests()
        log("Getting Items for Machine Using.")
        getItems(itemsNeededForExecutingMaxOneStack(step))
        gotoCommunication()
        sendUseMachine(step)

    elseif step.type == actionTypes.MINING then
    elseif step.type == actionTypes.GATHERING then
    elseif step.type == actionTypes.REQUEUE then
    elseif step.type == actionTypes.FARMING then
    elseif step.type == actionTypes.EXECUTING then
    end
end

local testing = true
resetLog()
initBossFromFile()
--log(generalState)

--JUST FOR DEBUGGING! REMOVE LATER
inventur()

local nextStep
while true do
    log(generalState)
    nextStep = getNextStep()
    executeNextStep(nextStep)
    if (not testing) and generalState.currentPlan.totalActionCount == generalState.currentPlan.itemsDone then
        generalState.progress = generalState.progress + 1
        generalState.currentPlan = getStep(generalState.progress)
        addItemsToPlanAndCalculateAvailableSteps(generalState.currentPlan, getTotalItemCounts())
    end
end
