require("helperFunctions")
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

---returns if the coordinate is positive
---@return boolean
function coordinate:isPositive()
    return self.column > 0 and self.row > 0
end

---checks if the coordinate is greater than the column and row bounds. if either is excluded then it will not be checked for.
---@param row integer
---@param column integer
---@return boolean
function coordinate:greaterThan(row, column)
    ---@diagnostic disable-next-line: undefined-field
    column = column or math.mininteger
    ---@diagnostic disable-next-line: undefined-field
    row = row or math.mininteger
    return self.column >= column and self.row >= row
end

---checks if the coordinate is within the column and row bounds. if either is excluded then it will not be checked for.
---@param row integer
---@param column integer
---@return boolean
function coordinate:lessThan(row, column)
    ---@diagnostic disable-next-line: undefined-field
    column = column or math.maxinteger
    ---@diagnostic disable-next-line: undefined-field
    row = row or math.maxinteger
    return self.column <= column and self.row <= row
end

---@class move
---@field start coordinate the starting postition of the piece
---@field steps table table holding coodinate objects
---@field captures table table holding coordinate objects
---@field init function
---@field addStep function adds a step to the list of steps
---@field addCapture function adds a capture to the list of captures
move = {}

---@param start coordinate
---@return move
function move.init(start)
    local self = table.deepCopy(move)
    self.steps = {}
    self.captures = {}
    self.start = start

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
