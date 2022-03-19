mining_minimalMiningHeight = 1
mining_maximalMiningHeight = 50

--mining progress: is the number of the last Tunnel already mined within the chunk
-- is 0, if the chunk wasn't touched yet, and -1, if the chunk got completely mined

function readMiningProgressFile()
    local h = fs.open("miningProgress.michi", "r")
    if h == nil then return {} end
    local ret = textutils.unserialize(h.readAll())
    h.close()
    return ret
end

function writeMiningProgressFile(table)
    local save = {}
    local h = fs.open("miningProgress.michi", "w")
    h.write(textutils.serialize(table))
    h.close()
end

function saveMiningProgress(chunkNum, tunnelNum)
    local tmp = readMiningProgressFile()
    tmp[chunkNum]=tunnelNum
    writeMiningProgressFile(tmp)
end

function loadMiningProgress(chunkNum)
    local tmp = readMiningProgressFile()
    if tmp[chunkNum]== nil then return 0 end
    return tmp[chunkNum]
end



--returns the z and y coordinates of the tunnelNum-th tunnel in Chunk number chunkNum
-- this Tunnel should get mined either from west to east or vice versa, depending on the parity of it's z coordinate
function getMiningTunnelStartPosition(chunkNum, tunnelNum)
    local startpos = spiralNumberToCoordinate(chunkNum)*16
    local counter = 0
    for y=mining_minimalMiningHeight, mining_maximalMiningHeight do
        for z  = startpos.z,(startpos.z+15) do
            local relPos=(2*y+z) % 5
            if relPos==0 or (relPos==3 and y==mining_minimalMiningHeight) then
                counter=counter+1
                if counter==tunnelNum then
                    if z%2==0 then
                        return vector.new(startpos.x, y, z)
                    else
                        return vector.new(startpos.x+15, y, z)
                    end

                end
            end
        end
    end
    return nil
end


function mineAndReturnToHouse(chunkNum, fromTunnel, maxTunnelCount, itemsToMine)
    local ret = mine(chunkNum, fromTunnel, maxTunnelCount, itemsToMine)
    goFromOutsideUndergroundToHouseEntryPoint()
    return ret
end

--turtle needs to be in a valid house leaving point
-- returns:
-- 1) the number of the last tunnel, if all items wanted got mined
-- 2) false, if maxTunnelCount tunnels got mined
-- 3) nil, if the Chunk got drained (no more Tunnels are possible)
function mine(chunkNum, fromTunnel, maxTunnelCount, itemsToMine)
    log("Mining Chunk "..chunkNum.." from Tunnel #"..fromTunnel.." , up to "..maxTunnelCount.." tunnels")
    goFromHouseLeavingPointToChunk(chunkNum, true)
    for i=fromTunnel,fromTunnel + maxTunnelCount -1 do
        --means the Chunk got completely mined
        if getMiningTunnelStartPosition(chunkNum, i)==nil then return nil end
        mineTunnel(chunkNum, i)
        dropAbundantItemsNoChest(2)
        if itemsToMine~=nil and hasAll(itemsToMine) then
            return i
        end
    end
    return false
end

function mineTunnel(chunkNum, tunnelNum)
    log("Mining Tunnel #"..tunnelNum.." in Chunk "..chunkNum)
    local tunnelPos = getMiningTunnelStartPosition(chunkNum, tunnelNum)
    navigate(tunnelPos)
    checkForResources()
    --dig the tunnel either to the west or to the east
    if current_pos.z%2==0 then
        for _=1,15 do
            turn(directions["EAST"])
            move_forward()
            checkForResources()
        end
    else
        for _=1,15 do
            turn(directions["WEST"])
            move_forward()
            checkForResources()
        end
    end
end


function checkForResources()
    dir = current_dir
    turn(directions["NORTH"])
    if isWantedItem(table.pack(turtle.inspect())[2].name) then
        turtle.dig()
    end
    turn(directions["SOUTH"])
    if isWantedItem(table.pack(turtle.inspect())[2].name) then
        turtle.dig()
    end
    if isWantedItem(table.pack(turtle.inspectUp())[2].name) then
        turtle.digUp()
    end
    if isWantedItem(table.pack(turtle.inspectDown())[2].name) then
        turtle.digDown()
    end
    turn(dir)
end

function isWantedItem(blockid)
    return     blockid == "minecraft:diamond_ore"
            or blockid == "minecraft:iron_ore"
            or blockid == "minecraft:coal_ore"
            or blockid == "minecraft:lapis_ore"
            or blockid == "minecraft:gold_ore"
            or blockid == "minecraft:redstone_ore"
            or blockid == "minecraft:deepslate_redstone_ore"
            or blockid == "minecraft:sand"
            or blockid == "emendatusenigmatica:iron_ore"
            or blockid == "emendatusenigmatica:redstone_ore"
            or blockid == "emendatusenigmatica:diamond_ore"
            or blockid == "emendatusenigmatica:coal_ore"
            or blockid == "emendatusenigmatica:lapis_ore"
            or blockid == "emendatusenigmatica:gold_ore"
            or blockid == "emendatusenigmatica:deepslate_redstone_ore"

end