function lookInCurrentChunkForWood(woodCount, collectingSaplings)
    -- assume a spawn on the lower left (x and z minimal within the chunk)
    turn(directions["NORTH"])
    for i=1,8 do
        for i=1,15 do
            checkTreeAndMove()
        end
        turn_right()
        checkTreeAndMove()
        turn_right()
        for i=1,15 do
            checkTreeAndMove()
        end
        if i~=8 then
            turn_left()
            checkTreeAndMove()
            turn_left()
        end
    end
    if collectingSaplings then turn_right() collectSaplings() end
end

function collectSaplings()
    for i=1,8 do
        for i=1,15 do
            moveAndCollect()
        end
        turn_right()
        moveAndCollect()
        turn_right()
        for i=1,15 do
            moveAndCollect()
        end
        if j~=8 then
            turn_left()
            moveAndCollect()
            turn_left()
        end
    end
end



function checkTreeAndMove()
    while turtle.down() do end

    moveOverGround()
    local a,b=turtle.inspectDown()
    while a and isTreePart(b) do
        move_down()
        for i=1,4 do
            local c,d=turtle.inspect()
            if c and isTreePart(d) then
                turtle.dig()
            end
            turn_right()
        end
        a,b=turtle.inspectDown()
    end
end

function isTreePart(block)
    return block.name=="minecraft:birch_leaves"
            or block.name=="minecraft:spruce_leaves"
            or block.name=="minecraft:oak_leaves"
            or block.name=="minecraft:jungle_leaves"
            or block.name=="minecraft:acacia_leaves"
            or block.name=="minecraft:dark_oak_leaves"
            or block.name=="minecraft:birch_log"
            or block.name=="minecraft:spruce_log"
            or block.name=="minecraft:oak_log"
            or block.name=="minecraft:jungle_log"
            or block.name=="minecraft:acacia_log"
            or block.name=="minecraft:dark_oak_log"
end