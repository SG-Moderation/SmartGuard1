local last_three_messages = {}
local blacklist_bypass = {"fuc", "fuk", "sht", "fck"}

minetest.register_on_chat_message(function(name, message)

    if not last_three_messages[name] then
        last_three_messages[name] = {}
    end

    table.insert(last_three_messages[name], message)

    if #last_three_messages[name] > 3 then
        table.remove(last_three_messages[name], 1)
    end

    local last_three_messages_str = table.concat(last_three_messages[name])
    for _, word in ipairs(blacklist_bypass) do
        if last_three_messages_str == word then
            minetest.chat_send_all("Swearing bypass detected.")
            break
        end
    end
end)