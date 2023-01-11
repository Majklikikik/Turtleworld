require("req")

function getFirstMachineStep(machineSteps)
    for _,step in pairs(machineSteps) do
        for num, machineState in  pairs(generalState.machines[step.args[1]]) do
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

--Processes the answer of a slave turtlesMining
--Returns: True, if the answer shouldn't
function processAnswer()
    gotoCommunication()
    local answer = textutils.unserialize(comm_getMessage())
    log("Turtle returned with Answer:")
    log(answer)
    return answer.turtleName
end

function sendUseMachine(step)
    local msg={}
    msg.type = actionTypes.useMachine
    setRecipe(step.name)

    msg.itemsNeeded = itemsNeededForExecutingMaxOneStack(step)

    msg.machine=step.args
    generalState.machines[step.args[1]][step.args[2]]=-2
    step.activeActionCount = step.activeActionCount + count
    step.availableSteps = step.availableSteps-count
    msg.stepNum=#generalState.activeActions+1
    generalState.activeActions[#generalState.activeActions+1]=step
    for i=1,16 do
        if turtle.getItemCount(i)>0 then
            turtle.select(i)
            turtle.drop()
        end
    end
    comm_sendMessage(textutils.serialize(msg))
end

function executeNextStep(step)
    if step.type == actionTypes.CRAFTING then
        --just craft
        turn(directions.NORTH)
        while current_pos.z<basespots_chestBase.z do move_forward() end
        craft(step.name,step.availableSteps*step.outMult)
        step.itemsDone=step.itemsDone+step.availableSteps*step.outMult
        step.availableSteps=0
        addItemsToPlanAndCalculateAvailableSteps(generalState.currentPlan)

    elseif step.type == actionTypes.MACHINE_USING then
        gotoChests()
        getItems(itemsNeededForExecutingMaxOneStack(step))
        local turtleName = processAnswer()
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
log(generalState)

local nextStep
while true do
    log(generalState)
    nextStep = getNextStep()
    executeNextStep(nextStep)
    if (not testing) and generalState.currentPlan.totalActionCount == generalState.currentPlan.itemsDone then
        generalState.progress=generalState.progress + 1
        generalState.currentPlan=getStep(generalState.progress)
        addItemsToPlanAndCalculateAvailableSteps(generalState.currentPlan, getTotalItemCounts())
    end
end



