dofile("checkerPiece.lua")
dofile("move.lua")
dofile("helperFunctions.lua")


---@class board
---@field playarea baseCheckerPiece[][] 2d array representing all the spots on a board
---@field redTurn boolean it will always be someone's turn
---@field redWin boolean
---@field blackWin boolean
---@field redCaptured integer count of all red pieces that were captured
---@field blackCaptured integer count of all black pieces that were captured
---@field turns integer how many turns have been taken
---@field width integer width of the playarea measured in tiles
---@field height integer height of the playarea measured in tiles
board = {}

---@param width integer | nil
---@param height integer | nil
---@return board
function board.init(width, height)
    local self = table.deepCopy(board)
    ---standard checker board size is 8x8
    self.playarea = {}

    self.width = width or 8
    self.height = height or 8
    self.redTurn = true
    self.redWin = false
    self.blackWin = false
    self.redCaptured = 0
    self.blackCaptured = 0
    self.turns = 0

    ---creates board
    for i = 1, self.height, 1 do
        local temp = {}
        for j = 1, self.width, 1 do
            table.insert(temp, {})
        end
        table.insert(self.playarea, temp)
    end


    return self
end

---will print the current board to the console
---@param printTurn boolean
---@param showPieceMoves boolean
function board:printBoard(printTurn, showPieceMoves)
    if printTurn then
        if self.redTurn then
            print("red turn")
        else
            print("black turn")
        end
    end

    local rowNum = 1
    local head = ""
    local lineSep = ""
    for i = 1, self.width, 1 do
        head = head .. "———" .. tostring(i)
        lineSep = lineSep .. "————"
    end

    head = head .. "——"
    lineSep = lineSep .. "——"
    print(head)
    for i, row in ipairs(self.playarea) do
        local line = tostring(rowNum) .. "| "
        rowNum = rowNum + 1
        for j, square in ipairs(row) do
            if square.isRed == nil then -- will be nil since it is undefined in blank spots
                line = line .. "  | "
            else
                local possibleMoves = #square:getPossibleMoves(self)
                if square.pieceName == "king" then
                    line = line .. "\27[1m"
                end
                if square.isRed then
                    line = line .. "\27[31m"
                else
                    line = line .. "\27[34m"
                end

                if showPieceMoves then
                    line = line .. possibleMoves
                else
                    if square.isRed then
                        line = line .. "R"
                    else
                        line = line .. "B"
                    end
                end

                line = line .. "\27[0m | "
            end
        end
        print(line)
        print(lineSep)
    end
end

function board:terminalGame()
    self:setupCheckers()

    while true do
        self:printBoard(true, true)
        print("Choose a piece")
        print("row:")
        local row = tonumber(io.read())
        print("column:")
        local column = tonumber(io.read())
        if self.playarea[row][column].isRed == nil then
            print("Not a piece!")
        else
            print("Choose a destination")
            print("row:")
            local drow = tonumber(io.read(), 10)
            print("column:")
            local dcolumn = tonumber(io.read(), 10)
            if not self:makeMove(self.playarea[row][column].position, coordinate.init(drow, dcolumn)) then
                print("\27[1m\27[31mMOVE NOT POSSIBLE!\27[0m")
            end
        end
    end
end

---populates the playarea with checker pieces arranged in a standard fassion
---@param rowsPerSide integer | nil number of rows to populate per side defaults to 3
function board:setupCheckers(rowsPerSide)
    rowsPerSide = rowsPerSide or 3
    local offset = false
    for row = 1, rowsPerSide, 1 do
        offset = not offset
        for column = 1, self.width, 2 do
            if offset then
                self.playarea[row][column + 1] = baseCheckerPiece.init(false, coordinate.init(row, column + 1))
            else
                self.playarea[row][column] = baseCheckerPiece.init(false, coordinate.init(row, column))
            end
        end
    end

    offset = true
    for row = self.height - rowsPerSide + 1, self.height, 1 do
        offset = not offset
        for column = 1, self.width, 2 do
            if offset then
                self.playarea[row][column + 1] = baseCheckerPiece.init(true, coordinate.init(row, column + 1))
            else
                self.playarea[row][column] = baseCheckerPiece.init(true, coordinate.init(row, column))
            end
        end
    end
end

---attempt a move
---@param start coordinate
---@param destination coordinate
---@return boolean
function board:makeMove(start, destination)
    local pieceIsRed = self.playarea[start.row][start.column].isRed
    ---checkes if there is a piece to move
    if pieceIsRed == nil then
        return false
    end

    ---checkes if it is the proper turn
    if self.redTurn ~= pieceIsRed then
        return false
    end

    ---makes sure only pieces marked as mustMove can be moved
    if self:mustMoves(self.redTurn) and not self.playarea[start.row][start.column].mustMove then
        return false
    end

    local moveSuccess = self.playarea[start.row][start.column]:move(self, destination)
    if moveSuccess and not self.playarea[destination.row][destination.column].mustMove then
        self.redTurn = not self.redTurn
    end
    return moveSuccess
end

---checks the board for pieces that are marked as mustMove
---@param red boolean if true checks for red mustMoves; false checks for black
---@return boolean
function board:mustMoves(red)
    for _, row in pairs(self.playarea) do
        for key, square in pairs(row) do
            if square.isRed == red and square.mustMove then
                return true
            end
        end
    end
    return false
end

--- game = board.init()
--- game:terminalGame()
