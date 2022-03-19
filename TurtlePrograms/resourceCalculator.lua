
function machineRunningCosts(machineNum, useCount)
    if machineNum == 0 then return {} end
    if machineNum == 1 then
        local ret = {}
        ret["minecraft:coal"]=useCount
    end
    log("ERROR: Unknown Machine, #"..machineNum)
end

function resourceCostsList(toMake, itemsAvailable)
    if itemsAvailable == nil then itemsAvailable ={} end
   return resourceCostsListHelper(toMake, copyTable(itemsAvailable))
end

function resourceCostsListHelper(toMake, itemsAvailable)
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
    if isMineable(itemname) or isGatherable(itemname) then
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
        ret = addValues(ret,machineRunningCosts(tmpMachine, math.ceil(itemcount/tmpRecipeMult)))
        return ret
    else
        log("Error: Didn't find Recipe for "..itemname..", but it also neither mineable nor gatherable.")
        return nil
    end
end

function isMineable(itemname)
    if itemname=="minecraft:iron_ore" then return true end
    if itemname=="minecraft:gold_ore" then return true end
    if itemname=="minecraft:cobblestone" then return true end
    if itemname=="minecraft:diamond" then return true end
    if itemname=="minecraft:redstone" then return true end
    if itemname=="minecraft:coal" then return true end
    if itemname=="emendatusenigmatica:iron_chunk" then return true end
    if itemname=="emendatusenigmatica:gold_chunk" then return true end
    return false
end

function isGatherable(itemname)
    if itemname==woodsName then return true end
    if itemname=="minecraft:sand" then return true end
    if itemname=="minecraft:dirt" then return true end
    return false
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