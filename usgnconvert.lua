use = 1 -- 2 for wget (kinda useless, also works, curl is still needed)
-- By TopNotch #95753, PM for questions
convert = {}

function convert.usgnstatus()
	local checkstatus = io.popen("curl -Is http://www.unrealsoftware.de | head -1")
	local status = checkstatus:read("*a")
	if status:match("HTTP/1.1 200 OK") then
		return true;
	else
		return false;
	end
	status:close()
end

function convert.toName(usgn)
	if not convert.usgnstatus() then return end
	if use == 1 then 
		handle = io.popen("curl http://www.unrealsoftware.de/connect.php?getname="..usgn.."; echo")
	else
		handle = io.popen("wget http://www.unrealsoftware.de/connect.php?getname="..usgn.." -O - -q ; echo")
	end
	local result = handle:read("*a")
	handle:close()
	return result
end

function convert.toUSGN(name)
	if not convert.usgnstatus() then return end
	if use == 1 then 
		handle = io.popen("curl http://www.unrealsoftware.de/connect.php?getid="..name.."; echo")
	else
		handle = io.popen("wget http://www.unrealsoftware.de/connect.php?getid="..name.." -O - -q ; echo")
	end
	local result = handle:read("*a")
	handle:close()
	return result
end

function toTable(txt,match)
    local cmd = {}
    if not match then match = '[^%s]+' end
    for word in string.gmatch(txt,match) do
        table.insert(cmd,word)
    end
    return cmd
end

pre = "\169175255100[USGN]:\169255255255 "

addhook("say","_say")
function _say(id, txt)
	cmd = toTable(txt)
	if cmd[1] == "!nametoid" then
		local name = txt:sub(11)
		msg2(id,pre.."ID: "..convert.toUSGN(name).." Name: "..name)
		return 1
	elseif cmd[1] == "!idtoname" then
		local usgn = tonumber(cmd[2])
		msg2(id,pre.."ID: "..usgn.." Name: "..convert.toName(usgn))
		return 1
	end
end

addhook("join","_join")
function _join(id)
	if convert.usgnstatus() then
		if player(id,"usgn") > 0 then
	 		msg("\169255255255"..player(id,"name").." joined ("..player(id,"usgn").."/"..convert.toName(player(id,"usgn"))..")")
	 	else
	 		msg("\169255255255"..player(id,"name").." joined (not logged in)")
	 	end
	end
end