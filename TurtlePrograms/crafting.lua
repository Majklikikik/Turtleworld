require("recipes")

--[[
function itemsToCraftAvailable(itemname, count, recursion, useExistingItems, withCurrentReservations)
    if withCurrentReservations== nil then withCurrentReservations=false end
    if recursion==nil then recursion=true end
    if not withCurrentReservations then
        resetReservations()
        sumInventoryAndAllChests()
    end

    return itemsToCraftAvailableHelper(itemname, count, recursion, useExistingItems)
end

function itemsToCraftAvailableHelper(itemname, count, recursion, notFirstStep)
    log("Checking for availability of "..count.."  "..itemname)
     if itemsAvailable(itemname,count,true) and notFirstStep then
            reserve(itemname, count)
        else
            if notFirstStep then
                local available=maximumItemCountAvailable(itemname)
                reserve(itemname, available)
                count=count-available;
            end
            if not setRecipe(itemname,count) then
                -- checks if recipe exists and ALSO sets it
                log("No Recipe found for "..itemname)
                return false
            end
            local itemsWanted={}
            for i,_ in pairs(itemsNeeded) do
                itemsWanted[i]=itemsNeeded[i]
            end
            for i,_ in pairs(itemsWanted) do
                if recursion then
                    if not itemsToCraftAvailableHelper(i,itemsWanted[i],recursion,true) then
                        log(i.." not available!")
                        return false
                    end
                else
                    if not itemsAvailable(i, itemsWanted[i]) then
                        log(i.." not available!")
                        return false
                    end
                end
            end
        end
    log(itemname.." available!")
    return true
end
]]--

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
        max=maximumItemCountAvailable(recipeID)
        if max>=count then
            log("Items already available in Chests/Inventory!")
            getFromChests(recipeID,count)
        else
            craft(itemname,count-max,false,false)
            getFromChests(recipeID,max)
        end
        return true
    end
    log("Getting items!")
    log("Crafting "..count.." items, maximal count of items to be crafted in one Batch is "..maxCount)
    -- if too many items need to be crafted, crafting needs to be repeated multiple times
    for i=1,math.floor(count/maxCount) do
        log("Getting a full batch!")
        getItemsFor(recipeID,maxCount)
        arrangeInventoryToRecipe()
        turtle.craft(maxCount)
    end
    if count%maxCount>0 then
        log("Getting items for "..recipeID.." x "..(count%maxCount))
        getItemsFor(recipeID,count%maxCount)
        arrangeInventoryToRecipe()
        turtle.craft(count%maxCount)
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
    turtle.select(slot["computercraft:turtle_normal"])
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

function swap(this, other)

end

--[[function craftRecursively(itemname, count, checkForAvailability, alsoGetAlreadyExistingItems)
    checkForAvailability=checkForAvailability or false
    if checkForAvailability then
        if not itemsToCraftAvailable(itemname,count,true, alsoGetAlreadyExistingItems) then
            return false
        end
    end

    log("Crafting "..itemname.." x "..count.." with recursion")

    if (alsoGetAlreadyExistingItems) then
        max=maximumItemCountAvailable(itemname)
        if max>=count then
            log("Items already available in Chests/Inventory!")
            getFromChests(itemname,count)
            return true
        elseif max>0 then
            setRecipe(itemname,count-max)
            local willCraft=mult*(math.ceil((count-max)/mult))
            --log("COUNTS: "..itemname.."  "..willCraft.."  "..count-willCraft.."  "..max.."  "..mult)
            log("Crafting "..willCraft.." and getting the Rest from Chests")
            reserve(itemname,max)
            craftRecursively(itemname,count-max,false,false)

            getFromChests(itemname,count-willCraft)
            return true
        end
    end


--log("Still trying to craft "..itemname.." x "..count)
    if itemsToCraftAvailable(itemname,count,false, false,true) then
        --can be crafted directly
        log("Going to craft directly, ingredients available!")
        craft(itemname,count,false,false)
    else
        log("Time to (re-)curse! From: "..itemname.." x "..count)
        --recursion needs to be done
        setRecipe(itemname,count)
        local tmpItemsNeeded={}
        for item in pairs(itemsNeeded) do
            tmpItemsNeeded[item]=itemsNeeded[item]
        end
        for item in pairs(tmpItemsNeeded) do
            if not itemsAvailable(item,tmpItemsNeeded[item]) then
                -- if item is not in chests, it needs to be crafted first
                craftRecursively(item,tmpItemsNeeded[item],false,true)
            end
        end
        -- now call yourself again, this way:
        -- if now all items are ready, the wanted item will be crafted directly
        -- if one of the necessary items was used for crafting another necessary item, it will be crafted again
        sumInventoryAndAllChests()
        log("Should now have all ingredients. Retrying crafting!")
        craftRecursively(itemname,count,false, false)
    end
    return true
end
]]--