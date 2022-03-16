function gather_wood(quantity, startup)
    startup = startup or false
    local h = fs.open("./gathering.txt", "r")
    local spiral = textutils.unserialize(h.readAll())
    h.close()


    while not gather_ring(quantity, spiral, startup) do
    end

    local w = fs.open("gathering.txt", "w")
    w.write(textutils.serialize(spiral))
    w.close()
end