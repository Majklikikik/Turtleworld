require("itemstacksizesAndMaxCounts")
inventory_inv ={} --inv[itemname], contains count
inventory_items ={} --array of itemdetails
inventory_slot ={} --slot[itemname] tells in which slot <itemname> is
-- if multiple slots contain[itemname], returns the last one

inventory_mined = {}

function resetInv()
	for i,_ in pairs(inventory_inv) do
		inventory_inv[i]=nil
	end
	for i,_ in pairs(inventory_slot) do
		inventory_slot[i]=nil
	end
	for i,_ in pairs(inventory_items) do
		inventory_items[i]=nil
	end
end

function countInventory()
	--inv={}
	resetInv()
	for i=1,16 do
		local det=turtle.getItemDetail(i)
		inventory_items[i]=turtle.getItemDetail(i)
		if det~=nil then
			--log(det)
			if inventory_inv[det.name]==nil
			then
				inventory_inv[det.name]=det.count
				inventory_slot[det.name]=i
			else
				inventory_inv[det.name]= inventory_inv[det.name]+det.count
				inventory_slot[det.name]=i
			end
		end
	end
	log("Counted inventory!")
end

function printInventoryNames()
	log("Printing Inventory Names")
	for i=1,16 do
		turtle.select(i)
		if (turtle.getItemDetail()~=nil)
		then
			log(turtle.getItemDetail().name)
		end
	end
end


function mergeStacks()
	for i=16,1,-1 do
		if inventory_items[i]~=nil then
			local itemDet= inventory_items[i]
			for j=i,16 do
				if inventory_items[j]~=nil and inventory_items[j].name==itemDet.name then
					local toPut=math.min(getStackSize(itemDet.name)-inventory_items[j].count, itemDet.count)
					if toPut>0 then
						turtle.select(i)
						turtle.transferTo(j)
						inventory_items[j].count=inventory_items[j].count+toPut
						if toPut==itemDet.count then
							inventory_items[i]=nil
							break
						else
							inventory_items[i].count=inventory_items[i].count-toPut
						end
					end
				end
			end
		end
	end
end


--1) Move all Items to the last slots, keep the first slots empty
--2) Merge Stacks if possible
function countAndSortInventory()
	countInventory(false)
	mergeStacks()

	--items in the last slots, first slots empty

	local j=16
	while inventory_items[j]~=nil do
		j=j-1
	end
	for i=1,16 do
		if i>=j then
			return
		end
		if inventory_items[i]~=nil then
			turtle.select(i)
			turtle.transferTo(j)
			inventory_items[j]= inventory_items[i]
			inventory_items[i]=nil
			while inventory_items[j]~=nil do
				j=j-1
			end
		end
	end
end

function dropEverythinExcept(itemsToKeep)
	for i=1,16 do
		local id=turtle.getItemDetail(i)
		if id~=nil then
			c=id.count
			if itemsToKeep[id.name] == nil then
				turtle.select(i)
				turtle.drop()
			else
				dropCount=math.max(0,c-itemsToKeep[id.name])
				turtle.select(i)
				turtle.drop(dropCount)
				itemsToKeep[id.name]=itemsToKeep[id.name]-dropCount
			end
		end
	end
end


--similar to dropAbundantItems, but 
-- 1) Doesn't check Chests
-- 2) Takes only up to stackCount stacks of each item
function dropAbundantItemsNoChest(maxStacks)
	local doLog=false
	if maxStacks==nil then maxStacks = 2 end
	countAndSortInventory()
	local stackCounts={}
	local itemCounts={}
	local itemDet
	for i=16,1,-1 do
		itemDet=inventory_items[i]
		if itemDet~=nil then
			if doLog then log(itemDet.name) end
			if maxCountToKeep(itemDet.name)==0 then
				if doLog then log(1) end
				turtle.select(i) turtle.drop()
			else
				if stackCounts[itemDet.name]==nil then
					if doLog then log(2) end
					stackCounts[itemDet.name]=0
					itemCounts[itemDet.name]=0
				end
				if stackCounts[itemDet.name]>=maxStacks then
					if doLog then log(3) end
					turtle.select(i) turtle.drop()
				else
					stackCounts[itemDet.name]=stackCounts[itemDet.name]+1
					if itemCounts[itemDet.name]+itemDet.count > maxCountToKeep(itemDet.name) then
						if doLog then log(4) end
						local toTrash = itemCounts[itemDet.name] + itemDet.count - maxCountToKeep(itemDet.name)
						turtle.select(i)
						turtle.drop(toTrash)
						itemCounts[itemDet.name]=maxCountToKeep(itemDet.name)
					else
						itemCounts[itemDet.name] = itemCounts[itemDet.name] + itemDet.count
					end
				end
			end
		end
	end
end


function hasAll(itemsToCheck)
	countInventory()
	for i,j in pairs(itemsToCheck) do
		if inventory_inv[i]==nil or inventory_inv[i]<j then return false end
	end
	return true
end



function dropAbundantItems(withSorting)
	local totalItemCounts = getTotalItemCounts()
	if withSorting==nil then withSorting=true end
	local removed=false
	for i=1,16 do
		local id=turtle.getItemDetail(i)
		if id~=nil then
			local c=id.count
			local tot=totalItemCounts[id.name]
			if tot==nil then
				log("Something strange happened: DropAbundantItems says tot is nil")
			else
				dropCount=math.min(c,tot-maxCountToKeep(id.name))
				--log(i.."   "..dropCount)
				if dropCount>0 then
					removed=true
					turtle.select(i)
					turtle.drop(dropCount)
					totalItemCounts[id.name]=totalItemCounts[id.name]-dropCount
				end
			end

		end
	end
	if withSorting and removed then countAndSortInventory(true) end
end


function countLogs(mustBeSameTreeType)
	if mustBeSameTreeType == nil then mustBeSameTreeType = false end
	countInventory()
	local logs = 0
	if mustBeSameTreeType then
		logs = math.max(logs , countOf("minecraft:spruce_log"))
		logs = math.max(logs , countOf("minecraft:birch_log"))
		logs = math.max(logs , countOf("minecraft:oak_log"))
		logs = math.max(logs , countOf("minecraft:jungle_log"))
		logs = math.max(logs , countOf("minecraft:acacia_log"))
		logs = math.max(logs , countOf("minecraft:dark_oak_log"))
	else
		logs = logs + countOf("minecraft:spruce_log")
		logs = logs + countOf("minecraft:birch_log")
		logs = logs + countOf("minecraft:oak_log")
		logs = logs + countOf("minecraft:jungle_log")
		logs = logs + countOf("minecraft:acacia_log")
		logs = logs + countOf("minecraft:dark_oak_log")
	end
	return logs
end
function countOf(itemname)
	if inventory_inv[itemname]==nil then return 0	end
	return inventory_inv[itemname]
end

function saveExtraMined(item, quantity)
	done = false
	countInventory()
	dropAbundantItems()
	for i = 1,16 do
		local name = turtle.getItemDetail(i).name
		local count = turtle.getItemDetail(i).count
		if name == item and count >= quantity and not done then
			addToStored(name, quantity - count )
			done = true
		else
			addToStored(name, count)
		end
	end
end

function addToStored(item, quantity)
	if stored[item] == nil then
		stored[item] = quantity
	else
		stored[item] = stored[item] + quantity
	end
end

function checkMined(item, quantity)
	if Mined[item] ~= nil and Mined[item] >= quantity then
		Mined[item] = Mined[item] - quantity
		return true
	end
	return false
end