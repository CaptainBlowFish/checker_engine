dofile("checkerBoard.lua")
dofile("checkerPiece.lua")
dofile("move.lua")
dofile("helperFunctions.lua")

function love.load()
    game = board.init()
    game:setupCheckers()

    ---@class boardGraphics holds the checkerBoard graphics
    ---@field boardImage love.Image
    ---@field redPieceImage love.Image
    ---@field blackPieceImage love.Image
    ---@field xPos number
    ---@field yPos number
    ---@field tileWidth number
    ---@field tileHeight number
    ---@field boarder number
    ---@field pieceInset number
    ---@field width number
    ---@field height number
    boardGraphics = {
        boardImage = love.graphics.newImage("graphics/checkerBoard.png"),
        redPieceImage = love.graphics.newImage("graphics/checker.png"),
        blackPieceImage = love.graphics.newImage("graphics/checkerAlt.png"),
        yellowPieceImage = love.graphics.newImage("graphics/checkerYellowed.png"),
        xPos = 0,
        yPos = 0,
        tileWidth = 40,
        tileHeight = 40,
        boarder = 10,
        pieceInset = 4,
        width = 0,
        height = 0
    }
    boardGraphics.width = boardGraphics.boardImage:getWidth()
    boardGraphics.height = boardGraphics.boardImage:getHeight()
    ---@class player holds all info reguarding the player
    ---@field selectedPiece coordinate
    player = {
        selectedPiece = coordinate.init(-1, -1),
    }
end

function love.mousepressed(x, y, button)
    local mousePos = coordinate.init(
        math.ceil((y - boardGraphics.xPos - boardGraphics.boarder) / boardGraphics.tileWidth),
        math.ceil((x - boardGraphics.yPos - boardGraphics.boarder) / boardGraphics.tileHeight)
    )
    if button == 1 then
        --print("(" .. x, "," .. y .. ")")
        --print(table.tostring(mousePos))
        if player.selectedPiece:isPositive() and player.selectedPiece:lessThan(game.height, game.width) then
            if game.playarea[player.selectedPiece.row][player.selectedPiece.column].isRed ~= nil then
                if game:makeMove(player.selectedPiece, mousePos) then
                    --print("move Made")
                    player.selectedPiece.row = -1
                    player.selectedPiece.column = -1
                else
                    --print("\27[1m\27[31mMOVE NOT POSSIBLE!\27[0m")
                    player.selectedPiece.row = -1
                    player.selectedPiece.column = -1
                end
            elseif game.playarea[mousePos.row][mousePos.column].isRed ~= nil then
                player.selectedPiece = mousePos
                --print("piece chosen")
            else
                player.selectedPiece.row = -1
                player.selectedPiece.column = -1
            end
        else
            if game.playarea[mousePos.row][mousePos.column].isRed ~= nil then
                player.selectedPiece = mousePos
                --print("piece chosen")
            else
                player.selectedPiece.row = -1
                player.selectedPiece.column = -1
                --print("Pointer reset")
            end
        end
    end
end

function love.update(dt)

end

function love.draw()
    love.graphics.clear()
    --- board
    love.graphics.draw(boardGraphics.boardImage, boardGraphics.xPos, boardGraphics.yPos)

    --- draw the highlights
    if player.selectedPiece:isPositive() and player.selectedPiece:lessThan(game.height, game.width) then
        local selected = game.playarea[player.selectedPiece.row][player.selectedPiece.column]
        if selected.isRed or not selected.isRed then
            local possibleMoves = selected:getPossibleMoves(game)

            for __, posMove in pairs(possibleMoves) do
                for _, step in pairs(posMove.steps) do
                    love.graphics.draw(boardGraphics.yellowPieceImage,
                        boardGraphics.xPos + (step.column - 1) * boardGraphics.tileWidth +
                        boardGraphics.boarder +
                        boardGraphics.pieceInset,
                        boardGraphics.yPos + (step.row - 1) * boardGraphics.tileHeight +
                        boardGraphics.boarder + boardGraphics.pieceInset)
                end
            end
        end
    end

    --- draw pieces
    for _, row in pairs(game.playarea) do
        for k, square in pairs(row) do
            if square.isRed ~= nil then
                if square.isRed then
                    love.graphics.draw(boardGraphics.redPieceImage,
                        boardGraphics.xPos + (square.position.column - 1) * boardGraphics.tileWidth +
                        boardGraphics.boarder +
                        boardGraphics.pieceInset,
                        boardGraphics.yPos + (square.position.row - 1) * boardGraphics.tileHeight +
                        boardGraphics.boarder + boardGraphics.pieceInset)
                else
                    love.graphics.draw(boardGraphics.blackPieceImage,
                        boardGraphics.xPos + (square.position.column - 1) * boardGraphics.tileWidth +
                        boardGraphics.boarder +
                        boardGraphics.pieceInset,
                        boardGraphics.yPos + (square.position.row - 1) * boardGraphics.tileHeight +
                        boardGraphics.boarder + boardGraphics.pieceInset)
                end
            end
        end
    end
end
