function standardvalues_baseBuildingItems()
    local ret={}
    ret["minecraft:furnace"] = 12
    ret["computercraft:computer_normal"] = 1
    ret["computercraft:monitor_advanced"] = 12--8*6*2
    ret["computercraft:turtle_mining"] = 2
    ret["minecraft:redstone"]=10
    return ret
end

function standardvalues_TreeFarmBuildingItems()
    local ret ={}
    ret["minecraft:dirt"] = 36
    ret["minecraft:stone_bricks"] = 256-36
    return ret
end