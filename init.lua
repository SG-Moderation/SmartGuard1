dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/functions.lua")

local function gettime()
    local current_time = os.date("*t")
    local cdate = current_time.year .. "-" .. current_time.month .. "-" .. current_time.day
    local ctime = current_time.hour .. ":" .. current_time.min .. ":" .. current_time.sec
    return cdate .. " " .. ctime
end


--[[
    remember that Lua’s string matching functions like string.find use patterns
    similar to regular expressions, which means certain characters like ., %, *, -, etc.
    have special meanings. If your blacklist contains any of these characters
    and you want to match them literally, you’ll need to escape them using the % character.
]]

local blacklist1 = {"fuck", "shit", "bitch"}
local blacklist2 = {"fu ", "shi ", "f u "}


minetest.register_on_chat_message(function(name, message)
    if automod.smartcontains1(message, name, blacklist1) then
        file = io.open(minetest.get_worldpath("mt_automod") .. "/AUTOMOD_LOGS.txt", "a")
        file:write(gettime() .. "   ", "Player " .. name .. " said " .. message .. "\n")
        file:close()

    end
end)

minetest.register_on_chat_message(function(name, message)
    if automod.smartcontains2(message, name, blacklist2) then
        minetest.chat_send_all("Swearing detected.")

    end
end)



--minetest.register_on_chat_message(function(name, message)
    --if automod.contains_caps(message) then
        --minetest.chat_send_all("All-caps detected.")
    --end
--end)

--minetest.register_on_chat_message(function(name, message)
    --if automod.contains_spam(message) then
        --minetest.chat_send_all("Spamming detected.")
    --end
--end)

--minetest.register_on_chat_message(function(name, message)
    --if automod.contains_pattern(message, blacklist_smart) then
        --minetest.chat_send_all("Swearing detected.")
    --end
--end)

--minetest.register_on_chat_message(function(name, message)
    --if automod.contains_word(message, blacklist_simple) then
        --minetest.chat_send_all("Swearing detected.")
    --end
--end)