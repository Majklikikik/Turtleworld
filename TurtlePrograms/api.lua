require("farming")
require("movement")
require("build")
require("smelting")
require("init")
require("logger")
require("crafting")

-- shall be called by the planner at the start once
-- args[0] = x, args[1] = y, args[2] = z, args[3] = direction. If args are empty, default values are used
function Initiate(args)
    init_turtle(args)
    turn(directions["EAST"])
    setupChests()
    writeChestFile()
end

function InitiateChests()
    goal = {}
    goal["log"] = 6
    gather_wood(goal, true)

    navigate(home)
    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil then
            local name = turtle.getItemDetail(i).name
            local quantity = turtle.getItemDetail(i).count

            local has_wood = false
            if not is_wood(name) or has_wood or (is_wood(name) and quantity < 6 ) then
                turtle.select(i)
                turtle.drop()
            elseif is_wood(name) and quantity >= 6 and not has_wood then
                --drop till 6quantity
                turtle.select(i)
                turtle.drop(quantity - 6)
                has_wood = true
            end
        end
    end

    craft("minecraft:startPlanks", 24) -- Fails if more than 6 logs are in inventory
    craft("minecraft:startChest", 3)

    for _ = 1, 3 do
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
    turn(directions["EAST"])
end

-- Requirement: Chest in Inventory
-- Reward: Storage System yay
function PlaceChest()

    itemsWanted["minecraft:chest"] = 1
    getmissing()
    build_chest()
    go_towards(home)
    turn(directions["EAST"])
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


