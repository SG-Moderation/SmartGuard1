--define
automod = {}

local last_messages1 = {}
local last_messages2 = {}


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

--function that removes certain special characters
local function remove_all(s)
    local all_removed = ""
    all_removed = s:gsub("%W", "")
    return all_removed
end


--NON-SPACE-SENSITIVE DETECTION
--messages by players will be logged into a table, with a table for each player.
--A space **won't** be added at the end of each message.
function automod.smartcontains1(message, name, blacklist)

    if not last_messages1[name] then
        last_messages1[name] = {}
    end

    message = remove_duplicates(remove_all(string.lower(message)))
    table.insert(last_messages1[name], message)
    minetest.chat_send_all(message)

    if #last_messages1[name] > 20 then
        table.remove(last_messages1[name], 1)
    end

    local last_messages_str1 = table.concat(last_messages1[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str1, word) then
            last_messages1[name] = {}
            return true
        end
    end
end

--SPACE-SENSITIVE DETECTION
--messages by players will be logged into a table, with a table for each player.
--A space **will** be added at the end of each message.
function automod.smartcontains2(message, name, blacklist)

    if not last_messages2[name] then
        last_messages2[name] = {}
    end

    table.insert(last_messages2[name], remove_duplicates(string.lower(message)) .. " ")

    if #last_messages2[name] > 20 then
        table.remove(last_messages2[name], 1)
    end

    local last_messages_str2 = table.concat(last_messages2[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str2, word) then
            last_messages2[name] = {}
            return true
        end
    end
end


--actual useful code ends here
--------------------------------------------------------------------------------------------------


-- if "word" is in the blacklist, then "blahwordblah" will still trigger this
function automod.contains_word(target_message, blacklist)
    local blacklist_check = remove_duplicates(string.lower(target_message))
    for _, word in ipairs(blacklist) do
        if string.find(blacklist_check, word) then
            return true
        end
    end
    return false
end

-- if "word" is in the blacklist, then "blah word blah" or "word" will trigger this
-- "blahwordblah" won't
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


-- this censors the given message using the given blacklist
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