resourcesMineable = {}      -- can be collected from surface
resourcesGatherable = {}    -- can be mined
resourcesFarmable = {}      -- farm built

function machineRunningCosts(machineNum, useCount)
    if machineNum == 0 then return {} end
    if machineNum == 1 then
        local ret = {}
        ret["minecraft:coal"]= useCount
        return ret
    end
    log("ERROR: Unknown Machine, #"..machineNum)
    error("Unknown Machine")
end

function resourceCostsList(toMake, itemsAvailable)
    if itemsAvailable == nil then itemsAvailable ={} end
   return resourceCostsListHelper(toMake, copyTable(itemsAvailable))
end

function resourceCostsListHelper(toMake, itemsAvailable)
    if toMake == nil then return {} end
    local ret = {}
    for i,j in pairs(toMake) do
            ret = addValues(ret, resourceCosts(i, j, itemsAvailable))
    end
    return ret
end


function resourceCosts(itemname, itemcount, itemsAvailable)
    if itemsAvailable == nil then itemsAvailable ={} end
    return resourceCostsHelper(itemname, itemcount, copyTable(itemsAvailable))
end

-- calculates which items are needed and how many, to get itemcount of itemname
-- recursively opens looks in craftin recipes, unless itemname is either farmable or craftable
function resourceCostsHelper(itemname, itemcount, itemsAvailable)
    if itemsAvailable[itemname] ~= nil then
        local take = math.min(itemsAvailable[itemname], itemcount)
        itemsAvailable[itemname]=itemsAvailable[itemname] - take
        itemcount=itemcount - take
        if itemsAvailable[itemname] == 0 then
            itemsAvailable[itemname] = nil
        end
        if itemcount == 0 then
            return {}
        end
        end
    local ret={}
    if isMineable(itemname) or isGatherable(itemname) or isFarmable(itemname) then
        ret[itemname]=itemcount
        return ret
    elseif setRecipe(itemname) then
        --make a local copy of items needed for this iem
        local tmpList={}
        local tmpRecipeMult= recipe_outputMult
        local tmpMachine = recipe_machine
        for i,j in pairs(recipes_itemsNeeded) do
            tmpList[i]=j
        end

        --log("For "..itemname .. " x "..itemcount)
        --log(tmpList)
        --attention: cannot work recursively directly with recipes_itemsneeded, as the recursion step would change the recipe!!!

        --for each item, get the resourceCosts list and add them
        for i,j in pairs(tmpList) do
            local amount = math.ceil(itemcount/tmpRecipeMult)*j
            ret=addValues(ret, resourceCostsHelper(i,amount, itemsAvailable))
        end
        ret = addValues(ret,resourceCostsListHelper(machineRunningCosts(tmpMachine, math.ceil(itemcount/tmpRecipeMult)),itemsAvailable))
        return ret
    else
        log("Error: Didn't find Recipe for "..itemname..", but it also neither mineable nor gatherable nor farmable.")
        error("Recipe Unknown, but also neither Gatherable nor Mineable")
        return nil
    end
end

function isMineable(itemname)
    return resourcesMineable[itemname]==true
end

function isGatherable(itemname)
    return resourcesGatherable[itemname]==true
end

function isFarmable(itemname)
    return resourcesFarmable[itemname] == true
end

function initGatherableAndMineableResources()
    resourcesMineable["minecraft:iron_ore"]=true
    resourcesMineable["minecraft:gold_ore"]=true
    resourcesMineable["minecraft:cobblestone"]=true
    resourcesMineable["minecraft:diamond"]=true
    resourcesMineable["minecraft:redstone"]=true
    resourcesMineable["minecraft:coal"]=true
    resourcesMineable["minecraft:lapis_lazuli"]=true
    resourcesMineable["emendatusenigmatica:iron_chunk"]=true
    resourcesMineable["emendatusenigmatica:gold_chunk"]=true

    resourcesGatherable["minecraft:sand"]=true
    resourcesGatherable["minecraft:dirt"]=true
    resourcesGatherable["minecraft:sugar_cane"]=true
    resourcesGatherable[woodsName]=true
end

function mineableResources(resourceList)
    local ret={}
    for i,j in pairs(resourceList) do
        if isMineable(i) then
            ret[i]=j
        end
    end
    return ret
end

function gatherableResources(resourceList)
    local ret={}
    for i,j in pairs(resourceList) do
        if isGatherable(i) then
            ret[i]=j
        end
    end
    return ret
end

function farmableResources(resourceList)
    local ret={}
    for i,j in pairs(resourceList) do
        if isFarmable(i) then
            ret[i]=j
        end
    end
    return ret
end