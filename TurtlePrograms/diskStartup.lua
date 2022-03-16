if not fs.exists("/startup") then
  fs.copy("disk/turtleStartup", "/startup")
end
local h=fs.open("disk/turtleNumber","r")
local num = h.readLine()
os.setComputerLabel("Bob "..num)
h.close()
h=fs.open("disk/turtleNumber","w")
h.write(num+1)
h.close()
sleep(1)
turtle.back()
os.reboot()