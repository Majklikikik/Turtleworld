require("req")
resetLog()
read_pos()
local answer = {}
local command
answer.type=answerTypes.NOTHING
while true do
    while current_pos.y>basespots_queue.y do move_down() write_pos() end
    if current_pos.z<basespots_queue.z then
        turn(directions.NORTH)
        move_forward()
        write_pos()
    end
    comm_sendMessage(textutils.serialize(answer))
    command = textutils.unserialize(comm_getMessage())
    answer = processCommand(command)
end