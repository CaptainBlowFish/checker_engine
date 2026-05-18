dofile("helperFunctions.lua")
dofile("move.lua")

---@class checkerPiece @checkerPiece class
---@field init function initializes a new piece object
---@field isRed boolean
---@field position coordinate postition on the game board
---@field canCapture boolean
checkerPiece = {}


---@param isRed boolean
---@param position coordinate postition on the game board
---@return checkerPiece
function checkerPiece.init(isRed, position)
    local self = table.deepCopy(checkerPiece)

    self.isRed = isRed
    self.position = position
    self.canCapture = false

    return self
end

---checks for a capture and normal move
---@param board board
---@param blanks table
---@param captures table
---@param close coordinate
---@param far coordinate
function checkerPiece:check(board, blanks, captures, close, far)
    if close:isPositive() and close:within(board.width, board.height) then
        if board.playarea[close.row][close.column].isRed == nil then
            table.insert(blanks, move.init(self.position))
            blanks[#blanks]:addStep(close)
        elseif board.playarea[close.row][close.column].isRed ~= self.isRed then
            if far:isPositive() and close:within(board.width, board.height) then
                if board.playarea[far.row][far.column].isRed == nil then
                    table.insert(captures, move.init(self.position))
                    captures[#captures]:addCapture(coordinate.init(close.row, close.column))
                    captures[#captures]:addStep(coordinate.init(far.row, far.column))
                end
            end
        end
    end
end

---gets the possible moves for a piece
---@param board board
---@return table @the possible moves that a piece can take in the current board state
function checkerPiece:getPossibleMoves(board)
    local blanks = {}   --- all the possible moves for the piece that don't capture any others
    local captures = {} --- all possible moves that capture another piece



    if self.isRed then
        ---right
        local closeRight = coordinate.init(self.position.row - 1, self.position.column + 1)
        local farRight = coordinate.init(self.position.row - 2, self.position.column + 2)
        self:check(board, blanks, captures, closeRight, farRight)
        ---left
        local closeLeft = coordinate.init(self.position.row - 1, self.position.column - 1)
        local farLeft = coordinate.init(self.position.row - 2, self.position.column - 2)
        self:check(board, blanks, captures, closeLeft, farLeft)
    else
        ---right
        local closeRight = coordinate.init(self.position.row + 1, self.position.column + 1)
        local farRight = coordinate.init(self.position.row + 2, self.position.column + 2)
        self:check(board, blanks, captures, closeRight, farRight)
        ---left
        local closeLeft = coordinate.init(self.position.row + 1, self.position.column - 1)
        local farLeft = coordinate.init(self.position.row + 2, self.position.column - 2)
        self:check(board, blanks, captures, closeLeft, farLeft)
    end

    if #captures > 0 then
        return captures
    else
        return blanks
    end
end

---will attempt to move the piece. returns true on success
---@param board board
---@param destination coordinate
---@return boolean
function checkerPiece:move(board, destination)
    local possibleMoves = self:getPossibleMoves(board)
    for _, possMove in pairs(possibleMoves) do
        for key, value in pairs(possMove.steps) do
            if table.equals(destination, value) then
                for k, v in pairs(possMove.captures) do
                    board.playarea[v.row][v.column]:capture(board)
                end
                local temp = table.deepCopy(self)
                temp.position = table.deepCopy(destination)
                board.playarea[destination.row][destination.column] = temp

                board.playarea[self.position.row][self.position.column] = {}
                return true
            end
        end
    end

    return false
end

---will increase the capture count and delete the piece
---@param board board
function checkerPiece:capture(board)
    if self.isRed then
        board.redCaptured = board.redCaptured + 1
    else
        board.blackCaptured = board.blackCaptured + 1
    end
    board.playarea[self.position.row][self.position.column] = {}
end
