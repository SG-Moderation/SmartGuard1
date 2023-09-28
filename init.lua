dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/functions.lua")

local blacklist_smart = {"fuck", "shit", "bitch", "fu ", "f u ", "f u c k", "s h i t", "helo", "h e l l o"}
local blacklist_simple = {"fu", "sht"}

minetest.register_on_chat_message(function(name, message)
    if automod.smartcontains_word(message, name, blacklist_smart) then
        minetest.chat_send_all("Swearing detected.")
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