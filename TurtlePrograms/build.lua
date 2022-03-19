require("movement")
require("chestStorageSystem")
-- requirement is, that there is a furnace in the storage system
function buildBaseFurnaces()
    log("Building Base Furnaces")
    craft("minecraft:furnace",12)
    getItemsOneType("minecraft:furnace",12)
    for i=1,12 do
        navigateCoordinates(4, houseGroundLevel, 14 - furnaceIndex)
        select("minecraft:furnace")
        turtle.placeUp()
    end
end


function buildBaseChests(count)
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
    dir =  ( (chests["count"] % 4) +1) % 4
    turn(dir)
    height = math.floor(chests["count"] / 4) + 1
    for _ = 1, height do
        move_up()
    end
    turtle.dig()
    select("minecraft:chest")
    turtle.place()
    addChestToData()
    for _ = 1, height do
        move_down()
    end
end

function select(itemid)
    for i = 1,16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == itemid then
            turtle.select(i)
            return
        end
    end
    error("Expected item: ".. itemid.." not in inventory")
end

function getYPos()
    for i=1,256 do
        turtle.up()
        turtle.digUp()
    end
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
    clearAbove(heightDelta)
    for x=1,(math.floor((boxX+1)/2)) do
        turn(directions["NORTH"])
        for _=1,boxZ do
            move_forward()
            clearAbove(heightDelta)
        end
        turn(directions["EAST"])
        move_forward()
        clearAbove(heightDelta)
        turn(directions["SOUTH"])
        for _=1,boxZ do
            move_forward()
            clearAbove(heightDelta)
        end
        if (2*x~=boxX+1) then
            turn(directions["EAST"])
            move_forward()
            clearAbove(heightDelta)
        end
    end
    if (boxX%2==0) then
        turn(directions["NORTH"])
        for _=1,boxZ do
            move_forward()
            clearAbove(heightDelta)
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