
function getStackSize(name)
	if name=="minecraft:bucket" then return 16 end
	if name=="minecraft:sign" then return 3 end
	if name=="computercraft:disk" then return 1 end
	if name=="miencraft:diamond_pickaxe" then return 1 end

	--log("Itemstacksizes: Unknown item: "..name)
	return 64
end

function getFuelValue(name)

end

function maxCountToKeep(name)

	--stuff from the surface

	if name=="minecraft:cobblestone" then return 1024 end
	if name=="minecraft:sand" then return 1024 end
	if name=="minecraft:dirt" then return 1024 end
	if name=="minecraft:spruce_log" then return 1024 end
	if name=="minecraft:birch_log" then return 1024 end
	if name=="minecraft:oak_log" then return 1024 end
	if name=="minecraft:jungle_log" then return 1024 end
	if name=="minecraft:acacia_log" then return 1024 end
	if name=="minecraft:dark_oak_log" then return 1024 end
	if name=="minecraft:spruce_sapling" then return 64 end
	if name=="minecraft:birch_sapling" then return 64 end
	if name=="minecraft:oak_sapling" then return 64 end
	if name=="minecraft:jungle_sapling" then return 64 end
	if name=="minecraft:acacia_sapling" then return 64 end
	if name=="minecraft:dark_oak_sapling" then return 64 end
	if name=="minecraft:sugar_cane" then return 256 end

	if name=="myrtrees:rubberwood_log" then return 1024 end
	if name=="myrtrees:rubberwood_sapling" then return 64 end


	--stuff from mining
	if name=="minecraft:coal" then return 1024 end
	if name=="minecraft:iron_ore" then return 1024 end
	if name=="minecraft:diamond" then return 1024 end
	if name=="minecraft:redstone" then return 1024 end
	if name=="minecraft:gold_ore" then return 1024 end
	if name=="minecraft:lapis_lazuli" then return 1024 end
	if name=="minecraft:emerald" then return 1024 end
	if name=="emendatusenigmatica:iron_chunk" then return 1024 end
	if name=="emendatusenigmatica:gold_chunk" then return 1024 end
	if name=="minecraft:stone_bricks" then return 1024 end

	return 0;
end