--[[Useful Functions:

]]--


--[[
A Step is modelled by a List cointaining:
1) totalCount: how many times it should be done totally (necessary for crafting, smelting, machine using)
2) type: craftin, smelting,...
3) args: possible arguments for the executing function
4) preconditions: Steps, which must be done before this step can be executed
where preconditions[i] is itself an array, containing the # multiplicity, how many times the precondition must be executed to execute this action once
5) itemsDone: count, how many times the action is already done
6) necessaryForStepAbove: Count, how many times this step needs to be executed for the step above to be executed once
7) name
8) OutMult:
9) availableActionCount
10) activeActionCount: How many times the action is currently active
]]--


function requeueStep()
    local ret = {}
    ret.type= actionTypes.REQUEUE
    ret.totalActionCount = 1
    ret.itemsDone = 0
    ret.outMult = 1
    ret.preconditions = {}
    ret.activeActionCount = 0
    ret.name="requeue"
    return ret
end

function getTestStep(testCase)
    if testCase == 1 then
        local plan = {}
        plan.type = actionTypes.MACHINE_USING
        plan.args = {1}
        plan.totalActionCount = 10
        plan.activeActionCount = 0
        local itemsNeeded={}
        itemsNeeded["minecraft:coal"]=1
        itemsNeeded["emendatusenigmatica:iron_chunk"]=8
        plan.itemsDone = 0
        plan.outMult=1
        plan.preconditions=generateObtainmentPlanForList(itemsNeeded, plan.totalActionCount)
        plan.name="minecraft:iron_ingot"
        return plan
    end
    log("Error, testCase not implementes: ")
    log(testCase)
    error("Testcase not implemented")
end

function getStep(stepnum)
    if stepnum == 1 then
        local plan = {}
        plan.type = actionTypes["EXECUTING"]
        plan.args = {"buildTurtle"}
        plan.totalActionCount = 10
        plan.activeActionCount = 0
        local itemsNeeded={}
        itemsNeeded["computercraft:turtle_normal"]=1
        itemsNeeded["minecraft:diamond_pickaxe"]=1
        plan.itemsDone = 0
        plan.outMult=1
        plan.preconditions=generateObtainmentPlanForList(itemsNeeded, plan.totalActionCount)
        plan.name="Build Turtle"
        return plan
    end
    log("Error, stepnum not implementes: ")
    log(stepnum)
    error("Stepnum not implemented")
end

function itemsNeededForExecutingMaxOneStack(step)
    local preSteps = generateMachineUsingPresteps(step.args[1],1)
    local itemsNeeded= {}
    log("Current Step:")
    log(step)
    for _,j in pairs(preSteps) do
        if itemsNeeded[j.name]==nil then
            itemsNeeded[j.name]=j.totalActionCount*j.outMult
        else
            itemsNeeded[j.name]=itemsNeeded[j.name]+j.totalActionCount*j.outMult
        end
    end
    setRecipe(step.name)
    itemsNeeded=addValues(itemsNeeded, recipes_itemsNeeded)
    log(recipes_maxCount)
    log(recipe_outputMult)
    log(step.availableActionCount)
    local count = math.min(recipe_maxCount/recipe_outputMult, step.availableActionCount)
    log("Items needed for Execcuting max one stack:")
    log(multiplicate(itemsNeeded, count))
    log(itemsNeeded)
    log(count)
    return multiplicate(itemsNeeded,count)
end

function generateObtainmentPlanForList(itemList, count)
    local ret = {}
    local c = 0
    for i,j in pairs(itemList) do
        c = c+1
        ret[c]=generateObtainmentPlanForItem(i,j*count, j)
    end
    return ret
end

function generateObtainmentPlanForItem(itemname, totalItemCount, necessaryForStepAbove)
    local plan = {}
    plan.name = itemname
    plan.totalActionCount = totalItemCount
    plan.necessaryForStepAbove = necessaryForStepAbove
    plan.itemsDone = 0
    plan.availableActionCount = 0
    plan.preconditions = {}
    plan.outMult = 1
    plan.availableActionCount = 0
    plan.activeActionCount = 0
    if isMineable(itemname) then
        plan.type = actionTypes.MINING
        plan.availableActionCount=plan.totalActionCount
        return plan
    end
    if isGatherable(itemname) then
        plan.type = actionTypes.GATHERING
        plan.availableActionCount=plan.totalActionCount
        return plan
    end
    if isFarmable(itemname) then
        plan.type = actionTypes.FARMING
        plan.availableActionCount=plan.totalActionCount
        return plan
    end

    setRecipe(itemname)
    plan.totalActionCount = math.ceil(plan.totalActionCount / recipe_outputMult)
    if recipe_machine == 0 then
        plan.type = actionTypes.CRAFTING
    else
        plan.type = actionTypes.MACHINE_USING
        plan.preconditions = generateMachineUsingPresteps(recipe_machine,plan.totalActionCount)
        plan.args={recipe_machine}
    end
    plan.outMult = recipe_outputMult
    plan.preconditions = concatenateTables(plan.preconditions, generateObtainmentPlanForList(copyTable(recipes_itemsNeeded),plan.totalActionCount))
    return plan
