--[[Useful Functions:

]]--

function initiateRecipes()
    initiateCraftingRecipes()
    initiateSmeltingRecipes()
    setEnigmatusEnigmatica()
    log("Recipes initiated!")
end

function initiateCraftingRecipes()
    initiateMinecraftCraftingRecipes()
    initiateComputercraftCraftingRecipes()
end


function setEnigmatusEnigmatica()
    recipe_recipes["minecraft:iron_ingot"]["rec"] = { { { "emendatusenigmatica:iron_chunk"} } }
    recipe_recipes["minecraft:gold_ingot"]["rec"] = { { { "emendatusenigmatica:gold_chunk"} } }
end

function initiateComputercraftCraftingRecipes()
    recipe_recipes["computercraft:computer_normal"]={}
    recipe_recipes["computercraft:computer_normal"]["machine"] = 0
    recipe_recipes["computercraft:computer_normal"]["rec"] = { { { "minecraft:stone"}, { "minecraft:stone"}, { "minecraft:stone"}}, { { "minecraft:stone"}, { "minecraft:redstone"}, { "minecraft:stone" }}, { { "minecraft:stone"}, { "minecraft:glass_pane"}, { "minecraft:stone"}}}
    recipe_recipes["computercraft:computer_normal"]["maxCount"] =9
    recipe_recipes["computercraft:computer_normal"]["outputMult"] = 1

    recipe_recipes["computercraft:turtle_normal"]={}
    recipe_recipes["computercraft:turtle_normal"]["machine"] = 0
    recipe_recipes["computercraft:turtle_normal"]["rec"] = { { { "minecraft:iron_ingot"}, { "minecraft:iron_ingot"}, { "minecraft:iron_ingot"}}, { { "minecraft:iron_ingot"}, { "computercraft:computer_normal"}, { "minecraft:iron_ingot" }}, { { "minecraft:iron_ingot"}, { "minecraft:chest"}, { "minecraft:iron_ingot"}}}
    recipe_recipes["computercraft:turtle_normal"]["maxCount"] =9
    recipe_recipes["computercraft:turtle_normal"]["outputMult"] = 1

    recipe_recipes["computercraft:turtle_mining"]={}
    recipe_recipes["computercraft:turtle_mining"]["machine"] = 0
    recipe_recipes["computercraft:turtle_mining"]["rec"] = { {}, { { "minecraft:diamond_pickaxe"}, { "computercraft:turtle_normal"}}, {}}
    recipe_recipes["computercraft:turtle_mining"]["maxCount"] =1
    recipe_recipes["computercraft:turtle_mining"]["outputMult"] = 1

    recipe_recipes["computercraft:turtle_mining_crafty"]={}
    recipe_recipes["computercraft:turtle_mining_crafty"]["machine"] = 0
    recipe_recipes["computercraft:turtle_mining_crafty"]["rec"] = { { }, { nil , { "computercraft:turtle_normal"}, { "minecraft:crafting_bench"} }, { }}
    recipe_recipes["computercraft:turtle_mining_crafty"]["maxCount"] =64
    recipe_recipes["computercraft:turtle_mining_crafty"]["outputMult"] = 1

    recipe_recipes["computercraft:monitor_advanced"]={}
    recipe_recipes["computercraft:monitor_advanced"]["machine"] = 0
    recipe_recipes["computercraft:monitor_advanced"]["rec"] = { { { "minecraft:gold_ingot"}, { "minecraft:gold_ingot"}, { "minecraft:gold_ingot"}} , { { "minecraft:gold_ingot"}, { "minecraft:gold_ingot"}, { "minecraft:glass_pane"}} , { { "minecraft:gold_ingot"}, { "minecraft:gold_ingot"}, { "minecraft:gold_ingot"}}}
    recipe_recipes["computercraft:monitor_advanced"]["maxCount"] = 32
    recipe_recipes["computercraft:monitor_advanced"]["outputMult"] = 4

    recipe_recipes["computercraft:disk"]={}
    recipe_recipes["computercraft:disk"]["machine"] = 0
    recipe_recipes["computercraft:disk"]["rec"] = { { {"minecraft:redstone"}, { "minecraft:paper"}} , { { "minecraft:blue_dye"}} , {}}
    recipe_recipes["computercraft:disk"]["maxCount"] = 1
    recipe_recipes["computercraft:disk"]["outputMult"] = 1

    recipe_recipes["computercraft:disk_drive"]={}
    recipe_recipes["computercraft:disk_drive"]["machine"] = 0
    recipe_recipes["computercraft:disk_drive"]["rec"] = { { { "minecraft:stone"}, { "minecraft:stone"}, { "minecraft:stone"}}, { { "minecraft:stone"}, { "minecraft:redstone"}, { "minecraft:stone" }}, { { "minecraft:stone"}, { "minecraft:redstone"}, { "minecraft:stone"}}}
    recipe_recipes["computercraft:disk_drive"]["maxCount"] = 9
    recipe_recipes["computercraft:disk_drive"]["outputMult"] = 1
