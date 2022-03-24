require("movement")
require("chestStorageSystem")




--builds a communication Spot
--targetPos is the lower left corner, dir is the directions
--if dir == NORTH, then targetPos will be at the southwestern corner of the communication spot
function cleanCommunicationSpot(targetPos, dir)
    navigate(targetPos)
    turn(dir)
    move_down()
    for i=1,3 do
        turtle.digDown()
        move_forward()
    end
    turtle.digDown()
    turn_right()
    move_forward()
    turn_right()
    turtle.digDown()
    for i=1,3 do
        move_forward()
        turtle.digDown()
    end
    turn_left()
    move_forward()
    turn_left()
    turtle.digDown()
    for i=1,3 do
        move_forward()
        turtle.digDown()
    end
    navigate(targetPos)
end

function buildCommunicationSpot(targetPos, dir)
    navigate(targetPos)
    turn(dir)
    move_down()
    selectItem("minecraft:stone_bricks")
    turn_right()
    move_forward()
    turtle.placeDown()
    move_back()
    turn_right()
    for _=1,3 do
        turtle.placeDown()
        move_back()
    end
    turn_right()
    for _=1,2 do
        turtle.placeDown()
        move_back()
    end
    turn_right()
    turtle.placeDown()
    move_back()
    turtle.placeDown()
    move_up()
    turn_right()
    move_back()
    turtle.placeDown()
    turn_right()
    move_forward()
    turtle.placeDown()
    turn_left()
    move_forward()
    turn_right()
    turtle.placeDown()
    turtle.placeUp()
    move_forward()
    turtle.placeDown()
    turtle.placeUp()


    turn_right()
    selectItem("minecraft:redstone")
    for _=1,2 do
        move_forward()
        turtle.placeDown()
    end
    turn_right()
    for _=1,3 do
        move_forward()
        turtle.placeDown()
    end
    turn_right()
    for _=1,2 do
        move_forward()
        turtle.placeDown()
    end
    turn_right()
    move_forward()
    turtle.placeDown()
    turn_right()
    move_forward()
    turn_left()
    move_forward()
    turn_left()
    for _=1,3 do
        move_up()
    end
    move_forward()
    turn_right()
    turtle.placeDown()
    move_forward()
    turtle.placeDown()

    turn_right()
    move_forward()
    navigate(targetPos)
end




-- requirement is, that there is a furnace in the storage system
function buildBaseFurnaces()
    log("Building Base Furnaces")
    craft("minecraft:furnace",12)
    getItemsOneType("minecraft:furnace",12)
    navigateCoordinates(3, houseGroundLevel, 13)
    for i=1,12 do
        navigateCoordinates(3, houseGroundLevel+1, 14 - i)
        selectItem("minecraft:furnace")
        turn(directions["EAST"])
        turtle.place()
    end
end

function buildSugarcaneFarm()
    log("Building Sugarcane Farm!")
    log("Digging Hole for Sugarcane Farm")
    --Dig Hole
    navigateCoordinates(18, houseGroundLevel, 12)
    turn(directions["EAST"])
    turtle.digDown()
    move_forward()
    move_down()
    for i=1, 10 do
        turn(directions["SOUTH"])
        turtle.dig()
        turn(directions["NORTH"])
        turtle.dig()
        turn(directions["EAST"])
        turtle.digDown()
        move_forward()
    end

    log("Fetching Dirt for Sugarcane Farm")
    --get Dirt
    navigate(basespots_chestBase)
    turn(directions["NORTH"])
    dropAbundantItemsNoChest()
    dropInventory()
    getItemsOneType("minecraft:dirt", 32)

    log("Placing Dirt for Sugarcane Farm")
    --place Dirt
    navigateCoordinates(18, houseGroundLevel, 12)
    turn(directions["EAST"])
    selectItem("minecraft:dirt")
    turtle.placeDown()
    move_forward()
    move_down()
    for i=1, 10 do
        turn(directions["SOUTH"])
        turtle.place()
        turn(directions["NORTH"])
        turtle.place()
        turn(directions["EAST"])
        turtle.placeDown()
        move_forward()
    end
    move_back()
    turtle.place()

    navigate(basespots_chestBase)
    turn(directions["NORTH"])
    log("Looking for bucket!")
    if getTotalItemCounts()["minecraft:bucket"] == nil or getTotalItemCounts()["minecraft:bucket"] < 2 then
        log("Crafting Bucket")
        craftRecursivelyUsingMachinesSingleTurtle("minecraft:bucket",2,getTotalItemCounts())
    else
        log("Already have a Bucket, fetching it it")
        getItemsOneType("minecraft:bucket",2)
    end
    log("Collecting Water")
    singleTurtleFindWater()
    log("Found Water. Going to fill Water for Sugarcane Farm")
    navigateCoordinates(18, houseGroundLevel, 12)
    turn(directions["EAST"])
    selectItem("minecraft:water_bucket")
    move_forward()
    turtle.placeDown()
    selectItem("minecraft:water_bucket")
    for i = 1,4 do
        move_forward()
        move_forward()
        turtle.placeDown()
        move_back()
        turtle.placeDown()
        move_forward()
    end
    move_forward()
    turtle.placeDown()

    log("Water placed. Going to get Sugarcane and place it")
    navigate(basespots_chestBase)
    turn(directions["NORTH"])
    dropInventory()
    getItemsOneType("minecraft:sugar_cane",getTotalItemCounts()["minecraft:sugar_cane"])

    log("Going to Place Sugarcane")
    navigateCoordinates(18,houseGroundLevel, 11)
    turn(directions["EAST"])
    move_up()
    selectItem("minecraft:sugar_cane")
    for i=1,10 do
        move_forward()
        turtle.placeDown()
    end
    move_forward()
    turn_left()
    move_forward()
    turtle.placeDown()
    move_forward()
    turn_left()
    for i=1,10 do
        move_forward()
        turtle.placeDown()
    end
    move_forward()
    turn_left()
    move_forward()
    turtle.placeDown()
    move_forward()
    navigate(basespots_chestBase)
    turn(directions["NORTH"])
    log("Sugarcane Farm Finished!!!")
    addFarm("minecraft:sugar_cane")
