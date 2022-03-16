require("itemstacksizesAndMaxCounts")
inventory_inv ={} --inv[itemname], contains count
inventory_items ={} --array of itemdetails
inventory_slot ={} --slot[itemname] tells in which slot <itemname> is

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
		det=turtle.getItemDetail(i)
		inventory_items[i]=det
		if det~=nil then
			--log(det)
			if inventory_inv[det.name]==nil
			then
				inventory_inv[det.name]=det.count
				inventory_slot[det.name]=i
			else
				before= inventory_inv[det.name]
				toPut=math.min(getStackSize(det.name)-before, det.count)
				inventory_inv[det.name]= inventory_inv[det.name]+det.count
				turtle.select(i)
				turtle.transferTo(inventory_slot[det.name])
				inventory_items[inventory_slot[det.name]].count= inventory_items[inventory_slot[det.name]].count+toPut
				inventory_items[i]=turtle.getItemDetail()
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

function sortInventory(reverse)
	if reverse==nil then reverse = false end
	--items in the last slots, first slots empty
	countInventory()
	local j=16
	while inventory_items[j]~=nil do
		j=j-1
	end
	for i=1,16 do
		if i>=j then
			return
		end

		l=j
		k=i
		if reverse then k=17-i end
		if reverse then l=17-j end

		if inventory_items[k]~=nil then
			turtle.select(k)
			turtle.transferTo(l)
			inventory_items[l]= inventory_items[k]
			inventory_items[k]=nil
			while inventory_items[l]~=nil do
				l=l-1
			end
		end
	end
	countInventory()
end

function dropEverythinExcept(itemsToKeep)
	for i=1,16 do
		id=turtle.getItemDetail(i)
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

function dropAbundantItems(withSorting)
	if withSorting==nil then withSorting=true end
	removed=false
	sumInventoryAndAllChests()
	for i=1,16 do
		id=turtle.getItemDetail(i)
		if id~=nil then
			c=id.count
			tot=totalItemCounts[id.name]
			if tot==nil then
				log("Something strange happened: DropAbundantItems says tot is nil")
			else
				dropCount=math.min(c,tot-maxCountToKeep(id.name))
				log(i.."   "..dropCount)
				if dropCount>0 then
					removed=true
					turtle.select(i)
					turtle.drop(dropCount)
					totalItemCounts[id.name]=totalItemCounts[id.name]-dropCount
				end
			end

		end
	end
	if withSorting and removed then sortInventory(true) end
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
		name = turtle.getItemDetail(i).name
		count = turtle.getItemDetail(i).count
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