end

function initiateMinecraftCraftingRecipes()
    recipe_recipes["minecraft:diamond_pickaxe"]={}
    recipe_recipes["minecraft:diamond_pickaxe"]["machine"] = 0
    recipe_recipes["minecraft:diamond_pickaxe"]["rec"] ={ { { "minecraft:diamond"}, { "minecraft:diamond"}, { "minecraft:diamond"}}, { nil, { "minecraft:stick"}, nil}, { nil, { "minecraft:stick"}, nil}}
    recipe_recipes["minecraft:diamond_pickaxe"]["maxCount"] =16
    recipe_recipes["minecraft:diamond_pickaxe"]["outputMult"] = 1

    recipe_recipes["minecraft:chest"]={}
    recipe_recipes["minecraft:chest"]["machine"] = 0
    recipe_recipes["minecraft:chest"]["rec"] ={ { planks, planks, planks}, { planks, nil, planks}, { planks, planks, planks}}
    recipe_recipes["minecraft:chest"]["maxCount"] =1
    recipe_recipes["minecraft:chest"]["outputMult"] = 1

    recipe_recipes[planksName]={}
    recipe_recipes[planksName]["machine"] = 0
    recipe_recipes[planksName]["rec"] ={ { nil, nil, nil}, { nil, woods, nil }, { nil, nil, nil}}
    recipe_recipes[planksName]["maxCount"] =4
    recipe_recipes[planksName]["outputMult"] = 4

    recipe_recipes["minecraft:startChest"]={}
    recipe_recipes["minecraft:startChest"]["machine"] = 0
    recipe_recipes["minecraft:startChest"]["rec"] = { { planks, planks, planks}, { planks, nil, planks}, { planks, planks, planks}}
    recipe_recipes["minecraft:startChest"]["maxCount"] =8
    recipe_recipes["minecraft:startChest"]["outputMult"] = 1

    recipe_recipes["minecraft:startPlanks"]={}
    recipe_recipes["minecraft:startPlanks"]["machine"] = 0
    recipe_recipes["minecraft:startPlanks"]["rec"] ={ { nil, nil, nil}, { nil, woods, nil }, { nil, nil, nil}}
    recipe_recipes["minecraft:startPlanks"]["maxCount"] =256
    recipe_recipes["minecraft:startPlanks"]["outputMult"] = 4

    recipe_recipes["minecraft:glass_pane"]={}
    recipe_recipes["minecraft:glass_pane"]["machine"] = 0
    recipe_recipes["minecraft:glass_pane"]["rec"] = { { { "minecraft:glass"}, { "minecraft:glass"}, { "minecraft:glass"}}, { { "minecraft:glass"}, { "minecraft:glass"}, { "minecraft:glass"}}, { nil, nil, nil}}
    recipe_recipes["minecraft:glass_pane"]["maxCount"] =160
    recipe_recipes["minecraft:glass_pane"]["outputMult"] = 16

    recipe_recipes["minecraft:stick"]={}
    recipe_recipes["minecraft:stick"]["machine"] = 0
    recipe_recipes["minecraft:stick"]["rec"] = { { nil, planks, nil}, { nil, planks, nil}, { nil, nil, nil}}
    recipe_recipes["minecraft:stick"]["maxCount"] = 4
    recipe_recipes["minecraft:stick"]["outputMult"] = 4

    recipe_recipes["minecraft:furnace"]={}
    recipe_recipes["minecraft:furnace"]["machine"] = 0
    recipe_recipes["minecraft:furnace"]["rec"] = { { { "minecraft:cobblestone"}, { "minecraft:cobblestone"}, { "minecraft:cobblestone"}}, { { "minecraft:cobblestone"}, nil, { "minecraft:cobblestone"}}, { { "minecraft:cobblestone"}, { "minecraft:cobblestone"}, { "minecraft:cobblestone"}}}
    recipe_recipes["minecraft:furnace"]["maxCount"] =8
    recipe_recipes["minecraft:furnace"]["outputMult"] = 1

    recipe_recipes["minecraft:crafting_bench"]={}
    recipe_recipes["minecraft:crafting_bench"]["machine"] = 0
    recipe_recipes["minecraft:crafting_bench"]["rec"] = { { nil, nil, nil}, { planks, planks, nil}, { planks, planks, nil}}
    recipe_recipes["minecraft:crafting_bench"]["maxCount"] = 64
    recipe_recipes["minecraft:crafting_bench"]["outputMult"] = 1

    recipe_recipes["minecraft:stone_bricks"]={}
    recipe_recipes["minecraft:stone_bricks"]["machine"] = 0
    recipe_recipes["minecraft:stone_bricks"]["rec"] = { {  { "minecraft:stone"}, { "minecraft:stone"},  nil}, {  { "minecraft:stone"}, { "minecraft:stone"} , nil}, { nil, nil, nil}}
    recipe_recipes["minecraft:stone_bricks"]["maxCount"] = 64
    recipe_recipes["minecraft:stone_bricks"]["outputMult"] = 4

    recipe_recipes["minecraft:paper"]={}
    recipe_recipes["minecraft:paper"]["machine"] = 0
    recipe_recipes["minecraft:paper"]["rec"] = { {}, {{ "minecraft:sugar_cane"}, { "minecraft:sugar_cane"}, { "minecraft:sugar_cane"}}, {} }
    recipe_recipes["minecraft:paper"]["maxCount"] = 63
    recipe_recipes["minecraft:paper"]["outputMult"] = 3

    recipe_recipes["minecraft:blue_dye"]={}
    recipe_recipes["minecraft:blue_dye"]["machine"] = 0
    recipe_recipes["minecraft:blue_dye"]["rec"] = { {}, {{ "minecraft:lapis_lazuli"}}, {} }
    recipe_recipes["minecraft:blue_dye"]["maxCount"] = 64
    recipe_recipes["minecraft:blue_dye"]["outputMult"] = 1

    recipe_recipes["minecraft:bucket"]={}
    recipe_recipes["minecraft:bucket"]["machine"] = 0
    recipe_recipes["minecraft:bucket"]["rec"] = { {}, {{ "minecraft:iron_ingot"}, nil,{ "minecraft:iron_ingot"} }, {nil, { "minecraft:iron_ingot"}} }
    recipe_recipes["minecraft:bucket"]["maxCount"] = 16
    recipe_recipes["minecraft:bucket"]["outputMult"] = 1

    recipe_recipes["minecraft:lever"]={}
    recipe_recipes["minecraft:lever"]["machine"] = 0
    recipe_recipes["minecraft:lever"]["rec"] = { {{ "minecraft:stick"}}, {{ "minecraft:cobblestone"}}, {} }
    recipe_recipes["minecraft:lever"]["maxCount"] = 64
    recipe_recipes["minecraft:lever"]["outputMult"] = 1

