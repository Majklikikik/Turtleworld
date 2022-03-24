fs.copy("disk/computerstartup", "/startup")
fs.copy("disk/recipesInitiation", "/recipesInitiation")
fs.copy("disk/resourceCalculator", "/resourceCalculator")
fs.copy("disk/communication", "/communication")
fs.copy("disk/generalHelpingFunctions", "/generalHelpingFunctions")
fs.copy("disk/itemstacksizesAndMaxCounts", "/itemstacksizesAndMaxCounts")
fs.copy("disk/logger", "/logger")
fs.copy("disk/standardValues", "/standardValues")
fs.copy("disk/recipes", "/recipes")
fs.copy("disk/init", "/init")
fs.copy("disk/computerPlanner", "/computerPlanner")
fs.delete("disk/startup")
os.setComputerLabel("Boss")
require("communication")
require("init")
require("logger")
require("generalHelpingFunctions")
log("Getting start state")
initComputerFile()
local h=fs.open("BOSS","w")
h.write("I AM THE BOSS")
log("Writer is nil: ")
log(h==nil)
h.close()
log("Bossfiles written.")
os.reboot()