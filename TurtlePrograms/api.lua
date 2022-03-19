require("farming")
require("movement")
require("build")
require("smelting")
require("init")
require("logger")
require("crafting")


function initiateChests()
    --Collect 6 times Wood, should be of the same Type
    local chunkNum=1
    while not lookInChunkForWood(chunkNum,6,true,true) do
        chunkNum=chunkNum + 1
    end
    countInventory()
    local chestCount
    local toKeep = {}
    if inventory_inv["minecraft:birch_log"]~=nil and inventory_inv["minecraft:birch_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:birch_log"]/2))
        toKeep["minecraft:birch_log"]=chestCount*2
    elseif inventory_inv["minecraft:spruce_log"]~=nil and inventory_inv["minecraft:spruce_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:spruce_log"]/2))
        toKeep["minecraft:spruce_log"]=chestCount*2
    elseif inventory_inv["minecraft:oak_log"]~=nil and inventory_inv["minecraft:oak_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:oak_log"]/2))
        toKeep["minecraft:oak_log"]=chestCount*2
    elseif inventory_inv["minecraft:jungle_log"]~=nil and inventory_inv["minecraft:jungle_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:jungle_log"]/2))
        toKeep["minecraft:jungle_log"]=chestCount*2
    elseif inventory_inv["minecraft:acacia_log"]~=nil and inventory_inv["minecraft:acacia_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:acacia_log"]/2))
        toKeep["minecraft:acacia_log"]=chestCount*2
    elseif inventory_inv["minecraft:dark_oak_log"]~=nil and inventory_inv["minecraft:dark_oak_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:dark_oak_log"]/2))
        toKeep["minecraft:dark_oak_log"]=chestCount*2
    else
        log("Error, somehow didn't get 6 of the same wood type")
    end

    log("Going to Chestbase: "..basespots_chestBase.x..":"..basespots_chestBase.y..":"..basespots_chestBase.z)
    navigate(basespots_chestBase)
    dropEverythinExcept(toKeep)
    log("Crafting "..chestCount.." chests!")
    craft("minecraft:startPlanks", 8*chestCount) -- Fails if more than 6 logs are in inventory
    craft("minecraft:startChest", chestCount)

    turn(directions["NORTH"])
    for _ = 1, chestCount do
        placeChest()
    end

end



-- Requirement: Chest in Inventory
-- Reward: Storage System yay
function placeChest()
    itemsWanted["minecraft:chest"] = 1
    getmissing()
    build_chest()
    while move_down(false) do end
end

-- Requirement: Furnace placed, Items in Inventory
-- Reward: new Materials
function Smelt(itemname, itemcount, fuelname, fuelcount)
    smelt(itemname, itemcount, fuelname, fuelcount)
    navigate(home)
    turn(directions["EAST"])
    dropInventory()
end


