mining_minimalMiningHeight = 1
mining_maximalMiningHeight = 60
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

--turtle needs to be in a valid house leaving point
-- returns:
-- 1) true, if all items wanted got mined
-- 2) false, if maxTunnelCount tunnels got mined
-- 3) nil, if the Chunk got drained (no more Tunnels are possible)
function mine(chunkNum, fromTunnel, maxTunnelCount, itemsToMine)
    goFromHouseLeavingPointToChunk(chunkNum)
    for i=fromTunnel,fromTunnel + maxTunnelCount do
        --means the Chunk got completely mined
        if getMiningTunnelStartPosition(chunkNum, i)==nil then return nil end
        mineTunnel(chunkNum, tunnelNum)
        dropAbundantItemsNoChest(2)
        if itemsToMine~=nil and hasAll(itemsToMine) then
            return true
        end
    end
    return false
end

function mineTunnel(chunkNum, tunnelNum)
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
    turn(directions["NORTH"])
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