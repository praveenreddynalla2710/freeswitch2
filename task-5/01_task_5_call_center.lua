api=freeswitch.API()

local queue="FS@Ecosmob-EMPID"

freeswitch.consoleLog("info", "we are in the lua script: ")
session:execute("callcenter", queue)
