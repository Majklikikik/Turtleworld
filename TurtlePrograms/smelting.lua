require("movement")
require("chestStorageSystem")
require("inventory")

function smeltSingleTurtle(itemname, itemcount)
    local wanted={}
    wanted[itemname]=itemcount
    wanted["minecraft:coal"]=itemcount/8
    getItems(wanted)
    navigateCoordinates(5, houseGroundLevel, 13)
    navigateCoordinates(5, houseGroundLevel + 1, 13)
    turn(directions["WEST"])
    if (fuelcount>0) then
        turtle.select(inventory_slot["minecraft:coal"])
        turtle.drop()
    end
    move_up()
    move_forward()
    countInventory()
    turtle.select(inventory_slot[itemname])
    turtle.dropDown()
    move_back()
    move_down()
    move_down()
    move_forward()
    sleep(itemcount*smeltingTime)
    turtle.suckUp()
    move_back()
    goFromOutsideToChestPoint()
end