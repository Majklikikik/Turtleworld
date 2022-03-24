function moveFromPCToChestQueue()

end

function moveFromChestsToPCQueue()

end

function moveFromOutsideToChestQueue()

end

function moveFromChestQueueToFurnace(furnaceIndex)

end

function moveFromFurnacesToChestQueue()

end

function moveFromChestBaseSpotToFurnace(furnaceIndex)
    navigateCoordinates(9, houseGroundLevel, 11)
    navigateCoordinates(6, houseGroundLevel, 13)
    navigateCoordinates(5, houseGroundLevel + 1, 14 - furnaceIndex)
end
