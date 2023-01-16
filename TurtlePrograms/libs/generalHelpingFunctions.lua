require("logger")

actionTypes = {}
actionTypes["CRAFTING"] = "crafting" --0
actionTypes["MACHINE_USING"] = "machine" --1
actionTypes["MINING"] = "mining" --2
actionTypes["GATHERING"] = "gathering" --3
actionTypes["FARMING"] = "farming" --4
actionTypes["EXECUTING"] = "executing" --5 --executing a function, for example a build - function
actionTypes["REQUEUE"] = "requeueing" -- 6

function tableSize(table)
    local i = 0
    for t in pairs(table) do
        i = i + 1
    end
    return i
end

function has_value(tab, val)
    tab = tab or {}
    for _, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function has_key(tab, key)
    tab = tab or {}
    for index, _ in pairs(tab) do
        if index == key then
            return true
        end
    end
    return false
end

function getStackTrace(depht, minus)
    s = debug.traceback()
    words = {}
    for w in s:gmatch("\n\t([^\n]*): ") do
        table.insert(words, w)
    end
    ret = ""
    for i = minus, (depht + minus) do
        --words[i]=words[i]:gsub("\n","")
        ret = ret .. "[" .. words[i] .. "]"
    end
    return ret
end

function spiralNumberToCoordinate(num)
    local a = spiralNumberToCoordinateArray(num)
    return vector.new(a[1], 0, a[2])
end

function spiralNumberToCoordinateArray(num)
    if num == 1 then
        return { 0, 0 }
    end
    i = 1
    while (2 * i - 1) * (2 * i - 1) < num do
        i = i + 1
    end
    num = num - (2 * i - 3) * (2 * i - 3)
    if (num < 2 * i) then
        return { i - 1, -i + num }
    elseif (num < 4 * i - 2) then
        return { 3 * i - 2 - num, i - 1 }
    elseif (num < 6 * i - 4) then
        return { 1 - i, 5 * i - 4 - num }
    elseif (num < 8 * i - 4) then
        return { -7 * i + 6 + (num), -i + 1 }
    end
end

function logNameOfBlockInFront()
    a, b = turtle.inspect()
    if a then log(b.name)
    else log(b)
    end
end

function moveAndCollect()
    while turtle.detect() do move_up() end
    turtle.suck()
    move_forward()
    repeat turtle.suckDown()
    until not move_down(false)
end

function multiplicate(table, multiplicator)
    local ret = {}
    for i, j in pairs(table) do
        ret[i] = j * multiplicator
    end
    return ret
end

function addValues(table1, table2)
    local ret = {}
    if table1 ~= nil then
        for i, j in pairs(table1) do
            ret[i] = j
        end
    end

    if table2 ~= nil then
        for i, j in pairs(table2) do
            if ret[i] == nil then
                ret[i] = j
            else
                ret[i] = ret[i] + j
            end
        end
    end
    return ret
end

function subtractValuesPositive(table1, table2)
    local ret = {}
    if table1 ~= nil then
        for i, j in pairs(table1) do
            ret[i] = j
        end
    end

    if table2 ~= nil then
        for i, j in pairs(table2) do
            if ret[i] ~= nil then
                ret[i] = math.max(ret[i] - j)
                if ret[i] <= 0 then ret[i] = nil end
            end
        end
    end
    return ret
end

function isEmpty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
end

function copyTable(table)
    local ret = {}
    for i, j in pairs(table) do
        if type(j) == "table" then
            ret[i] = copyTable(j)
        else
            ret[i] = j
        end
    end
    return ret
end

-- Returns true, if the first itemlist contains all items in the second itemlist
function containsEverythingFrom(table1, table2)
    for i, j in pairs(table2) do
        if table1[i] == nil then return false end
        if table1[i] < j then return false end
    end
    return true
end

-- Returns true, if the first itemlist contains all items in the second itemlist
function containsItems(table1, itemname, itemcount)
    if table1 == nil then
        log("Error, table is nil!")
        error("Table is nil")
    end
    if table1[itemname] == nil then return false end
    if table1[itemname] < itemcount then return false end
    return true
end

function concatenateTables(t1, t2)
    if t1 == nil then
        log("Error, table 1 is nil")
        error("Table nil")
    end
    if t2 == nil then
        log("Error, table 2 is nil")
        error("Table nil")
    end
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function compress(str)
    local str2 = str
    str2 = string.gsub(str2, "\t", " ")
    str2 = string.gsub(str2, "\n", " ")
    str2 = string.gsub(str2, " ", "")
    str2 = string.gsub(str2, "minecraft:", "mc:")
    str2 = string.gsub(str2, "computercraft:", "cc:")
    str2 = string.gsub(str2, "emendatusenigmatica:", "ee:")
    return str2
end

function uncompress(str)
    local str2 = str
    str2 = string.gsub(str2, "mc:", "minecraft:")
    str2 = string.gsub(str2, "cc:", "computercraft:")
    str2 = string.gsub(str2, "ee:", "emendatusenigmatica:")
    return str2
end

function compressMessage(msg)
    local ret = {}
    for i, _ in pairs(msg) do
        if (i == "turtleName") then
            ret["tn"] = string.gsub(msg[i], "Spartakus", "S")
        elseif (i == "itemsNeeded") then ret["iN"] = msg[i]
        elseif (i == "machine") then ret["mn"] = msg[i]
        elseif (i == "stepNum") then ret["sN"] = msg[i]
        elseif (i == "type") then
            if msg[i] == answerTypes.NOTHING then ret["t"] = "n"
            elseif msg[i] == answerTypes.ACTION_DONE then ret["t"] = "d"
            else ret["t"] = msg[i] end
        else ret[i] = msg[i]
        end
    end
    return ret
end

function uncompressMessage(msg)
    local ret = {}
    for i, _ in pairs(msg) do
        if (i == "tn") then
            ret["turtleName"] = string.gsub(msg[i], "S", "Spartakus")
        elseif (i == "iN") then ret["itemsNeeded"] = msg[i]
        elseif (i == "mn") then ret["machine"] = msg[i]
        elseif (i == "sN") then ret["stepNum"] = msg[i]
        elseif (i == "t") then
            if msg[i] == "n" then ret["type"] = answerTypes.NOTHING
            elseif msg[i] == "d" then ret["type"] = answerTypes.ACTION_DONE
            else ret["type"] = msg[i] end
        else ret[i] = msg[i]
        end
    end
    return ret
end
