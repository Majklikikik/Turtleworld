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
    for index, value in ipairs(tab) do
        if value == val then
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

-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function print_table(node)
local cache, stack, output = {},{},{}
local depth = 1
local output_str = "{\n"

while true do
    local size = 0
    for k,v in pairs(node) do
        size = size + 1
    end

    local cur_index = 1
    for k,v in pairs(node) do
        if (cache[node] == nil) or (cur_index >= cache[node]) then

            if (string.find(output_str,"}",output_str:len())) then
                output_str = output_str .. ",\n"
            elseif not (string.find(output_str,"\n",output_str:len())) then
                output_str = output_str .. "\n"
            end

            -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
            table.insert(output,output_str)
            output_str = ""

            local key
            if (type(k) == "number" or type(k) == "boolean") then
                key = "["..tostring(k).."]"
            else
                key = "['"..tostring(k).."']"
            end

            if (type(v) == "number" or type(v) == "boolean") then
                output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
            elseif (type(v) == "table") then
                output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                table.insert(stack,node)
                table.insert(stack,v)
                cache[node] = cur_index+1
                break
            else
                output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
            end

            if (cur_index == size) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            else
                output_str = output_str .. ","
            end
        else
            -- close the table
            if (cur_index == size) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            end
        end

        cur_index = cur_index + 1
    end

    if (size == 0) then
        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
    end

    if (#stack > 0) then
        node = stack[#stack]
        stack[#stack] = nil
        depth = cache[node] == nil and depth + 1 or depth - 1
    else
        break
    end
end

-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
table.insert(output,output_str)
output_str = table.concat(output)

log(output_str)
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
end

function addValues(table1, table2)
    local ret={}
    if table1~=nil then
        for i,j in pairs(table1) do
            if ret[i]==nil then
                ret[i]=j
            else
                ret[i]=ret[i]+j
            end
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

function isEmpty(table)
    for _,_ in pairs(table) do
        return false
    end
    return true
end