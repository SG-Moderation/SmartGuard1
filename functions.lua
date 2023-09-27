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

-- if "word" is in the blacklist, then "blahwordblah" will still trigger this
function automod.contains_pattern(target_message, blacklist)
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

-- messages that contain all caps and more than 5 characters will trigger this
function automod.contains_caps(target_message)
    if target_message == string.upper(target_message)
    and string.len(target_message) > 5 then
        return true
    else
        return false
    end
end

-- messages without a space and contain 15 or more characters will trigger this
function automod.contains_spam(target_message)
    if string.len(target_message) > 15
    and not string.find(target_message, ' ') then
        return true
    else
        return false
    end
end