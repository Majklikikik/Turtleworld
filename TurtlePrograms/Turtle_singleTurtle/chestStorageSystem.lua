chests={} --contains all information about the count of chests and their content
totalItemCounts={} -- total item counts over all chests
itemsWanted={} -- itemsWanted[itemname]=count
function writeChestFile()
	--saves the chests table to file
	log(" Writing Chest File ")
	local h=fs.open("chests.michi","w")
	h.write(textutils.serialize(chests))
	h.close()
end

function readChestFile()
	--read the chests table from file
	local h=fs.open("chests.michi","r")
	chests=textutils.unserialize(h.readAll())
	h.close()
end

function setupChests()
	--sets up a "empty" chests table
	chests={}
	chests["count"]=0
	chests["pos"]=0
	chests["rot"]=0
end

function addChestToData()
	--adds a chest to the table
	chests["count"]=chests["count"]+1
	chests[chests["count"]]={}
	chests[chests["count"]]["stackCount"]=0 --count of stacks of items in the chest
	chests[chests["count"]]["items"]={}
end

--a few methods for moving arount and saving the position in order to be able to go back to the start
function chestMovement_moveForward()
	while not turtle.up() do
		turtle.attackUp()
		turtle.digUp()
	end
	chests["pos"]=chests["pos"]+1
end

function chestMovement_moveBackwards()
	while not turtle.down() do
		--turtle.turnLeft()
		--turtle.turnLeft()
		--turtle.attack()
		--turtle.dig()
		--turtle.turnLeft()
		--turtle.turnLeft()
		turtle.digDown()
		turtle.attackDown()
	end
	chests["pos"]=chests["pos"]-1
end

function chestMovement_turnLeft()
	turtle.turnLeft()
	chests["rot"]=chests["rot"]-1
end

function chestMovement_turnRight()
	turtle.turnRight()
	chests["rot"]=chests["rot"]+1
end

function gotoChest(index)
	while chests["pos"]<index/4 do
		chestMovement_moveForward()
	end
	while chests["pos"]>(index+3)/4 do
		chestMovement_moveBackwards()
	end

	local lr=(index-1)%4
	local k=(lr-chests["rot"]+8)%4
	if k==3 then chestMovement_turnLeft()
	else
		while k>0 do
			chestMovement_turnRight()
			k=k-1
		end
	end
	--obvious
	--while chests["rot"]<0 do
	--	turnRight()
	--end
	--while chests["rot"]>0 do
	--	turnLeft()
	--end
end

function gotoStart()
	--return to the start
	chests.rot = chests.rot % 4
	if chests["rot"]==3 then chests["rot"]=-1 end
	if chests["rot"]==-3 then chests["rot"]=1 end
	while chests["rot"]<0 do
		chestMovement_turnRight()
	end
	while chests["rot"]>0 do
		chestMovement_turnLeft()
	end
	while chests["pos"]>0	do
		chestMovement_moveBackwards()
	end
end

function start()
	-- read chests file
	if fs.exists("Chests.michi") then
		readChestFile()
	else
		setupChests()
	end
end

function inventur()
	log("Stocktaking!")
	--turtle should have empty inventory when using this methods
	--counts chests, checks their content, saves all info to file
	local i=1
	setupChests()
	while true do
		gotoChest(i)
		turtle.select(1)
		local suc, dat=turtle.inspect()
		if suc and dat.name=="minecraft:chest" then
			addChestToData()
			for _=1,8 do turtle.suck() end
			for j=1,8 do
				turtle.select(j)
				local d=turtle.getItemDetail()
				if d~=nil then
					chests[i].items[j]=d
					turtle.drop()
					chests[i].stackCount=j
				end
			end
			i=i+1
		else
			gotoStart()
			writeChestFile()
			log("Have Items:")
			log(getTotalItemCounts())
			return
		end
	end
end

