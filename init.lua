local blacklist = {"fuck", "shit", "bitch"}
local blacklist_simple = {"fu", "sht"}

function remove_duplicates(s)
    local result = ""
    for i = 1, #s do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) then
            result = result .. s:sub(i, i)
        end
    end
    return result
end

minetest.register_on_chat_message(function(name, message)

    local blacklist_check = remove_duplicates(string.lower(message))
    --minetest.chat_send_all(blacklist_check)

    for _, word in ipairs(blacklist) do
        if string.find(blacklist_check, word) then

            minetest.chat_send_all("No swearing please!")

            return true
        end
    end

    return false
end)

minetest.register_on_chat_message(function(name, message)

    local blacklist_check = remove_duplicates(string.lower(message))
    --minetest.chat_send_all(blacklist_check)

    local word_table = {}
    for word in blacklist_check:gmatch("%w+") do table.insert(word_table, word) end

    for _, word in ipairs(blacklist_simple) do
        for _, word_table in ipairs (word_table) do
            if word == word_table then
                
                minetest.chat_send_all("No swearing please!")

                return true
            end
        end
    end

    return false
end)