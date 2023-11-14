------------------------------------------------------------------------------------------------------------------------


--define
automod = {}

local last_messages_a1 = {}
local last_messages_a2 = {}
local last_messages_b1 = {}
local last_messages_b2 = {}
local last_messages_b3 = {}


------------------------------------------------------------------------------------------------------------------------


--function that removes duplicated characters
local function remove_duplicates(s)
    local result = ""
    for i = 1, #s do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) then
            result = result .. s:sub(i, i)
        end
    end
    return result
end

--function that removes spaces
local function remove_spaces(s)
    local no_space = ""
    no_space = s:gsub("%s+", "")
    return no_space
end

--function that only keeps letters
local function remove_all(s)
    local all_removed = ""
    all_removed = s:gsub("[%W%d]", "")
    return all_removed
end

--function that only keeps letters and spaces
local function remove_parts(s)
    local parts_removed = ""
    parts_removed = s:gsub("[^%a%s]", "")
    return parts_removed
end

--function that replaces special character with spaces
local function replace_parts(s)
    local parts_removed = ""
    parts_removed = s:gsub("[%W%d_]", " ")
    return parts_removed
end


------------------------------------------------------------------------------------------------------------------------


--removes all special characters, spaces, and duplicates so it is just pure plain text
function automod.check_a1(message, name, blacklist)

    if not last_messages_a1[name] then
        last_messages_a1[name] = {}
    end

    message = remove_duplicates(remove_all(string.lower(message)))
    table.insert(last_messages_a1[name], message)
    minetest.chat_send_all("A1: " .. message)

    if #last_messages_a1[name] > 20 then
        table.remove(last_messages_a1[name], 1)
    end

    local last_messages_str_a1 = table.concat(last_messages_a1[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_a1, word) then
            last_messages_a1[name] = {}
            return true
        end
    end
end

--removes all spaces and duplicates but keep special characters
function automod.check_a2(message, name, blacklist)

    if not last_messages_a2[name] then
        last_messages_a2[name] = {}
    end

    message = remove_duplicates(remove_spaces(string.lower(message)))
    table.insert(last_messages_a2[name], message)
    minetest.chat_send_all("A2: " .. message)

    if #last_messages_a2[name] > 20 then
        table.remove(last_messages_a2[name], 1)
    end

    local last_messages_str_a2 = table.concat(last_messages_a2[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_a2, word) then
            last_messages_a2[name] = {}
            return true
        end
    end
end

--removes all special characters and duplicates but keep spaces
--a space is added at the end of each message in the table
function automod.check_b1(message, name, blacklist)

    if not last_messages_b1[name] then
        last_messages_b1[name] = {}
    end

    message = remove_duplicates(remove_parts(string.lower(message))) .. " "
    table.insert(last_messages_b1[name], message)
    minetest.chat_send_all("B1: " .. message)

    if #last_messages_b1[name] > 20 then
        table.remove(last_messages_b1[name], 1)
    end

    local last_messages_str_b1 = table.concat(last_messages_b1[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_b1, word) then
            last_messages_b1[name] = {}
            return true
        end
    end
end

--replace all special characters with spaces and remove duplicates
--a space is added at the end of each message in the table
function automod.check_b2(message, name, blacklist)

    if not last_messages_b2[name] then
        last_messages_b2[name] = {}
    end

    message = remove_duplicates(replace_parts(string.lower(message))) .. " "
    table.insert(last_messages_b2[name], message)
    minetest.chat_send_all("B2: " .. message)

    if #last_messages_b2[name] > 20 then
        table.remove(last_messages_b2[name], 1)
    end

    local last_messages_str_b2 = table.concat(last_messages_b2[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_b2, word) then
            last_messages_b2[name] = {}
            return true
        end
    end
end

--keep special characters and spaces but remove duplicates
--a space is added at the end of each message in the table
function automod.check_b3(message, name, blacklist)

    if not last_messages_b3[name] then
        last_messages_b3[name] = {}
    end

    message = remove_duplicates(string.lower(message)) .. " "
    table.insert(last_messages_b3[name], message)
    minetest.chat_send_all("B3: " .. message)

    if #last_messages_b3[name] > 20 then
        table.remove(last_messages_b3[name], 1)
    end

    local last_messages_str_b3 = table.concat(last_messages_b3[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_b3, word) then
            last_messages_b3[name] = {}
            return true
        end
    end
end


------------------------------------------------------------------------------------------------------------------------


--if "word" is in the blacklist, then "blahwordblah" will still trigger this
function automod.contains_word(target_message, blacklist)
    local blacklist_check = remove_duplicates(string.lower(target_message))
    for _, word in ipairs(blacklist) do
        if string.find(blacklist_check, word) then
            return true
        end
    end
    return false
end

--if "word" is in the blacklist, then "blah word blah" or "word" will trigger this
--"blahwordblah" won't
function automod.contains_word2(target_message, blacklist)
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


--messages that contain all caps and more than 5 characters will trigger this
function automod.contains_caps(target_message)
    if target_message == string.upper(target_message)
    and string.len(target_message) > 5 then
        return true
    else
        return false
    end
end

--messages without a space and contain 15 or more characters will trigger this
function automod.contains_spam(target_message)
    if string.len(target_message) > 20
    and not string.find(target_message, ' ') then
        return true
    else
        return false
    end
end


--this censors the given message using the given blacklist
function automod.censor(message, blacklist)
    message = string.lower(remove_duplicates(message))
    for _, word in ipairs(blacklist) do
        message = message:gsub(word, "*****")
    end
    return message
end

function automod.censor2(message, blacklist)
    message = string.lower(remove_duplicates(message .. " "))
    for _, word in ipairs(blacklist) do
        message = message:gsub(word, "*****")
    end
    return message
end


------------------------------------------------------------------------------------------------------------------------