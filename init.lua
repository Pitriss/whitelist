
local config_file = minetest.get_worldpath().."/allow.conf"
--in case of not existant config file, it
--will create it
local file_desc = io.open(config_file, "a")
file_desc:close()

local config = Settings(config_file)

local admin_name = minetest.setting_get("name")
if admin_name ~= nil then
	config:set(admin_name, "true")
	config:write()
end


minetest.register_chatcommand("allow", {
	param = "",
	description = "Allows joining for specified nickname.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		if not minetest.check_player_privs(name, {basic_privs}) then
			minetest.chat_send_player(name, "Hey "..name..", you are not allowed to use that command. Privs needed: basic_privs");
			return
		end
		-- Handling parameter
		if param == "" then
			minetest.chat_send_player(name, "You must provide nickname to allow.");
			return
		else
			config:set(param, "true")
			config:write()
			minetest.chat_send_player(name, param.." is now allowed to join server.");
			return
		end
	end
})

minetest.register_chatcommand("disallow", {
	param = "",
	description = "Disallows joining for specified nickname.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		if not minetest.check_player_privs(name, {basic_privs}) then
			minetest.chat_send_player(name, "Hey "..name..", you are not allowed to use that command. Privs needed: basic_privs");
			return
		end
		-- Handling parameter
		if param == "" then
			minetest.chat_send_player(name, "You must provide nickname to disallow.");
			return
		else
			config:set(param, "false")
			config:write()
			minetest.chat_send_player(name, param.." is now not allowed to join server.");
			return
		end
	end
})



minetest.register_on_prejoinplayer(function(name, ip)
	local joining = config:get_bool(name)
	if joining == nil or joining == false then
		minetest.chat_send_all("-!- Server "..name.." tried to join server.")
		return "Sorry you need permission to join this server."
	end
end)