function storeRest()
	countInventory()
	--log("Dropping rest in Chests")
	--stores everything, which is not needed for the recipe, in chests
	itemsDesignatedForChest={} --itemsDesignatedForChest[3]=List of items, which should be put in Chest 3
	itemsToStoreInAnyChest={} -- list of Items which can be put anywhere. itemsToStore[i]= j means j items from slot i can be put anywhere

	local tmp=copyTable(itemsWanted)-- List of items which should be kept
	--check, in which chests to put which items
	local minChestIndexForPossibleTarget = {}
	for i,_ in pairs(inventory_inv) do
		minChestIndexForPossibleTarget[i]=1
	end
	for i=1,16 do
		local it= inventory_items[i]
		if it~=nil then
			local putCount=it.count
			if tmp[it["name"]]~=nil then
				putCount=math.max(putCount-tmp[it["name"]],0)
				if putCount~=0 then
					tmp[it["name"]]=tmp[it["name"]]-putCount
					if tmp[it["name"]]==0 then
						tmp[it["name"]]=nil
					end
				end
			end
			--log("Looking for PLace for "..putCount.." items")
			while putCount~=0 do
				-- look for a chest to put "it" in
				local target=findChestFor(it.name,putCount, minChestIndexForPossibleTarget[it.name])
				--log("Target is: ")
				--log(target)
				--log("PutCount: "..putCount)
				if target==nil then
					itemsToStoreInAnyChest[i]=putCount
					putCount = 0
				else
					if itemsDesignatedForChest[target.chestIndex]==nil then
						itemsDesignatedForChest[target.chestIndex]={}
					end
					itemsDesignatedForChest[target.chestIndex][i]=target.count
					putCount = putCount - target.count
					minChestIndexForPossibleTarget[it.name] = target.chestIndex + 1
				end
			end
		end
	end


	--go from one chest to the next and store the items there
	for i=1,chests.count do
		if chests[i]["stackCount"]<8 and tableSize(itemsToStoreInAnyChest)~=0 or itemsDesignatedForChest[i]~=nil then
			gotoChest(i)
			if itemsDesignatedForChest[i]~=nil then
				for j in pairs(itemsDesignatedForChest[i]) do
					--log("Putting designated items to chest ",i)
					turtle.select(j)
					turtle.drop(itemsDesignatedForChest[i][j])
					addItemToChest(i, inventory_items[j].name,itemsDesignatedForChest[i][j])
					itemsDesignatedForChest[i][j]=nil
				end
			end
			for j in pairs(itemsToStoreInAnyChest) do
				if chests[i]["stackCount"]<8 then
					--log("Putting undesignated items to chest",i)
					turtle.select(j)
					turtle.drop(itemsToStoreInAnyChest[j])
					addItemToChest(i, inventory_items[j].name,itemsToStoreInAnyChest[j])
					itemsToStoreInAnyChest[j]=nil
				else
					break
				end
			end
		end
	end
	--return to start and save changes
	gotoStart()
	writeChestFile()
end

function getItems(itemList)
	log("Getting: ")
	log(itemList)
	dropInventory()
	itemsWanted = itemList
	getmissing()
end

function getItemsOneType(itemname, count)
	dropInventory()
	if count==0 then return end
	--log("Getting "..count.." of "..itemname.." from chests")
	countAndSortInventory()
	for i,_ in pairs(itemsWanted) do
		itemsWanted[i]=nil
	end
	if inventory_inv[itemname]==nil then
		itemsWanted[itemname]=count
	else
		itemsWanted[itemname]=count--   +inventory_inv[itemname]
	end
	getmissing()
end

