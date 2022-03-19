require("recipes")

--Lets the solo turtle craft the items, making the (recursive) plan and executing it
function craftRecursivelyUsingMachinesSingleTurtle(itemname, itemcount, itemsAvailable)
    return craftRecursivelyUsingMachinesHelper(itemname, itemcount, copyTable(itemsAvailable))
end


function craftRecursivelyUsingMachinesHelper(itemname, itemcount, itemsAvailable)
    local planAndRest = generateCraftingPlan(itemname, itemcount, itemsAvailable)
    local rest=planAndRest[2]
    local plan = planAndRest[1]
    for i=#plan, 1, -1 do
        executePlanStepSingleTurtle(plan[i])
    end
end

function executePlanStepSingleTurtle(planStep)
    if planStep[3] == 0 then
        craft(planStep[1], planStep[2])
    elseif planStep[3] == 1 then
        smeltSingleTurtle(planStep[1], planStep[2])
    end
end



-- returns a crafting Plan for itemname, also using recipe_machine, and the extraitems generated when crafting them
-- in the Plan: (=ret[1])
-- the i-th entry marks the i-th step.
-- each step has 3 entries: itemname, itemcount, machine
-- ret[2] is a itemlist, containing all items, which will additionalle get generated when executing the plan due to recipe mults
function generateCraftingPlan(itemName, itemCount, itemsAvailable)
    --log("Looking for Plan for "..itemName.." x "..itemCount)
    if containsItems(itemsAvailable, itemName, itemCount) then
        itemsAvailable[itemName] = itemsAvailable[itemName] - itemCount
        return {{},{}}
    end
    if isGatherable(itemName) then
        log("Warning! Must gather "..itemName.." x "..itemCount.." to Execute this Plan!!!")
        return {{},{}}
    end
    if isMineable(itemName) then
        log("Warning! Must mine "..itemName.." x "..itemCount.." to Execute this Plan!!!")
        return {{},{}}
    end
    if itemsAvailable[itemName] > 0 then
        local tmp = itemsAvailable[itemName]
        itemsAvailable[itemName] = nil
        return generateCraftingPlan(itemName, itemCount - tmp, itemsAvailable)
    end

    setRecipe(itemName)
    local plan = {{{itemName, math.ceil(itemCount/recipe_outputMult)*recipe_outputMult, recipe_machine}}, {}}

    local tmpList={}
    local tmpRecipeMult= recipe_outputMult
    local tmpMachine = recipe_machine
    for i,j in pairs(recipes_itemsNeeded) do
        tmpList[i]=j
    end

    --attention: cannot work recursively directly with recipes_itemsneeded, as the recursion step would change the recipe!!!

    --for each item, get the resourceCosts list and add them
    for i,j in pairs(tmpList) do
        local amount = math.ceil(itemCount/tmpRecipeMult)*j
        local plan2 = generateCraftingPlan(i,amount, itemsAvailable)
        plan[1]=concatenateTables(plan[1], plan2[1])
        -- if itemCount is not 0 modulo tmpRecipeMult, then more items than necessary wil get Crafted! Calculate them and return them too
        local rest = -itemCount % tmpRecipeMult
        local restList = {}
        if rest ~= 0 then
            restList[itemName] = rest
        end
        plan[2]=addValues(plan[2],addValues(plan2[2], restList))
    end
    return plan
end



-- Crafts an Item, withouth recursion steps
function craft(recipeID, count, checkForAvailability, alsoGetAlreadyExistingItems)
    setRecipe(recipeID, count)
    if recipeID =="computercraft:turtle_mining_crafty" then
        craftTurtle(recipeID, count)
        return true
    end
    log("Crafting "..recipeID.." x "..count.." directly")
    checkForAvailability=checkForAvailability or false
    if checkForAvailability then
        log("Warning: checkForAvailability is set true in craft: shouldn't be so!")
        if not itemsToCraftAvailable(itemname,count,false, alsoGetAlreadyExistingItems) then
            return false
        end
    end
    if (alsoGetAlreadyExistingItems) then
        log("Warning: alsoGetAlreadyExistingItems is set true in craft: shouldn't be so!")
        local max=maximumItemCountAvailable(recipeID)
        if max>=count then
            log("Items already available in Chests/Inventory!")
            getItemsOneType(recipeID,count)
        else
            craft(itemname,count-max,false,false)
            getItemsOneType(recipeID,max)
        end
        return true
    end
    log("Getting items!")
    log("Crafting "..count.." items, maximal count of items to be crafted in one Batch is ".. recipe_maxCount)
    -- if too many items need to be crafted, crafting needs to be repeated multiple times
    for i=1,math.floor(count/ recipe_maxCount) do
        log("Getting a full batch!")
        getItemsFor(recipeID, recipe_maxCount)
        arrangeInventoryToRecipe()
        turtle.craft(recipe_maxCount)
    end
    if count% recipe_maxCount >0 then
        log("Getting items for "..recipeID.." x "..(count% recipe_maxCount))
        getItemsFor(recipeID,count% recipe_maxCount)
        arrangeInventoryToRecipe()
        turtle.craft(count% recipe_maxCount)
    end
    return true
end
-- crafts exactly one crafty mining turtle
function craftTurtle(recipeID, count)
    sumInventoryAndAllChests()
    for i,_ in pairs(itemsWanted) do
        itemsWanted[i]=nil
    end
    itemsWanted["minecraft:diamond_pickaxe"]=1
    itemsWanted["computercraft:turtle_normal"]= 1
    getmissing()
    storeRest()

    setRecipe("computercraft:turtle_mining",1)
    arrangeInventoryToRecipe()
    turtle.craft()

    countInventory()
    turtle.select(inventory_slot["computercraft:turtle_normal"])
    turtle.transferTo(13)

    sumInventoryAndAllChests()
    for i,_ in pairs(itemsWanted) do
        itemsWanted[i]=nil
    end

    itemsWanted["minecraft:crafting_table"]=1
    getmissing()
    setRecipe("computercraft:turtle_mining_crafty",1)
    arrangeInventoryToRecipe()
    turtle.craft()


end
