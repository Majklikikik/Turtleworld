
--This class initializes a new turtle. If you want to resume the session of an existing turtle just make
--sure to call read_pos() before doing anythin else. Then it should work


function init_turtle(arg)

	if arg ~= nil and #arg == 4 then
		current_pos = vector.new(arg[1], arg[2], arg[3])
		current_dir = arg[4]
	else
		current_pos = vector.new(11, getYPos(),11)
		current_dir = directions["EAST"]
	end
	setHouseGroundLevel(current_pos.y)
	write_pos()
	setupChests()
	writeChestFile()
end



