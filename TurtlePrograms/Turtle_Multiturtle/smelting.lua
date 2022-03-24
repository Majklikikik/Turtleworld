function smeltSingleTurtleMaxOneStack(itemname, itemcount)

    if itemcount>64 then
        log("Error, smeltSingleTurtleMaxOneStack called with more than one stack! That should not have happened...")
        error("Too many items")
    end
    setRecipe(itemname, itemcount)
    local wanted=copyTable(recipes_itemsNeeded)
    wanted["minecraft:coal"]=itemcount / 8
    local dropItemName
    for i,j in pairs(recipes_itemsNeeded) do
        dropItemName = i
    end
    log("Smelting "..itemcount.." "..dropItemName.." to get "..itemname)
    getItems(wanted)
    navigateCoordinates(5, houseGroundLevel, 13)
    navigateCoordinates(5, houseGroundLevel + 1, 13)
    turn(directions["WEST"])
    selectItem("minecraft:coal")
    turtle.drop()
    move_up()
    move_forward()
    countInventory()
    selectItem(dropItemName)
    turtle.dropDown()
    move_back()
    move_down()
    move_down()
    move_forward()
    sleep(itemcount*10)
    turtle.suckUp()
    navigate(basespots_chestBase)
    turn(directions["NORTH"])
end