function standardvalues_baseBuildingItems()
    local ret={}
    --ret["computercraft:monitor_advanced"] = 12--8*6*2 Needs too much gold, put it in first base expansion instead
    ret["computercraft:turtle_normal"] = 2
    ret["computercraft:disk"] = 1
    ret["computercraft:disk_drive"] = 1
    ret["minecraft:diamond_pickaxe"] = ret["computercraft:turtle_normal"]
    ret["minecraft:stone_bricks"]=1
    ret["minecraft:lever"] = 1
    ret["minecraft:coal"] = 8
    return ret
end

function standardvalues_sugarCaneFarmAndFurnaces()
    local ret ={}
    ret["minecraft:dirt"] = 32
    ret["minecraft:bucket"] = 2
    ret["minecraft:furnace"] = 12
    ret["minecraft:sugar_cane"] = 1
    return ret
end

function standardvalues_baseScreenExpansion()

end

function standardvalues_TreeFarmBuildingItems()
    local ret ={}
    ret["minecraft:dirt"] = 36
    ret["minecraft:stone_bricks"] = 256-36
    return ret
end