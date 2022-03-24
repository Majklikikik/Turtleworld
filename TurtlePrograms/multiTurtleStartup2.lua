require( "recipesInitiation")
require( "resourceCalculator")
require( "communication")
require( "generalHelpingFunctions")
require( "itemstacksizesAndMaxCounts")
require( "logger")
require( "standardValues")
require( "recipes")
require( "init")
require("processCommand ")
resetLog()

local a = peripheral.wrap("back")
if a ~= nil then
    a.turnOn()
end

a = peripheral.wrap("top")
if a ~= nil then
    a.turnOn()
end