function getmissing()
	--log("Getting missing items!")
	countAndSortInventory()
	local tmp={} -- List of items needed for crafting, local copy
	for i,_ in pairs(itemsWanted) do
		--log("Item Wanted: "..i.." count "..itemsWanted[i])
		tmp[i]=itemsWanted[i]
		if inventory_inv[i]~=nil then
			tmp[i]=tmp[i]- inventory_inv[i]
			if tmp[i]==0 then
				tmp[i]=nil
			end
		end
	end



	--check, in which chests the searched items are
	local toGet={}-- toGet[i][j]= count of items to take from chest i, slot j
	for i = chests["count"], 1, -1 do
		toGet[i]={}
		for j=8,1,-1 do
			if chests[i].items[j]~=nil then
				local c=tmp[chests[i].items[j].name]
				if c~=nil then
					toGet[i][j]=math.min(c,chests[i].items[j].count)
					tmp[chests[i].items[j].name]=math.max(0,c-chests[i].items[j].count)
					if tmp[chests[i].items[j].name] == 0 then tmp[chests[i].items[j].name] = nil end
				end
			end
		end
		if tableSize(toGet[i])==0 then
			toGet[i]=nil
		end
		if tableSize(tmp)==0 then
			break
		end
	end


	if not isEmpty(tmp) then
		log("Error, couldnt get everything. Couldnt get:")
		log(tmp)
		error("Not everything needed was in Chests")
	end


	--get the items

	for i =  1,chests.count  do
		--if a searched item is in chest i go there
		if toGet[i]~=nil then
			--log("Getting from chest "..i)
			--log(toGet[i],"from "..i)
			gotoChest(i)
			turtle.select(1)
			-- take all items
			for _=1,8 do turtle.suck() end
			-- a second counter is needed, as it could happen, that the turtle keeps all items from slot 3, therefore the items from the 4th slot move to the 3rd, the ones from the 5th to the 4th and so on0
			local ind=1
			for j=1,8 do
				--if the j-th item is nil, then we are already done
				if chests[i].items[j]==nil then
					break
				end
				turtle.select(j)
				--if toGet[i][j] is nil, then put everything back, else keep some items
				if toGet[i][j]==nil then
					chests[i].items[ind]=chests[i].items[j]
					turtle.drop()
					ind=ind+1
				else
					--in case of equality, keep all items and therefore don't change anything
					-- elsewise return the rest
					if chests[i].items[j].count~=toGet[i][j] then
						chests[i].items[ind]=chests[i].items[j]
						local dropCount=chests[i].items[j].count-toGet[i][j]
						--log("Dropcount: "..dropCount)
						turtle.drop(dropCount)
						local it={}
						it.name=chests[i].items[j].name
						it.count=dropCount
						chests[i].items[ind]=it
						ind=ind+1
					end
				end
			end
			for j=ind,chests[i].stackCount do
				chests[i].items[j]=nil
			end
			chests[i].stackCount=ind-1
			countAndSortInventory()
		end
	end
	gotoStart()
	--print_table(chests)
	writeChestFile()
end

function addItemToChest(chest,name,count)
	for i=1,8 do
		local t=chests[chest].items[i]
		if t==nil then
			chests[chest].stackCount=chests[chest].stackCount+1
			chests[chest].items[i]={name=name,count=count}
			return true
		else
			if chests[chest].items[i].name==name and chests[chest].items[i].count<getStackSize(name) then
				if chests[chest].items[i].count + count > getStackSize(name) then
					count = count + chests[chest].items[i].count - getStackSize(name)
					chests[chest].items[i].count = getStackSize(name)
				else
					chests[chest].items[i].count=chests[chest].items[i].count+count
					return true
				end
			end
		end
	end
	log("Couldn't find where to put "..count.." "..name.." in chest"..chest)
	return false
end

function findChestFor(item,Count, minChestIndexForPossibleTarget)
	for i=minChestIndexForPossibleTarget,chests["count"] do
		for j=1,chests[i]["stackCount"] do
			if chests[i]["items"][j]~=nil and chests[i]["items"][j]["name"]==item then
				if chests[i]["items"][j]["count"]<getStackSize(item) then
					--log("Stacksize: "..getStackSize(item)..", itemCount: "..chests[i]["items"][j]["count"]..", Count: "..Count)
					return {chestIndex=i, count=math.min(Count, getStackSize(item)-chests[i]["items"][j]["count"])}
				end
			end
		end
	end
	return nil
