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
10) activeActionCount
]]--

actionTypes = {}
actionTypes["CRAFTING"] = "crafting"--0
actionTypes["MACHINE_USING"] = "machine"--1
actionTypes["MINING"] = "mining"--2
actionTypes["GATHERING"] = "gathering"--3
actionTypes["FARMING"] = "farming"--4
actionTypes["EXECUTING"] = "executing"--5 --executing a function, for example a build - function
actionTypes["REQUEUE"] = "requeueing" -- 6

function requeueStep()
    local ret = {}
    ret.type= actionTypes.REQUEUE
    ret.totalActionCount = 1
    ret.itemsDone = 0
    ret.outMult = 1
    ret.preconditions = {}
    return ret
end

function getStep(stepnum)
    if stepnum == 1 then
        local plan = {}
        plan.type = actionTypes["EXECUTING"]
        plan.args = "buildTurtle"
        plan.totalActionCount = 10
        local itemsNeeded={}
        itemsNeeded["computercraft:turtle_normal"]=1
        itemsNeeded["minecraft:diamond_pickaxe"]=1
        plan.itemsDone = 0
        plan.outMult=1
        plan.preconditions=generateObtainmentPlanForList(itemsNeeded, plan.totalActionCount)
        return plan
    end
    log("Error, stepnum not implementes: ")
    log(stepnum)
    error("Stepnum not implemented")
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
        addItemsToPlanAndCalculateAvailableSteps(j,items)
    end

    --Update possible steps
    local maxPossible = plan.totalActionCount
    for _,substep in pairs(plan.preconditions) do
        maxPossible = math.min(maxPossible, math.floor(substep.itemsDone*substep.outMult/substep.necessaryForStepAbove))
    end

    plan.availableActionCount = maxPossible - plan.itemsDone
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
