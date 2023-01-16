require("req")
resetLog()
read_pos()
local answer = {}
local command
answer.type=answerTypes.NOTHING
answer.turtleName = os.getComputerLabel()
log(current_pos)
log(basespots_queue)
loadHouseGroundLevel()
while true do
    while current_pos.y>basespots_queue.y do move_down() write_pos() end
    if current_pos.z<basespots_queue.z then
        turn(directions.NORTH)
        move_forward()
        write_pos()
    end
    comm_sendMessage(textutils.serialize(compressMessage(answer)))
    command = uncompressMessage(textutils.unserialize(comm_getMessage()))
    answer = processCommand(command)
end