end

function getItemsFor( itemname, count )
	local totalItemCounts = getTotalItemCounts()
	log("Getting items from chests: for "..itemname.." x "..count)
	count=count or 1
	setRecipe(itemname, count)
	countInventory()
	--check Which items are needed
	for i,_ in pairs(itemsWanted) do
		itemsWanted[i]=nil
	end
	log(recipes_itemsNeeded)
	for i,_ in pairs(recipes_itemsNeeded) do
		if i==woodsName then
			local tmp= recipes_itemsNeeded[i]
			for _,k in pairs(woods) do
				if (tmp>0 and totalItemCounts[k]~=nil and totalItemCounts[k]>0) then
					log("tmp: "..tmp.." Total: "..totalItemCounts[k])
					itemsWanted[k]=math.min(totalItemCounts[k],tmp)
					tmp=tmp-itemsWanted[k]
				end
			end
		elseif i==planksName then
			local tmp= recipes_itemsNeeded[i]
			for _,k in pairs(planks) do
				if (tmp>0 and totalItemCounts[k]~=nil and totalItemCounts[k]>0) then
					log("tmp: "..tmp.." Total: "..totalItemCounts[k])
					itemsWanted[k]=math.min(totalItemCounts[k],tmp)
					tmp=tmp-itemsWanted[k]
				end
			end
		else
			itemsWanted[i]= recipes_itemsNeeded[i]
		end
	end
	log(itemsWanted)
	--store the rest in chests
	storeRest()
	--get the missing items
	getmissing()
end

function getTotalItemCounts()
	local totalItemCounts = {}
	--log("Summing up inventory and Chests")
	countInventory()
	--log("Counting in inventory")
	--count from inventory
	for i,_ in pairs(inventory_inv) do
		--log(i)
		--log(items[i])
		totalItemCounts[i]= inventory_inv[i]
	end
	--log("Counting in chests")
	--count from chests
	for i = 1,(chests["count"]) do
		for j in pairs(chests[i].items) do
			local ct=chests[i].items[j]
			if totalItemCounts[ct.name]==nil then
				totalItemCounts[ct.name]=ct.count
			else
				totalItemCounts[ct.name]=totalItemCounts[ct.name]+ct.count
			end
		end
	end

	totalItemCounts[woodsName]=0
	totalItemCounts[planksName]=0
	for _,j in pairs(woods) do
		if totalItemCounts[j]~= nil then
			totalItemCounts[woodsName] = totalItemCounts[woodsName] + totalItemCounts[j]
		end
	end
	for _,j in pairs(planks) do
		if totalItemCounts[j]~= nil then
			totalItemCounts[planksName] = totalItemCounts[planksName] + totalItemCounts[j]
		end
	end
	return totalItemCounts
end

function maximumItemCountAvailable(itemname, mindReservations)
	local totalItemCounts = getTotalItemCounts()
	mindReservations = mindReservations or false
	if totalItemCounts[itemname]==nil then return 0 end
	if not mindReservations or reserved[itemname]==nil then return totalItemCounts[itemname] end
	return totalItemCounts[itemname]-reserved[itemname]
end

function itemsAreAvailable(itemname, count)
	local totalItemCounts = getTotalItemCounts()
	if totalItemCounts[itemname]==nil
	then
		log(count.." of "..itemname.." wanted, have none")
		return false
	else
		log(count.." of "..itemname.." wanted, have "..totalItemCounts[itemname])
		return  totalItemCounts[itemname]>=count
	end
end

function dropInventory()
	log("Dropping Inventory")
	for k,_ in pairs(itemsWanted) do
		itemsWanted[k]=nil
	end
	storeRest()
end

function countTotalWood()
	local totCount = getTotalItemCounts()
	if totCount[woodsName] == nil then return 0	end
	return totCount[woodsName]
end