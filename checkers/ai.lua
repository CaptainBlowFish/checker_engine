require("nonBasicDataTypes")
require("helperFunctions")
require("checkers.checkerPiece")
require("checkers.checkerBoard")
require("checkers.move")
---This will be the logic for the underlying AI for the computer player
---@class ai
---@field isRed boolean is the color or the pieces the player can move red
---@field turnsToLookAhead integer number of moves to look at before choosing a best move
ai = {}
---initializes a new ai player
---@param isRed boolean is the color or the pieces the player can move red
---@param turnsToLookAhead integer number of moves to look at before choosing a best move
---@return table
function ai.init(isRed, turnsToLookAhead)
    local self = table.deepCopy(ai)
    self.isRed = isRed
    self.turnsToLookAhead = turnsToLookAhead
    self.possibleMoves = {}
    return self
end

---@param board board
function ai:getPossibleNextMoves(board)
    possibleMoves = {}
    for _, possibleMove in pairs(board:getPossibleMoves()) do
        table.insert(possibleMoves, possibleMove)
    end
    return possibleMoves
end

function ai:evaluateBoard(board)
    score = 0

    for _, row in pairs(board.playArea) do
        for key, square in pairs(row) do
            if square.isRed ~= nil then
                local pieceScore = 0
                if square.pieceName == "basic" then
                    pieceScore = pieceScore + 10
                elseif square.pieceName == "king" then
                    pieceScore = pieceScore + 25
                end

                if square.isRed ~= self.isRed then
                    pieceScore = -pieceScore
                end
                score = score + pieceScore
            end
        end
    end

    return score
end
