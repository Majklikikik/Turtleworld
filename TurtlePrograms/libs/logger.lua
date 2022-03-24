function resetLog()
    local h=fs.open("log.txt","w")
    h.write(os.date('%Y-%m-%d %H:%M:%S').."\n")
    h.close()
end
function log(text, name, silent, addHole)
    if addHole==nil then addHole = 0 end
    if text==nil
    then log("nil",name)
        return
    end



    if type(text)=="table" then
        if (name~=nil) then log(name,nil,silent,addHole) end
        log("{", nil, silent, addHole)
        if isEmpty(text) then
            log("empty",nil,silent,addHole+4)
        end
        for i,_ in pairs(text) do
            log(text[i],i, silent, addHole + 4)
        end
        log("}",nil, silent, addHole)
        return
    end


    if type(text)=="boolean" then
        text=tostring(text)
    end

    if name~=nil then
        if not silent then
            local nameText
            if type(name)=="table" then
                nameText="<aTable>"
            else
                nameText="<"..name..">  "
            end
            nameText=nameText..string.rep(" ",50-nameText:len())
            text=nameText..text
        end
    end


    local h=fs.open("log.txt","a")
    if not silent then print(text.."\n") end
    text2=getStackTrace(2,3)..": "
    --text2 = text2..string.rep(" ",90-text2:len())..os.clock()
    text2 = text2..string.rep(" ",90-text2:len())..os.date("%H:%M:%S")
    text=text2..string.rep(" ",120-text2:len()+addHole)..text
    h.write(text.."\n")
    h.close()
end