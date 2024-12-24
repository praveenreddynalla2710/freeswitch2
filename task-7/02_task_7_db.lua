api = freeswitch.API()

local dbh = freeswitch.Dbh("odbc://Freeswitch:praveen:praveen_123")
assert(dbh:connected())
session:consoleLog("INFO","connected to database \n")


