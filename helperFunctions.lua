--#region
---tables

---makes a deep copy of a lua table
---@param tbl table
---@param indents integer | nil number of spaces to indent the rest of the table
---@return string
function table.tostring(tbl, indents)
    indents = indents or 0
    local indentation = ""
    for i = 0, indents, 1 do
        indentation = indentation .. " "
    end
    local noComma = true
    local retStr = "{ "
    for key, value in pairs(tbl) do
        if not noComma then
            retStr = retStr .. ", "
        end
        noComma = false

        if type(value) == "table" then
            retStr = retStr .. "\n" .. indentation .. tostring(key) .. ":"
            retStr = retStr .. table.tostring(value, indents + 1) .. ",\n" .. indentation
            noComma = true
        else
            retStr = retStr .. tostring(key) .. ":"
            retStr = retStr .. tostring(value)
        end
    end
    retStr = retStr .. "}"
    return retStr
end

function table.equals(tbl, otherTbl)
    for key, value in pairs(tbl) do
        if type(value) == type(otherTbl[key]) then
            if type(value) == "table" then
                if not table.equals(value, otherTbl[key]) then
                    return false
                end
            elseif value ~= otherTbl[key] then
                return false
            end
        else
            return false
        end
    end
    return true
end

---makes a deep copy of a table
---@param tbl table
---@return table
function table.deepCopy(tbl)
    local copy = {}
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            copy[key] = table.deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

--local testTable = { 1, 2, 3, { 1, 2, 3, 4, { "how" } } }
--local othertestTable = table.deepCopy(testTable)
--local testTable3 = { 1, 2, 3, { 1, 2, 3, 4, { "why" } } }
--
--print(table.equals(testTable, othertestTable))
--print(table.equals(othertestTable, testTable3))
--#endregion
