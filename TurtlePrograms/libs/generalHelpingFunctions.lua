require("logger")
function tableSize(table)
    local i=0
    for t in pairs(table) do
        i=i+1
    end
    return i
end

function has_value (tab, val)
    tab = tab or {}
    for _, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function has_key (tab, key)
    tab = tab or {}
    for index, _ in pairs(tab) do
        if index == key then
            return true
        end
    end
    return false
end


function getStackTrace(depht, minus)
    s=debug.traceback()
    words={}
    for w in s:gmatch("\n\t([^\n]*): ") do
        table.insert(words, w)
    end
    ret=""
    for i = minus,(depht+minus) do
        --words[i]=words[i]:gsub("\n","")
        ret=ret.."["..words[i].."]"
    end
    return ret
end

function spiralNumberToCoordinate(num)
    local a=spiralNumberToCoordinateArray(num)
    return vector.new(a[1],0,a[2])
end

function spiralNumberToCoordinateArray(num)
    if num==1 then
        return {0,0}
    end
    i=1
    while (2*i-1)*(2*i-1)<num do
        i=i+1
    end
    num=num-(2*i-3)*(2*i-3)
    if (num<2*i) then
        return {i-1, -i+num}
    elseif (num<4*i-2) then
        return {3*i-2-num,i-1}
    elseif (num<6*i-4)then
        return {1-i,5*i-4-num}
    elseif (num<8*i-4)then
        return {-7*i+6+(num),-i+1}
    end
end

function logNameOfBlockInFront()
    a,b=turtle.inspect()
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
    local ret={}
    for i,j in pairs(table) do
        ret[i]=j*multiplicator
    end
    return ret
end

function addValues(table1, table2)
    local ret={}
    if table1~=nil then
        for i,j in pairs(table1) do
            ret[i]=j
        end
    end

    if table2~=nil then
        for i,j in pairs(table2) do
            if ret[i]==nil then
                ret[i]=j
            else
                ret[i]=ret[i]+j
            end
        end
    end
    return ret
end

function subtractValuesPositive(table1, table2)
    local ret={}
    if table1~=nil then
        for i,j in pairs(table1) do
            ret[i]=j
        end
    end

    if table2~=nil then
        for i,j in pairs(table2) do
            if ret[i]~=nil then
                ret[i]=math.max(ret[i]-j)
                if ret[i]<=0 then ret[i] = nil end
            end
        end
    end
    return ret
end

function isEmpty(table)
    for _,_ in pairs(table) do
        return false
    end
    return true
end

function copyTable(table)
    local ret = {}
    for i,j in pairs(table) do
        if type(j)=="table" then
            ret[i]=copyTable(j)
        else
            ret[i]=j
        end
    end
    return ret
end

-- Returns true, if the first itemlist contains all items in the second itemlist
function containsEverythingFrom(table1, table2)
    for i,j in pairs(table2) do
        if table1[i] == nil then return false end
        if table1[i]<j then return false end
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
    if table1[itemname]<itemcount then return false end
    return true
end

function concatenateTables(t1,t2)
    if t1 == nil then
        log("Error, table 1 is nil")
        error("Table nil")
    end
    if t2 == nil then
        log("Error, table 2 is nil")
        error("Table nil")
    end
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function compress(str)
    local str2=str, b
    str2=string.gsub(str2, "\t", " ")
    str2=string.gsub(str2, "\n", " ")
    str2=string.gsub(str2, " ", "")
    str2=string.gsub(str2,"minecraft:","mc:")
    str2=string.gsub(str2, "computercraft:", "cc:")
    str2=string.gsub(str2, "emendatusenigmatica:", "ee:")
    return str2
end

function uncompress(str)
    local str2=str
    str2=string.gsub(str2, "mc:", "minecraft:")
    str2=string.gsub(str2, "cc:", "computercraft:")
    str2=string.gsub(str2, "ee:", "emendatusenigmatica:")
    return str2
end
