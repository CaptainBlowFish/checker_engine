dofile("helperFunctions.lua")
dofile("move.lua")

---@class baseCheckerPiece @baseCheckerPiece class
---@field init function initializes a new piece object
---@field isRed boolean
---@field position coordinate postition on the game board
---@field canCapture boolean
---@field mustMove boolean used to enforce manditory multiple captures
---@field capture function
---@field check function
---@field getPossibleMoves function
---@field move function
---@field pieceName string the name of the type of piece
baseCheckerPiece = {}

baseCheckerPiece.pieceName = "basic"

---@param isRed boolean
---@param position coordinate postition on the game board
---@return baseCheckerPiece
function baseCheckerPiece.init(isRed, position)
    local self = table.deepCopy(baseCheckerPiece)

    self.isRed = isRed
    self.position = position
    self.canCapture = false
    self.mustMove = false

    return self
end

---checks for a capture and normal move
---@param board board
---@param blanks move[]
---@param captures move[]
---@param close coordinate
---@param far coordinate
function baseCheckerPiece:check(board, blanks, captures, close, far)
    if close:isPositive() and close:lessThan(board.width, board.height) then
        if board.playarea[close.row][close.column].isRed == nil then
            table.insert(blanks, move.init(self.position))
            blanks[#blanks]:addStep(close)
        elseif board.playarea[close.row][close.column].isRed ~= self.isRed then
            if far:isPositive() and far:lessThan(board.width, board.height) then
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
---@return move[] @the possible moves that a piece can take in the current board state
function baseCheckerPiece:getPossibleMoves(board)
    local blanks = {} ---@type move[] all the possible moves for the piece that don't capture any others
    local captures = {} ---@type move[] all possible moves that capture another piece



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
function baseCheckerPiece:move(board, destination)
    local possibleMoves = self:getPossibleMoves(board)
    local captured = false
    for _, possMove in pairs(possibleMoves) do
        for key, value in pairs(possMove.steps) do
            if table.equals(destination, value) then
                self.mustMove = false
                for k, v in pairs(possMove.captures) do
                    board.playarea[v.row][v.column]:capture(board)
                    captured = true
                end
                local temp = table.deepCopy(self)
                temp.position = table.deepCopy(destination)

                local nextPossibleMoves = temp:getPossibleMoves(board)
                if captured and #nextPossibleMoves >= 1 and #nextPossibleMoves[1].captures >= 1 then
                    temp.mustMove = true
                end
                if destination.row == #board.playarea or destination.row == 0 then
                    board.playarea[destination.row][destination.column] = kingCheckerPiece.init(temp)
                else
                    board.playarea[destination.row][destination.column] = temp
                end
                ---@diagnostic disable-next-line: missing-fields
                board.playarea[self.position.row][self.position.column] = {}
                return true
            end
        end
    end

    return false
end

---will increase the capture count and delete the piece
---@param board board
function baseCheckerPiece:capture(board)
    if self.isRed then
        board.redCaptured = board.redCaptured + 1
    else
        board.blackCaptured = board.blackCaptured + 1
    end
    ---@diagnostic disable-next-line: missing-fields
    board.playarea[self.position.row][self.position.column] = {}
end

---@class kingCheckerPiece: baseCheckerPiece
kingCheckerPiece = table.deepCopy(baseCheckerPiece)

kingCheckerPiece.pieceName = "king"

---if no prevPiece is given then isRed and position must be given and vice versa
---@param prevPiece baseCheckerPiece | nil
---@param isRed boolean | nil
---@param position coordinate | nil postition on the game board
function kingCheckerPiece.init(prevPiece, isRed, position)
    local self = table.deepCopy(kingCheckerPiece)
    if prevPiece == nil then
        self.isRed = isRed
        self.position = position
        self.canCapture = false
        self.mustMove = false
    else
        self.isRed = prevPiece.isRed
        self.position = table.deepCopy(prevPiece.position)
        self.canCapture = prevPiece.canCapture
        self.mustMove = prevPiece.mustMove
    end

    return self
end

---gets the possible moves for a king piece
---@param board board
---@return move[] @the possible moves that a king piece can take in the current board state
function kingCheckerPiece:getPossibleMoves(board)
    local blanks = {}   --- all the possible moves for the piece that don't capture any others
    local captures = {} --- all possible moves that capture another piece



    ---upper right
    local closeRight = coordinate.init(self.position.row - 1, self.position.column + 1)
    local farRight = coordinate.init(self.position.row - 2, self.position.column + 2)
    self:check(board, blanks, captures, closeRight, farRight)
    ---upper left
    local closeLeft = coordinate.init(self.position.row - 1, self.position.column - 1)
    local farLeft = coordinate.init(self.position.row - 2, self.position.column - 2)
    self:check(board, blanks, captures, closeLeft, farLeft)
    ---lower right
    closeRight = coordinate.init(self.position.row + 1, self.position.column + 1)
    farRight = coordinate.init(self.position.row + 2, self.position.column + 2)
    self:check(board, blanks, captures, closeRight, farRight)
    ---lower left
    closeLeft = coordinate.init(self.position.row + 1, self.position.column - 1)
    farLeft = coordinate.init(self.position.row + 2, self.position.column - 2)
    self:check(board, blanks, captures, closeLeft, farLeft)

    if #captures > 0 then
        return captures
    else
        return blanks
    end
end