end

function generateMachineUsingPresteps(machineNum, count)
    if machineNum == 1 then
        return {generateObtainmentPlanForItem("minecraft:coal",count,1)}
    end
    log("Unknown machine: ")
    log(machineNum)
    error("Unknown Machine")
end

function addItemsToPlanAndCalculateAvailableSteps(plan, items)
    return addItemsToPlanAndCalculateAvailableStepsHelper(plan, copyTable(items))
end

function addItemsToPlanAndCalculateAvailableStepsHelper(plan, items)
    --add Items
    if plan.type~=actionTypes.EXECUTING then
        if items[plan.name]~=nil then
            local addCount = math.min(plan.totalActionCount*plan.outMult - plan.itemsDone,items[plan.name])
            items[plan.name]=items[plan.name]-addCount
            if items[plan.name]==0 then items[plan.name]= nil end
            local beforeActionDoneCount = math.floor(plan.itemsDone / plan.outMult)
            plan.itemsDone = plan.itemsDone + addCount
            addActionsDone(plan, math.floor(plan.itemsDone / plan.outMult)-beforeActionDoneCount)
        end
    end

    for _,j in pairs(plan.preconditions) do
        addItemsToPlanAndCalculateAvailableStepsHelper(j,items)
    end

    --Update possible steps
    local maxPossible = plan.totalActionCount
    for _,substep in pairs(plan.preconditions) do
        maxPossible = math.min(maxPossible, math.floor(substep.itemsDone*substep.outMult/substep.necessaryForStepAbove))
    end

    plan.availableActionCount = maxPossible - math.floor(plan.itemsDone/plan.outMult) - plan.activeActionCount
end


--marks that the root action in the plan was done addCount times.
function addActionsDone(plan, addCount)
    if addCount == 0 then return end
    --log("Plan:")
    --log(plan)
    for _,subPlan in pairs(plan.preconditions) do
        --log("Subplans:")
        --log(subPlan)
        local addCount = math.min(subPlan.totalActionCount*subPlan.outMult - subPlan.itemsDone,subPlan.necessaryForStepAbove*addCount)
        local beforeActionDoneCount = math.floor(subPlan.itemsDone / subPlan.outMult)
        subPlan.itemsDone = subPlan.itemsDone + addCount
        addActionsDone(subPlan, math.floor(subPlan.itemsDone / subPlan.outMult)-beforeActionDoneCount)
    end
end

--returns the table, but also modifies it
function getAvailableSteps(plan, table)
    if table == nil then table = {} end
    if plan.availableActionCount > 0 then
        table = concatenateTables(table,{plan})
    end
    for _,substep in pairs(plan.preconditions) do
        getAvailableSteps(substep, table)
    end
    return table
end

function logActionNoSubsteps(plan)
    log("Item: "..plan.name)
    log("Total: "..plan.totalActionCount)
    log("Available: "..plan.availableActionCount)
    log("Done: "..plan.itemsDone)
    log("Type: "..plan.type)
    log("---------------------")
end

function filterActionsByType(actionTable, type)
    local ret = {}
    for _,j in pairs(actionTable) do
        if j.type==type then
            ret[#ret+1]=j
        end
    end
    return ret
end

function sumActionTotalCounts(actionlist)
    sum = 0
    for _,j in pairs(actionlist) do
        sum = sum + j.totalActionCount
    end
    return sum
end

function sumPreconditionItems(step)
    local ret = {}
    for _,j in step.preconditions do
        if ret[j.name]==nil then
            ret[j.name]=j.totalActionCount*j.outMult
        else
            ret[j.name]=ret[j.name]+j.totalActionCount*j.outMul
        end
    end
    return ret
end

function gotoChests()
    turn(directions.NORTH)
    while current_pos.z<basespots_chestBase.z do move_forward() end
end

function gotoCommunication()
    turn(directions.SOUTH)
    while current_pos.z>basespots_queue.z+1 do move_forward() end
end
