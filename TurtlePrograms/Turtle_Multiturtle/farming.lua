function readFarmingProgressFile()
    local h = fs.open("farmingProgress.michi", "r")
    if h == nil then return {} end
    local ret = textutils.unserialize(h.readAll())
    h.close()
    return ret
end

function writeFarmingProgressFile(table)
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
    if h == nil then return {} end
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
    log("Arrived at Chunk.")
    logPos()
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
    checkTree(collectingSaplings)
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
    while move_down(false) do end
    moveOverGround()
    checkTree(collectingSaplings)
    return gotSomething
end

function checkTree(collectingSaplings)
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
        a,b = turtle.inspectUp()
        if a and isTreePart(b) then
            moveOverGround(1,false)
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

            or block.name=="myrtrees:rubberwood_log"
            or block.name=="myrtrees:filled_rubberwood_log"
            or block.name=="myrtrees:rubberwood_leaves"
end

--collects all Blocks from the blockList within this chunk
-- returns : Array, where ret[name]= false means that all items with that name got gathered
-- elseweise the value is nil
function gatherBlocksFromSurfaceInChunk(chunkNum, blockList, airBlockToIgnore, collectAllList)
    if airBlockToIgnore == nil then airBlockToIgnore = 3 end
    if collectAllList == nil then collectAllList = {} end

    blockList = copyTable(blockList)
    --log(blockList)
    goFromHouseLeavingPointToChunk(chunkNum)
    turn(directions["NORTH"])
    checkBlock(blockList, airBlockToIgnore, collectAllList)
    for i=1,8 do
        for i=1,15 do
            moveAndCheckBlock(blockList, airBlockToIgnore, collectAllList)
        end
        turn_right()
        moveAndCheckBlock(blockList, airBlockToIgnore, collectAllList)
        turn_right()
        for i=1,15 do
            moveAndCheckBlock(blockList, airBlockToIgnore, collectAllList)
        end
        if i~=8 then
            turn_left()
            moveAndCheckBlock(blockList, airBlockToIgnore, collectAllList)
            turn_left()
        end
    end
    --if collectingSaplings then turn_right() collectSaplings() end

    -- if something is still in the list, all of that name got farmed, so there is no more of it in this chunk
    local ret = {}
    for i,_ in pairs(blockList) do
        ret[i] = false
    end
    return ret
end

function moveAndCheckBlock(blockList, airBlockToIgnore, collectAllList)
    moveOverGround()
    checkBlock(blockList, airBlockToIgnore, collectAllList)
end


function checkBlock(blockList, airBlockToIgnore, collectAllList)
    for i=1,airBlockToIgnore do
        moveOverGround(1,false)
    end
    for i=1,airBlockToIgnore do
        move_down(false)
    end
    local c,d = turtle.inspectDown()
    if c and d.name == "minecraft:grass_block" then
        d.name = "minecraft:dirt"
        --log("Grass found")
    end
    --log(blockList)
    while c and has_key(blockList, d.name) do
        --log("Found Something!")
        blockList[d.name]=blockList[d.name]-1
        if blockList[d.name] <= 0 and collectAllList[d.name]==nil then blockList[d.name] = nil end
        move_down()
        c,d = turtle.inspectDown()
        if c and d.name == "minecraft:grass_block" then d.name = "minecraft:dirt" end
    end
end