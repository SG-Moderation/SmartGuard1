dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/functions.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/anti-bypass.lua")

local blacklist_complex = {"fuck", "shit", "bitch"}
local blacklist_simple = {"fu", "sht"}

minetest.register_on_chat_message(function(name, message)
    if automod.contains_pattern(message, blacklist_complex) then
        minetest.chat_send_all("Swearing detected.")
    end
end)

minetest.register_on_chat_message(function(name, message)
    if automod.contains_word(message, blacklist_simple) then
        minetest.chat_send_all("Swearing detected.")
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