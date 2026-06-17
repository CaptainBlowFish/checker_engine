dofile("helperFunctions.lua")

---@class boardGraphics holds the checkerBoard graphics
---@field boardImage love.Image
---@field redPieceImage love.Image
---@field blackPieceImage love.Image
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
    boardImage = love.graphics.newImage("graphics/checkerBoard.png"),
    redPieceImage = love.graphics.newImage("graphics/checker.png"),
    blackPieceImage = love.graphics.newImage("graphics/checkerAlt.png"),
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
    scaleY = 1
}
boardGraphics.width = boardGraphics.boardImage:getWidth()
boardGraphics.height = boardGraphics.boardImage:getWidth()

---@param screenWidth number
---@param screenHeight number
---@return boardGraphics
function boardGraphics.init(screenWidth, screenHeight)
    local self = table.deepCopy(boardGraphics)
    self.prevScreenWidth = screenWidth
    self.prevScreenHeight = screenHeight

    return self
end

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
end
