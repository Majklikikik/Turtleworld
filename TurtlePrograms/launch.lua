require("req")
--Initiate()
init_turtle({11,63,11,directions["NORTH"]})
--init_turtle()
log(current_dir)

--clear are for Chests
flattenRectangle(10, 10, 12, 12,houseGroundLevel,10)
--InitiateChests()

--clean the two house chunks from trees
--lookInChunkForWood(1,1024,true)
--lookInChunkForWood(3,1024,true)
--goFromOutsideToChestPoint()
--dropAbundantItems()
--dropInventory()


--flatten them
flattenRectangle(10, 13, 15, 15,nil,2)
flattenRectangle(13, 10, 15, 12,nil,2)
flattenRectangle(0,10,9,15,nil,2)
flattenRectangle(0,0,15,9,nil,2)
flattenRectangle(16,0,31,15,nil,2)
goFromOutsideToChestPoint()
dropAbundantItems()
dropInventory()