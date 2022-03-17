
-- calculates which items are needed and how many, to get itemcount of itemname
-- recursively opens looks in craftin recipes, unless itemname is either farmable or craftable
function resourceCosts(itemname, itemcount, itemsAvailable)
    if itemsAvailable== nil then itemsAvailable = {} end
    local ret={}
    if isMineable(itemname) or isGatherable(itemname) then
        ret[itemname]=itemcount
        return ret
    elseif setRecipe(itemname) then
        --make a local copy of items needed for this iem
        local tmpList={}
        local tmpRecipeMult= recipe_outputMult
        for i,j in pairs(recipes_itemsNeeded) do
            tmpList[i]=j
        end


        log(tmpList)
        --attention: cannot work recursively directly with recipes_itemsneeded, as the recursion step would change the recipe!!!

        --for each item, get the resourceCosts list and add them
        for i,j in pairs(tmpList) do
            local amount = math.ceil(itemcount/tmpRecipeMult)*j
            ret=addValues(ret, resourceCosts(i,amount, itemsAvailable))
        end
        return ret
    else
        log("Error: Didn't find Recipe for "..itemname..", but it also neither mineable not gatherable.")
        return nil
    end
end

function isMineable(itemname)
    if itemname=="minecraft:iron_ore" then return true end
    if itemname=="minecraft:cobblestone" then return true end
    if itemname=="minecraft:diamond" then return true end
    if itemname=="minecraft:redstone" then return true end
    if itemname=="minecraft:coal" then return true end
    if itemname=="minecraft:sand" then return true end
    return false
end

function isGatherable(itemname)
    if itemname==woodsName then return true end
    if itemname=="minecraft:sand" then return true end
    return false
end