end

function initiateSmeltingRecipes()
    recipe_recipes["minecraft:stone"]={}
    recipe_recipes["minecraft:stone"]["machine"] = 1
    recipe_recipes["minecraft:stone"]["rec"] = { { { "minecraft:cobblestone"} } }
    recipe_recipes["minecraft:stone"]["maxCount"] =64

    recipe_recipes["minecraft:iron_ingot"]={}
    recipe_recipes["minecraft:iron_ingot"]["machine"] = 1
    recipe_recipes["minecraft:iron_ingot"]["rec"] = { { { "minecraft:iron_ore"} } }
    recipe_recipes["minecraft:iron_ingot"]["maxCount"] =64

    recipe_recipes["minecraft:glass"]={}
    recipe_recipes["minecraft:glass"]["machine"] = 1
    recipe_recipes["minecraft:glass"]["rec"] = { { { "minecraft:sand"} } }
    recipe_recipes["minecraft:glass"]["maxCount"] =64

    recipe_recipes["minecraft:gold_ingot"]={}
    recipe_recipes["minecraft:gold_ingot"]["machine"] = 1
    recipe_recipes["minecraft:gold_ingot"]["rec"] = { { { "minecraft:gold_ore"} } }
    recipe_recipes["minecraft:gold_ingot"]["maxCount"] =64
end