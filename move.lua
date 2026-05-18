dofile("helperFunctions.lua")
---@class coordinate
---@field row integer
---@field column integer
coordinate = {}

---2d cartesian coordinates
---@param row integer
---@param column integer
---@return coordinate
function coordinate.init(row, column)
    local self = table.deepCopy(coordinate)
    self.row = row
    self.column = column

    return self
end

---@param changeRow integer
---@param changeColumn integer
function coordinate:move(changeRow, changeColumn)
    self.column = self.column + changeColumn
    self.row = self.row + changeRow
end

---checks if the coodinate is positive
---@return boolean
function coordinate:isPositive()
    return self.column > 0 and self.row > 0
end

---checks if the coordinate is within the column and row bounds. if either is excluded then it will not be checked for.
---@param row integer
---@param column integer
---@return boolean
function coordinate:within(row, column)
    column = column or math.maxinteger
    row = row or math.maxinteger
    return self.column <= column and self.row <= row
end

---@class move
---@field steps table table holding coodinate objects
---@field captures table table holding coordinate objects
move = {}

---@param start coordinate
---@return move
function move.init(start)
    local self = table.deepCopy(move)
    self.steps = {}
    self.captures = {}
    table.insert(self.steps, start)

    return self
end

---@param step coordinate
function move:addStep(step)
    table.insert(self.steps, step)
end

---@param capture coordinate
function move:addCapture(capture)
    table.insert(self.captures, capture)
end
