recipe_rec ={ 6, 6, 6}
recipe_count =1
recipe_outputMult = 1
recipe_inputMult = 1
woods={"minecraft:oak_log","minecraft:spruce_log","minecraft:birch_log","minecraft:jungle_log","minecraft:acacia_log","minecraft:dark_oak_log","minecraft:crimson_log","minecraft:warped_log"}
planks={"minecraft:oak_planks","minecraft:spruce_planks","minecraft:birch_planks","minecraft:jungle_planks","minecraft:acacia_planks","minecraft:dark_oak_planks","minecraft:crimson_planks","minecraft:warped_planks"}
woodsName="mixed:woods"
planksName="mixed:planks"
recipe_name =""
recipes_itemsNeeded ={} --itemsNeeded[<name>]=count of item <name> needed
recipe_maxCount =64 -- how many items of the current recipe can maximally be crafted (for example: 16 diamond pickaxes, as there is not space for 17 in turtle inventory)
-- but only 10 doors, as 11 need more than 1 stack of planks
recipe_machine = nil
--Machines: 0 - Craft by Hand
--			1 - Furnace

recipe_recipes={}

function craftIndexToInvIndex(y,x)
	return 4*(y-1)+x
end

function arrangeInventoryToRecipe()
	--Arranges the inventory to the shape of the recipe
	countInventory()
	log("Arranging Inventory to craft ".. recipe_count .." times.")
	verbose=true
	for i=1,16 do
		if inventory_items[i]~=nil then
			turtle.select(i)
			for y=1,3 do
				for x=1,3 do
					if turtle.getItemDetail()~=nil and has_value(recipe_rec[y][x],turtle.getItemDetail().name) then
						if verbose then
							log("Moving "..(recipe_count / recipe_outputMult).." items from slot"..i.." to slot "..craftIndexToInvIndex(y,x))
						end
						turtle.transferTo(craftIndexToInvIndex(y,x), recipe_count / recipe_outputMult)
					end
				end
			end
		end
	end
end

function setRecipe(id,c)
	log("Setting recipe for "..id)
	recipe_count =c or 1
	recipe_name =id
	if recipe_recipes[id] == nil then
		log("Recipe not found!")
		return false;
	end
	recipe_machine=recipe_recipes[id]["machine"]
	recipe_rec = recipe_recipes[id]["rec"]
	recipe_maxCount = recipe_recipes[id]["maxCount"]
	recipe_outputMult = recipe_recipes[id]["outputMult"]
	recipe_inputMult = recipe_recipes[id]["inputMult"]
	recalculateItemsNeeded()
	return true
end

function recalculateItemsNeeded()
	for i,_ in pairs(recipes_itemsNeeded) do
		recipes_itemsNeeded[i]=nil
	end
	local c=math.ceil(recipe_count / recipe_outputMult)
	for _,i in pairs(recipe_rec) do
		for _,j in pairs(i) do
			if j~=nil then

				index=""
				if	(j==woods)
				then
					index=woodsName
				elseif (j==planks)
				then
					index=planksName
				else
					index= j[1]
				end
				if recipes_itemsNeeded[index]==nil then
					recipes_itemsNeeded[index]=c*recipe_inputMult
				else
					recipes_itemsNeeded[index]= recipes_itemsNeeded[index]+c*recipe_inputMult
				end

			end
		end
	end
	if recipe_count > recipe_maxCount then
		log("Warning: Recipe set for ".. recipe_count .." of ".. recipe_name ..", but maximum craftable in 1 batch is ".. recipe_maxCount .."!")
	end
end