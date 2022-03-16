require("farming")
require("movement")
require("build")
require("smelting")
require("init")
require("logger")
require("crafting")


function InitiateChests()
    --Collect 6 times Wood, should be of the same Type
    local chunkNum=1
    while not lookInChunkForWood(chunkNum,6,false,true) do
        chunkNum=chunkNum + 1
    end
    countInventory()
    local chestCount
    local toKeep = {}
    if inventory_inv["minecraft:birch_log"]~=nil and inventory_inv["minecraft:birch_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:birch_log"]))
        toKeep["minecraft:birch_log"]=chestCount*2
    elseif inventory_inv["minecraft:spruce_log"]~=nil and inventory_inv["minecraft:spruce_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:spruce_log"]))
        toKeep["minecraft:spruce_log"]=chestCount*2
    elseif inventory_inv["minecraft:oak_log"]~=nil and inventory_inv["minecraft:oak_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:oak_log"]))
        toKeep["minecraft:oak_log"]=chestCount*2
    elseif inventory_inv["minecraft:jungle_log"]~=nil and inventory_inv["minecraft:jungle_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:jungle_log"]))
        toKeep["minecraft:jungle_log"]=chestCount*2
    elseif inventory_inv["minecraft:acacia_log"]~=nil and inventory_inv["minecraft:acacia_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:acacia_log"]))
        toKeep["minecraft:acacia_log"]=chestCount*2
    elseif inventory_inv["minecraft:dark_oak_log"]~=nil and inventory_inv["minecraft:dark_oak_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:dark_oak_log"]))
        toKeep["minecraft:dark_oak_log"]=chestCount*2
    else
        log("Error, somehow didn't get 6 of the same wood type")
    end

    log("Going to Chestbase: "..basespots_chestBase.x..":"..basespots_chestBase.y..":"..basespots_chestBase.z)
    go_towards(basespots_chestBase)
    dropEverythinExcept(toKeep)
    log("Crafting "..chestCount.." chests!")
    craft("minecraft:startPlanks", 8*chestCount) -- Fails if more than 6 logs are in inventory
    craft("minecraft:startChest", chestCount)

    for _ = 1, chestCount do
        PlaceChest()
    end

end

function Mine(item, quantity)
    -- drop inventory in chests before and after
    if not checkMined(item, quantity) then
        goal[item]= quantity
        dropInventory()
        mine(goal)
        navigate(home)
        turn(directions["EAST"])
        saveExtraMined()
        dropInventory(item, quantity)
    end

end

function Gather(goal)
    -- drop inventory in chests before and after
    dropInventory()
    gather_wood(goal)
    navigate(home)
    turn(directions["EAST"])
    dropInventory()
end


-- Requirement:  Furnace in storage
-- Reward: Smelting is now available
function PlaceFurnace()

    itemsWanted["minecraft:furnace"] = 1
    getmissing()
    build_furnace()
    go_towards(home)
end

-- Requirement: Chest in Inventory
-- Reward: Storage System yay
function PlaceChest()
    itemsWanted["minecraft:chest"] = 1
    getmissing()
    build_chest()
    while move_down(false) do end
end


--Requirement: Items needed for crafting in inventory or chest
--Reward: Items get crafted
function Craft(itemname, itemcount)
    craft(itemname, itemcount, false, false)
    dropInventory()
end

-- Requirement: Furnace placed, Items in Inventory
-- Reward: new Materials
function Smelt(itemname, itemcount, fuelname, fuelcount)
    smelt(itemname, itemcount, fuelname, fuelcount)
    go_towards(home)
    turn(directions["EAST"])
    dropInventory()
end


