api = freeswitch.API()

local extension=session:getVariable("destination_number")

local dbh = freeswitch.Dbh("odbc://Freeswitch:praveen:praveen_123")
assert(dbh:connected())
session:consoleLog("INFO","connected to database\n")


local uuid = tostring(session:getVariable("uuid"))
local from = tostring(session:getVariable("caller_id_number"))
local to = tostring(session:getVariable("destination_number"))
local ip = tostring(session:getVariable("network_addr"))

local count = 3

local function play_unauth()
local digit
        digit = session:playAndGetDigits(1, 1, 1, 3000, "#", "/home/praveen/Downloads/auth.wav", "/home/praveen/Downloads/invalid.wav", "[12]")
        session:consoleLog("INFO", "Got DTMF digits: ".. digit .."\n")
        return digit
end

local function play_services()
	 digit=session:playAndGetDigits(1, 1, 1, 5000, "#", "","","")
         if (digit=="1") then
                 destination_number = "91002"
                 session:execute("bridge","user/".. destination_number .."@172.16.16.122")

	 	else if (digit=="2") then
                 	session:execute("voicemail","default $${domain_name} 91002")
                 -- session:transfer("voicemail/"..extension.. "@default")

	 	else if (digit=="3") then
		 	local uuid = session:getVariable("uuid")
                 	session:execute("conference",".." .. uuid .. "..")
		 	session:execute("playback","/home/praveen/Downloads/welcome.wav")
	 	else
		 	count = count - 1
		 	session:consoleLog("INFO","remaining count is:".. count .."\n")
		 	if (count > 0) then
		 		play_services()
				end
			end
		end
	end
end

local function play_hindi()
        session:execute("playback","/home/praveen/Downloads/hindi.wav")
                local digits=session:playAndGetDigits(1, 10, 100, 3000, "#", "","","")
                session:consoleLog("info", "Got DTMF digits: ".. digits .."\n")
		local update_query =string.format("UPDATE contacts_task8 set Number='%s' where FROM_NUMBER='%s'", digits , from)
		dbh:query(update_query)
		session:consoleLog("INFO", "from:" .. from .. "\n")
		session:consoleLog("INFO", "digits:" .. digits .. "\n")

		local digit_count= #digits

                if(digit_count < 10) then
                        play_hindi()
                else
                        session:execute("playback","/home/praveen/Downloads/services_hindi.wav")
                        play_services()
                end
end

local function play_english()
        session:execute("playback","/home/praveen/Downloads/english.wav")
                local digits=session:playAndGetDigits(1, 10, 100, 3000, "#", "","","")
                session:consoleLog("info", "Got DTMF digits: ".. digits .."\n")
		local update_query =string.format("UPDATE contacts_task8 set Number='%s' where FROM_NUMBER='%s'", digits , from)
                dbh:query(update_query)

                local digit_count= #digits

                if(digit_count < 10) then
                        play_english()
                else
			session:execute("playback","/home/praveen/Downloads/services_english.wav")
                        play_services()
                end
end

local function play_gujarati()
        session:execute("playback","/home/praveen/Downloads/gujarati.wav")
                local digits=session:playAndGetDigits(1, 10, 100, 3000, "#", "","","")
                session:consoleLog("info", "Got DTMF digits: ".. digits .."\n")
		local update_query =string.format("UPDATE contacts_task8 set Number='%s' where FROM_NUMBER='%s'", digits , from)
                dbh:query(update_query)

                local digit_count= #digits

                if(digit_count < 10) then
                        play_gujarati()
                else
			session:execute("playback","/home/praveen/Downloads/services_gujarati.wav")
                        play_services()
                end
end

local function play_telugu()
        session:execute("playback","/home/praveen/Downloads/telugu.wav")
                local digits=session:playAndGetDigits(1, 10, 100, 3000, "#", "","","")
                session:consoleLog("info", "Got DTMF digits: ".. digits .."\n")
		local update_query =string.format("UPDATE contacts_task8 set Number='%s' where FROM_NUMBER='%s'", digits , from)
                dbh:query(update_query)

                local digit_count= #digits

                if(digit_count < 10) then
                        play_telugu()
		else
                        session:execute("playback","/home/praveen/Downloads/services_telugu.wav")
                        play_services()
                end
end

local function play_goodbye()
        session:execute("playback","/home/praveen/Downloads/goodbye.wav")
end

local function play_welcome()
        session:execute("playback","/home/praveen/Downloads/welcome.wav")
end

local function play_menu()
        digit = session:playAndGetDigits(1, 1, 1, 3000, "#", "/home/praveen/Downloads/menu.wav", "/home/praveen/Downloads/invalid.wav", "[123490]")
        session:consoleLog("INFO", "Got DTMF digits: ".. digit .."\n")
                if(digit=="1") then
			play_hindi()

		else if(digit=="2") then
			play_english()

		else if (digit=="3") then 
			play_gujarati()

		else if(digit=="4") then 
			play_telugu()

         	else if(digit=="0") then
                 	play_menu()

         	else if(digit=="9") then
                 	play_welcome()
                 	play_menu()
			end
         	end
	end
     end
    end
  end
end


--dbh:test_reactive("SELECT * FROM contacts_task8", "DROP TABLE contacts_task8", "CREATE TABLE contacts_task8 (EMPID int primary key AUTO_INCREMENT, Number varchar(150) DEFAULT NULL, CALL_UUID varchar(100) DEFAULT NULL, FROM_NUMBER varchar(100) DEFAULT NULL, TO_NUMBER varchar(100) DEFAULT NULL, REMOTE_IP varchar(150) DEFAULT NULL)")
local function check()

dbh:query("SELECT * FROM contacts_task8 WHERE FROM_NUMBER="..from,function(row)
        number=string.format("%s",row.FROM_NUMBER)
end)

if (number==NULL) then

        var=play_unauth()

	if(var=="1") then
		 session:consoleLog("INFO","We are in authourization")
		local query = string.format("INSERT INTO contacts_task8 (CALL_UUID, FROM_NUMBER, TO_NUMBER, REMOTE_IP) VALUES ('%s', '%s', '%s', '%s')", uuid, from, to, ip)
		
		dbh:query(query)
		check()
	        else if(var=="2") then

                play_goodbye()
		end
	end
end
end

	check()
	if(var=="2") then 
		return
	end

        play_welcome()

	play_menu()


