dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/functions.lua")

--[[
    remember that Lua’s string matching functions like string.find use patterns
    similar to regular expressions, which means certain characters like ., %, *, -, etc.
    have special meanings. If your blacklist contains any of these characters
    and you want to match them literally, you’ll need to escape them using the % character.
]]

local blacklist1 = {"fuck", "shit", "bitch"}
local blacklist2 = {"fu ", "shi ", "f u "}


minetest.register_on_chat_message(function(name, message)
    if automod.smartcontains(message, name, blacklist1) then
        minetest.chat_send_all("Swearing detected.")

        local censored_message = automod.censor(message, blacklist1)
        minetest.chat_send_all("<" .. name .. "> " .. censored_message)
        return true
    end
end)

minetest.register_on_chat_message(function(name, message)
    if automod.contains_caps(message) then
        minetest.chat_send_all("All-caps detected.")
    end
end)

minetest.register_on_chat_message(function(name, message)
    if automod.contains_spam(message) then
        minetest.chat_send_all("Spamming detected.")
    end
end)

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