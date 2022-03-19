require("req")

-- Initiation, clearing of the first two houseChunks of Trees, Flattening of the first two houseChunks
function initiateAndFlatten()
    init_turtle()
    --clear area for Chests
    flattenRectangle(10, 10, 12, 12,houseGroundLevel,10)
    initiateChests()

    --clean the two house chunks from trees
    lookInChunkForWood(1,nil,true)
    lookInChunkForWood(2,nil,true)
    lookInChunkForWood(3, nil,true)
    goFromOutsideToChestPoint()
    dropAbundantItems()
    dropInventory()


    --flatten them
    flattenRectangle(10, 13, 15, 15,nil,2)
    flattenRectangle(13, 10, 15, 12,nil,2)
    flattenRectangle(0,10,9,15,nil,2)
    flattenRectangle(0,0,15,9,nil,2)
    flattenRectangle(16,0,31,15,nil,2)
    goFromOutsideToChestPoint()
    dropAbundantItems()
    dropInventory()
end

function singleTurtleMineResources(toMine, maxTunnel)
    local i = 1
    local miningResult = nil
    while miningResult== nil or miningResult == false do
        log("Mining, now in Chunk #"..i)
        miningResult = mine(i, 1, maxTunnel, toMine)
        if miningResult == nil then
            saveMiningProgress(i, -1)
        elseif miningResult == false then
            saveMiningProgress(i, maxTunnel)
            log("Dug all Tunnels")
        else
            saveMiningProgress(i, miningResult)
        end
        goFromOutsideToChestPoint()
        dropAbundantItems()
        countInventory()
        toMine = subtractValuesPositive(toMine, inventory_inv)
        dropInventory()
        log(os.clock())
        i = i+1
    end
end

function singleTurtleFarmWood(woodCount)
    if woodCount == nil or woodCount == 0  then return end
    local i = 1
    local farmingResult = false
    while farmingResult == false do
        log("Searching trees, now in Chunk #"..i)
        farmingResult = lookInChunkForWood(i,nil,true)
        if farmingResult == false then
            saveFarmingProgress(i, false)
        end
        goFromOutsideToChestPoint()
        dropAbundantItems()
        dropInventory()
        log(os.clock())
        i = i+1
        if countTotalWood() >= woodCount then farmingResult = true end
    end
end


function singleTurtleGatherResource(blockName, blockCount)
    if blockCount == nil or woodCount == 0  then return end
    local i = 1
    local gatheringResult = false
    while gatheringResult == false do
        log("Searching "..blockname..", now in Chunk #"..i)
        gatheringResult = gatherBlockFromSurfaceInChunk(i,blocKName,blockCount)
        if gatheringResult == false then
            saveGatheringProgress(i, blockName, false)
        end
        goFromOutsideToChestPoint()
        dropAbundantItems()
        dropInventory()
        log(os.clock())
        i = i+1
        if countTotalWood() >= woodCount then farmingResult = true end
    end
end

init_turtle({11,63,11,directions["NORTH"]})
inventur()

local chestCosts = resourceCosts("minecraft:chest",20-chests["count"], getTotalItemCounts())
log("Farming Wood to get a total of 20 Turtles!")
log(chestCosts)
singleTurtleFarmWood(chestCosts[woodsName])
buildBaseChests(20-chests["count"])




local baseCosts = resourceCostsList(standardvalues_baseBuildingItems())
log("Needed items to build base:")
log(baseCosts)
local toMine = mineableResources(baseCosts)
log("From these: the Following are mineable")
log(toMine)
log("Going to mine them")
singleTurtleMineResources(toMine, 60)
log("Building Furnaces!")
buildBaseFurnaces()