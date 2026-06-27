require("helperFunctions")

---@class boardGraphics holds the checkerBoard graphics
---@field boardImage love.Image
---@field backDrop love.Image
---@field redPieceImage love.Image
---@field blackPieceImage love.Image
---@field redKingPieceImage love.Image
---@field blackKingPieceImage love.Image
---@field yellowPieceImage love.Image
---@field xPos number
---@field yPos number
---@field tileWidth number
---@field tileHeight number
---@field boarderWidth number boarder width around board
---@field boarderHeight number boarder height around board
---@field pieceInsetW number
---@field pieceInsetH number
---@field width number width of board
---@field height number height of board
---@field scaleW number used to stretch or squish the board
---@field scaleH number used to stretch or sqush the board
---@field originalScreenWidth number
---@field originalScreenHeight number
boardGraphics = {
    backDrop = love.graphics.newImage("graphics/backDrop.png"),
    boardImage = love.graphics.newImage("graphics/checkerBoard.png"),
    redPieceImage = love.graphics.newImage("graphics/checker.png"),
    blackPieceImage = love.graphics.newImage("graphics/checkerAlt.png"),
    redKingPieceImage = love.graphics.newImage("graphics/checkerKing.png"),
    blackKingPieceImage = love.graphics.newImage("graphics/checkerKingAlt.png"),
    yellowPieceImage = love.graphics.newImage("graphics/checkerYellowed.png"),
    xPos = 0,
    yPos = 0,
    tileWidth = 40,
    tileHeight = 40,
    boarderWidth = 10,
    boarderHeight = 10,
    pieceInsetW = 4,
    pieceInsetH = 4,
    scaleW = 1,
    scaleH = 1
}
boardGraphics.width = boardGraphics.boardImage:getWidth()
boardGraphics.height = boardGraphics.boardImage:getWidth()

---@param screenWidth number
---@param screenHeight number
---@return boardGraphics
function boardGraphics.init(screenWidth, screenHeight)
    local self = table.deepCopy(boardGraphics)
    self.originalScreenWidth = screenWidth
    self.originalScreenHeight = screenHeight

    return self
end

---@param screenWidth number
---@param screenHeight number
function boardGraphics:resize(screenWidth, screenHeight)
    self.scaleW = screenWidth / self.originalScreenWidth
    self.scaleH = screenHeight / self.originalScreenHeight

    self.tileWidth = boardGraphics.tileWidth * self.scaleW
    self.tileHeight = boardGraphics.tileHeight * self.scaleH
    self.boarderWidth = boardGraphics.boarderWidth * self.scaleW
    self.boarderHeight = boardGraphics.boarderHeight * self.scaleH
    self.pieceInsetW = boardGraphics.pieceInsetW * self.scaleW
    self.pieceInsetH = boardGraphics.pieceInsetH * self.scaleH
    self.width = boardGraphics.width * self.scaleW
    self.height = boardGraphics.height * self.scaleH
    print("scaleW " .. self.scaleW)
    print("scaleH " .. self.scaleH)
    print("width  " .. screenWidth)
    print("height " .. screenHeight .. "\n")
end

---@param player player
---@param game board
function boardGraphics:drawHighlightedPieces(player, game)
    --- draw the highlights
    if player.selectedPiece:isPositive() and player.selectedPiece:lessThan(game.height, game.width) then
        local selected = game.playarea[player.selectedPiece.row][player.selectedPiece.column]
        if selected.isRed or not selected.isRed then
            local possibleMoves = selected:getPossibleMoves(game)

            for __, posMove in pairs(possibleMoves) do
                for _, step in pairs(posMove.steps) do
                    love.graphics.draw(self.yellowPieceImage,
                        self.xPos + (step.column - 1) * self.tileWidth +
                        self.boarderWidth +
                        self.pieceInsetW,
                        self.yPos + (step.row - 1) * self.tileHeight +
                        self.boarderHeight + self.pieceInsetH, nil,
                        self.scaleW, self.scaleH)
                end
            end
        end
    end
end

---@param game board
function boardGraphics:drawPieces(game)
    --- draw pieces
    for _, row in pairs(game.playarea) do
        for k, square in pairs(row) do
            if square.isRed ~= nil then
                local pieceImage = nil
                if square.isRed then
                    if square.pieceName == "king" then
                        pieceImage = self.redKingPieceImage
                    else
                        pieceImage = self.redPieceImage
                    end
                else
                    if square.pieceName == "king" then
                        pieceImage = self.blackKingPieceImage
                    else
                        pieceImage = self.blackPieceImage
                    end
                end
                love.graphics.draw(pieceImage,
                    self.xPos + (square.position.column - 1) * self.tileWidth +
                    self.boarderWidth +
                    self.pieceInsetW,
                    self.yPos + (square.position.row - 1) * self.tileHeight +
                    self.boarderHeight + self.pieceInsetH, nil,
                    self.scaleW, self.scaleH)
            end
        end
    end
end

function boardGraphics:drawBoard()
    love.graphics.draw(self.boardImage, self.xPos, self.yPos, nil,
        self.scaleW, self.scaleH)
end

function boardGraphics:drawBackground()
    love.graphics.draw(self.backDrop, self.xPos, self.yPos, nil,
        self.scaleW, self.scaleH)
end

function boardGraphics:drawStatisticsPannel()
    local textOffset = 10
    local capturedGraphicYOffset = 60
    local fontScale = 1 / 4
    local textSx = fontScale * self.scaleW
    local textSy = fontScale * self.scaleH

    --- black captured
    local x = self.width + self.xPos + (textOffset) * self.scaleW
    local y = self.yPos + capturedGraphicYOffset * self.scaleH + self.boarderHeight
    love.graphics.draw(self.blackPieceImage, x, y, nil,
        self.scaleW, self.scaleH)

    love.graphics.print("x" .. tostring(game.blackCaptured), x + self.tileWidth, y, nil,
        textSx, textSy)

    --- red captured
    y = y + self.tileHeight
    love.graphics.draw(self.redPieceImage, x, y, nil,
        self.scaleW, self.scaleH)

    love.graphics.print("x" .. tostring(game.redCaptured), x + self.tileWidth, y, nil,
        textSx, textSy)

    --- turn indicator
    local text = "Player "
    if game.redTurn then
        text = text .. "1"
    else
        text = text .. "2"
    end
    love.graphics.print(text, x, textOffset + self.yPos, nil, textSx, textSy)
end
