local last_three_messages = {}

minetest.register_on_chat_message(function(name, message)

    if not last_three_messages[name] then
        last_three_messages[name] = {}
    end

    table.insert(last_three_messages[name], message)

    if #last_three_messages[name] > 3 then
        table.remove(last_three_messages[name], 1)
    end

    if table.concat(last_three_messages[name]) == "fuc" then
        minetest.chat_send_all("Swearing bypass detected.")
    end
end)