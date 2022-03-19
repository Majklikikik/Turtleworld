function readFarmingProgressFile()
    local h = fs.open("farmingProgress.michi", "r")
    local ret = textutils.unserialize(h.readAll())
    h.close()
    return ret
end

function writeFarmingProgressFile(table)
    local save = {}
    local h = fs.open("farmingProgress.michi", "w")
    h.write(textutils.serialize(table))
    h.close()
end

function saveFarmingProgress(chunkNum, mayContainTrees)
    local tmp = readFarmingProgressFile()
    tmp[chunkNum]=mayContainTrees
    writeFarmingProgressFile(tmp)
end

function loadFarmingProgress(chunkNum)
    local tmp = readFarmingProgressFile()
    if tmp[chunkNum]== nil then return true end
    return tmp[chunkNum]
end

function readGatheringProgressFile()
    local h = fs.open("gatheringProgress.michi", "r")
    local ret = textutils.unserialize(h.readAll())
    h.close()
    return ret
end

function writeGatheringProgressFile(table)
    local save = {}
    local h = fs.open("gatheringProgress.michi", "w")
    h.write(textutils.serialize(table))
    h.close()
end

function saveGatheringProgress(chunkNum, blockName, result)
    local tmp = readGatheringProgressFile()
    if tmp[chunkNum] == nil then tmp[chunkNum] = {} end
    tmp[chunkNum][blockName]=result
    writeGatheringProgressFile(tmp)
end

function loadGatheringProgress(chunkNum, blockName)
    local tmp = readGatheringProgressFile()
    if tmp[chunkNum]== nil or tmp[chunkNum][blockName] == nil then return true end
    return tmp[chunkNum][blockName]
end



-- Return Values:
-- True: Got all Wood, chunk not Cleared
-- False: Chunk cleared, didn't get all Wood
function lookInChunkForWood(chunkNum,woodCount, collectingSaplings, mustBeSameTreeType)
    log("Farming Wood in Chunk "..chunkNum)
    goFromHouseLeavingPointToChunk(chunkNum)
    return lookInCurrentChunkForWood(woodCount, collectingSaplings, mustBeSameTreeType)
end

-- Return Values:
-- True: Got all Wood, chunk not Cleared
-- False: Chunk cleared, didn't get all Wood
function lookInCurrentChunkForWood(woodCount, collectingSaplings, mustBeSameTreeType)
    -- return values: true - got all Wood, Chunk not Cleared
    -- false - Chunk cleared, searching
    if woodCount == nil then woodCount =256 end
    if collectingSaplings == nil then collectingSaplings = false end
    if mustBeSameTreeType == nil then mustBeSameTreeType = false end
    -- assume a spawn on the lower left (x and z minimal within the chunk)
    turn(directions["NORTH"])
    for i=1,8 do
        for i=1,15 do
            if collectingSaplings then turtle.suck() end
            if checkTreeAndMove(collectingSaplings) then
                if countLogs(mustBeSameTreeType) >= woodCount then return true end
            end
        end
        turn_right()
        if collectingSaplings then turtle.suck() end
        if checkTreeAndMove(collectingSaplings) then
            if countLogs(mustBeSameTreeType) >= woodCount then return true end
        end
        turn_right()
        for i=1,15 do
            if collectingSaplings then turtle.suck() end
            if checkTreeAndMove(collectingSaplings) then
                if countLogs(mustBeSameTreeType) >= woodCount then return true end
            end
        end
        if i~=8 then
            turn_left()
            if collectingSaplings then turtle.suck() end
            if checkTreeAndMove(collectingSaplings) then
                if countLogs(mustBeSameTreeType) >= woodCount then return true end
            end
            turn_left()
        end
    end
    --if collectingSaplings then turn_right() collectSaplings() end
    return false
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

function clearTreeBlock()
    local c,d=turtle.inspect()
    if c and isTreePart(d) then
        move_forward()
        for i=1,4 do
            turn_right()
            clearTreeBlock()
        end
        move_back()
    end
    c,d=turtle.inspectUp()
    if c and isTreePart(d) then
        move_up()
        clearTreeBlock()
        move_down()
    end
end

function checkTreeAndMove(collectingSaplings)
    while turtle.down() do end
    moveOverGround()
    local a,b=turtle.inspectDown()
    local gotSomething = false
    while a and isTreePart(b) do
        gotSomething = true
        move_down()
        if collectingSaplings then
            for i=1,4 do
                clearTreeBlock()
                turn_right()
            end
        else
            for i=1,4 do
                local c,d=turtle.inspect()
                if c and isTreePart(d) then
                    turtle.dig()
                end
                turn_right()
            end
        end
        a,b=turtle.inspectDown()
    end
    return gotSomething
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

            or block.name=="myrtrees:rubberwood_log"
            or block.name=="myrtrees:filled_rubberwood_log"
            or block.name=="myrtrees:rubberwood_leaves"
end

-- Return Values:
-- True: Got all Blocks, chunk not Cleared
-- False: Chunk cleared, didn't get all Blocks
function gatherBlockFromSurfaceInChunk(chunkNum, blockName, count)
    goFromHouseLeavingPointToChunk(chunkNum)
    turn(directions["NORTH"])
    for i=1,8 do
        for i=1,15 do
            if moveAndCheckBlock(blockname) then return true end
        end
        turn_right()
        if moveAndCheckBlock(blockname) then return true end
        turn_right()
        for i=1,15 do
            if moveAndCheckBlock(blockname) then return true end
        end
        if i~=8 then
            turn_left()
            if moveAndCheckBlock(blockname) then return true end
            turn_left()
        end
    end
    --if collectingSaplings then turn_right() collectSaplings() end
    return false
end

function moveAndCheckBlock(blockname)
    moveOverGround()
    local c,d = turtle.inspectDown()
    while c and d.name==blockName do
        move_down()
    end
    countInventory()
    if inventory_inv[blockName]~=nil and inventory_inv[blockname] >= count then return true end
    return false
end