fs.copy("disk/turtleStartup", "/startup")
fs.copy("disk/communication", "/communication")
fs.copy("disk/generalHelpingFunctions", "/generalHelpingFunctions")
fs.copy("disk/itemstacksizesAndMaxCounts", "/itemstacksizesAndMaxCounts")
fs.copy("disk/logger", "/logger")
fs.copy("disk/standardValues", "/standardValues")
fs.copy("disk/recipes", "/recipes")
fs.copy("disk/init", "/init")
fs.copy("disk/processCommand","/processCommand")
fs.copy("disk/build", "/build")
fs.copy("disk/crafting", "/crafting")
fs.copy("disk/mining", "/mining")
fs.copy("disk/moveInBase", "/moveInBase")
fs.copy("disk/movement", "/movement")
fs.copy("disk/smelting", "/smelting")
fs.copy("disk/farming", "/farming")
fs.delete("disk/startup")
os.reboot()