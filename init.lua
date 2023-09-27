automod = {}

local function remove_duplicates(s)
    local result = ""
    for i = 1, #s do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) then
            result = result .. s:sub(i, i)
        end
    end
    return result
end

function automod.contains_pattern(target_message, blacklist)
    local blacklist_check = remove_duplicates(string.lower(target_message))
    for _, word in ipairs(blacklist) do
        if string.find(blacklist_check, word) then
            return true
        end
    end
    return false
end

function automod.contains_word(target_message, blacklist)
    local blacklist_check = remove_duplicates(string.lower(target_message))
    local word_table = {}
    for word in blacklist_check:gmatch("%w+") do 
        table.insert(word_table, word) 
    end
    for _, word in ipairs(blacklist) do
        for _, word_table in ipairs (word_table) do
            if word == word_table then
                return true
            end
        end
    end
    return false
end

function automod.contains_caps(target_message)
    if target_message == string.upper(target_message)
    and string.len(target_message) > 5 then
        return true
    else
        return false
    end
end

function automod.contains_spam(target_message)
    if string.len(target_message) > 20
    and not string.find(target_message, ' ') then
        return true
    else
        return false
    end
end


local blacklist_complex = {"fuck", "shit", "bitch"}
local blacklist_simple = {"fu", "sht"}

minetest.register_on_chat_message(function(name, message)
    if automod.contains_pattern(message, blacklist_complex) then
        minetest.chat_send_all("No swearing please!")
        return true
    end
    return false
end)

minetest.register_on_chat_message(function(name, message)
    if automod.contains_word(message, blacklist_simple) then
        minetest.chat_send_all("No swearing please!")
        return true
    end
    return false
end)

minetest.register_on_chat_message(function(name, message)
    if automod.contains_caps(message) then
        minetest.chat_send_all("No all caps please!")
        return true
    end
    return false
end)

minetest.register_on_chat_message(function(name, message)
    if automod.contains_spam(message) then
        minetest.chat_send_all("No spamming please!")
        return true
    end
    return false
end)