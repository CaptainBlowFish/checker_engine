dofile("checkerBoard.lua")
dofile("checkerPiece.lua")
dofile("move.lua")
dofile("helperFunctions.lua")


if os.getenv("LOVE2D_TOOLS") then pcall(require, "_love2d_tools_bridge") end

function love.load()
    game = board.init()
    game:setupCheckers()
    boardGraphics = {
        boardImage = love.graphics.newImage("graphics/checkerBoard.png"),
        redPieceImage = love.graphics.newImage("graphics/checker.png"),
        blackPieceImage = love.graphics.newImage("graphics/checkerAlt.png"),
        tileWidth = 40,
        tileHeight = 40,
        boarder = 10,
        pieceInset = 4

    }
end

function love.update(dt)

end

function love.draw()
    love.graphics.draw(boardGraphics.boardImage, 0, 0)
    for _, row in pairs(game.playarea) do
        for k, square in pairs(row) do
            if square.isRed ~= nil then
                if square.isRed then
                    love.graphics.draw(boardGraphics.redPieceImage,
                        (square.position.column - 1) * boardGraphics.tileWidth + boardGraphics.boarder +
                        boardGraphics.pieceInset,
                        (square.position.row - 1) * boardGraphics.tileHeight + boardGraphics.boarder +
                        boardGraphics.pieceInset)
                else
                    love.graphics.draw(boardGraphics.blackPieceImage,
                        (square.position.column - 1) * boardGraphics.tileWidth + boardGraphics.boarder +
                        boardGraphics.pieceInset,
                        (square.position.row - 1) * boardGraphics.tileHeight + boardGraphics.boarder +
                        boardGraphics.pieceInset)
                end
            end
        end
    end
end
