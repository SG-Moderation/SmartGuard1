local last_messages = {}
local blacklist_bypass = {"fuck", "fu", "shit", "fck", "sht"}

minetest.register_on_chat_message(function(name, message)

    if not last_messages[name] then
        last_messages[name] = {}
    end

    table.insert(last_messages[name], message)

    if #last_messages[name] > 20 then
        table.remove(last_messages[name], 1)
    end

    local last_messages_str = table.concat(last_messages[name])
    for _, word in ipairs(blacklist_bypass) do
        if string.find(last_messages_str, word) then
            minetest.chat_send_all("Swearing bypass detected.")
            last_messages[name] = {}
            break
        end
    end
end)