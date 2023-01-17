function processCommand(command)
    local answer = {}
    if command.type == actionTypes.MACHINE_USING then
        executeUseMachine(command)
        answer.type = answerTypes.ACTION_DONE
        answer.turtleName = os.getComputerLabel()
    elseif command.type == actionTypes.REQUEUE then
    elseif command.type == actionTypes.EXECUTING then
    elseif command.type == actionTypes.FARMING then
    elseif command.type == actionTypes.GATHERING then
    elseif command.type == actionTypes.MINING then
    else
        log("Unknown Command")
        log(command.type)
        log(command)
    end
    return answer
end

function executeUseMachine(command)
    if command.machine[1] == 1 then
        smeltMultiTurtle(command.machine[2])
    else
        log("Unknown Machine: " .. command.machine[1])
        log(command)
    end
end

--msg={}
--msg.type = actionTypes.useMachine
--setRecipe(step.name)
--
--
--preSteps = generateMachineUsingPresteps(step.args[1],1)
--local itemsNeeded= {}
--for _,j in pairs(preSteps) do
--    if itemsNeeded[j.name]==nil then
--        itemsNeeded[j.name]=j.totalActionCount*j.outMult
--    else
--        itemsNeeded[j.name]=itemsNeeded[j.name]+j.totalActionCount*j.outMult
--    end
--end
--setRecipe(step.name)
--itemsNeeded=addValues(itemsNeeded, recipes_itemsNeeded)
--
--local count = math.min(recipe_maxCount/recipe_outputMult, step.availableSteps)
--
--
--msg.itemsNeeded=multiplicate(itemsNeeded,count)
--msg.machine=step.args
--generalState.machines[step.args[1]][step.args[2]]=-2
--step.activeActionCount = step.activeActionCount + count
--step.availableSteps = step.availableSteps-count
--msg.stepNum=#generalState.activeActions+1
--generalState.activeActions[#generalState.activeActions+1]=step