end

function addFarm(name)
    resourcesMineable[name] = nil
    resourcesGatherable[name] = nil
    resourcesFarmable[name] = true
end

function buildBaseChests(count)
    if count == 0 then
        log("Already have enough Chests")
        return
    end
    log("Building "..count.." chests!")
    craftRecursivelyUsingMachinesSingleTurtle("minecraft:chest",count, getTotalItemCounts())
    dropInventory()
    getItemsOneType("minecraft:chest",count)
    for i=1,count do
        build_chest()
    end
end

-- requirement is, that there is a chest in the storage system
function build_chest()
    dir = chests["count"] % 4
    turn(dir)
    height = math.floor(chests["count"] / 4) + 1
    for _ = 1, height do
        move_up()
    end
    turtle.dig()
    selectItem("minecraft:chest")
    turtle.place()
    addChestToData()
    for _ = 1, height do
        move_down()
    end
end

function selectItem(itemid)
    countInventory()
    for i = 1,16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == itemid then
            turtle.select(i)
            return
        end
    end
    error("Expected item: ".. itemid.." not in inventory")
end

function getYPos()
    while turtle.digUp() or turtle.up() do end
    local height=255
    while not turtle.detectDown() do
        turtle.down()
        height=height-1
    end
    return height
end



--Flattens the Rectangle, by digging away all blocks over height
--heightDelta specifies, how many air blocks the turtle will get up, in order to get Trees / stuff in the air
-- both the from and the to coordinates are inclusive
function flattenRectangle(fromX, fromZ, toX, toZ, height, heightDelta)
    if height == nil then height = houseGroundLevel end
    if heightDelta== nil then heightDelta = 5 end
    local boxX=toX-fromX
    local boxZ=toZ-fromZ
    navigateCoordinates(fromX,height,fromZ)
    while current_pos.y < height do moveOverGround(1, false) end
    clearAbove(heightDelta)
    for x=1,(math.floor((boxX+1)/2)) do
        turn(directions["NORTH"])
        for _=1,boxZ do
            moveOverGround(nil, false)
            while current_pos.y < height do moveOverGround(1, false) end
            clearAbove(heightDelta)
            while current_pos.y > height do move_down() end
        end
        turn(directions["EAST"])
        moveOverGround(nil, false)
        while current_pos.y < height do moveOverGround(1, false) end
        clearAbove(heightDelta)
        while current_pos.y > height do move_down() end
        turn(directions["SOUTH"])
        for _=1,boxZ do
            moveOverGround(nil, false)
            while current_pos.y < height do moveOverGround(1, false) end
            clearAbove(heightDelta)
            while current_pos.y > height do move_down() end
        end
        if (2*x~=boxX+1) then
            turn(directions["EAST"])
            moveOverGround(nil, false)
            while current_pos.y < height do moveOverGround(1, false) end
            clearAbove(heightDelta)
            while current_pos.y > height do move_down() end
        end
    end
    if (boxX%2==0) then
        turn(directions["NORTH"])
        for _=1,boxZ do
            moveOverGround(nil, false)
            while current_pos.y < height do moveOverGround(1, false) end
            clearAbove(heightDelta)
            while current_pos.y > height do move_down() end
        end
    end
end

function clearAbove(airBlocksIgnored)
    local c=0
    local targetY=current_pos.y
    while c<airBlocksIgnored do
        local a,b=turtle.inspectUp()
        if a and notTurtleName(b)then
            c=0
        else
            c=c+1
        end
        move_up()
    end
    while current_pos.y>targetY do move_down(false) end
end


function clearBox(fromX, fromY, fromZ, toX, toY, toZ)
    navigateCoordinates(fromX,fromY,fromZ)
    local boxX=toX-fromX
    local boxY=toY-fromY
    local boxZ=toZ-fromZ

    for x=1,(boxX-(boxX%2)-1) do
        turn(directions["NORTH"])
        for _=1,(boxZ-1) do
            move_forward()
        end
        turn(directions["EAST"])
        move_forward()
        turn(directions["SOUTH"])
        for _=1,(boxZ-1) do
            move_forward()
        end
        if (2*x~=boxX) then
            turn(directions["EAST"])
            move_forward()
        end
    end
    if (boxX%2==1) then
        turn(directions["NORTH"])
        for _=1,(boxZ-1) do
            move_forward()
        end
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
