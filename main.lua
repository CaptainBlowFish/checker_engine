dofile("checkerBoard.lua")
dofile("checkerPiece.lua")
dofile("move.lua")
dofile("helperFunctions.lua")
dofile("boardGraphics.lua")
function love.load()
    game = board.init()
    game:setupCheckers()
    local screenWidth = 480
    local screenHeight = 340
    love.window.setMode(screenWidth, screenHeight, { resizable = true, vsync = false, minwidth = 480, minheight = 340 })
    gameGraphics = boardGraphics.init(screenWidth, screenHeight)

    ---@class player holds all info reguarding the player
    ---@field selectedPiece coordinate
    player = {
        selectedPiece = coordinate.init(-1, -1),
    }
end

function love.mousepressed(x, y, button)
    local mousePos = coordinate.init(
        math.ceil((y - gameGraphics.xPos - gameGraphics.boarderWidth) / gameGraphics.tileWidth),
        math.ceil((x - gameGraphics.yPos - gameGraphics.boarderHeight) / gameGraphics.tileHeight)
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
        elseif mousePos:lessThan(game.height, game.width) then
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

function love.resize(w, h)
    gameGraphics:resize(w, h)
end

function love.draw()
    love.graphics.clear()
    --- board
    love.graphics.draw(gameGraphics.boardImage, gameGraphics.xPos, gameGraphics.yPos, nil,
        gameGraphics.scaleW, gameGraphics.scaleH)

    --- draw the highlights
    if player.selectedPiece:isPositive() and player.selectedPiece:lessThan(game.height, game.width) then
        local selected = game.playarea[player.selectedPiece.row][player.selectedPiece.column]
        if selected.isRed or not selected.isRed then
            local possibleMoves = selected:getPossibleMoves(game)

            for __, posMove in pairs(possibleMoves) do
                for _, step in pairs(posMove.steps) do
                    love.graphics.draw(gameGraphics.yellowPieceImage,
                        gameGraphics.xPos + (step.column - 1) * gameGraphics.tileWidth +
                        gameGraphics.boarderWidth +
                        gameGraphics.pieceInsetW,
                        gameGraphics.yPos + (step.row - 1) * gameGraphics.tileHeight +
                        gameGraphics.boarderHeight + gameGraphics.pieceInsetH, nil,
                        gameGraphics.scaleW, gameGraphics.scaleH)
                end
            end
        end
    end

    --- draw pieces
    for _, row in pairs(game.playarea) do
        for k, square in pairs(row) do
            if square.isRed ~= nil then
                if square.isRed then
                    love.graphics.draw(gameGraphics.redPieceImage,
                        gameGraphics.xPos + (square.position.column - 1) * gameGraphics.tileWidth +
                        gameGraphics.boarderWidth +
                        gameGraphics.pieceInsetW,
                        gameGraphics.yPos + (square.position.row - 1) * gameGraphics.tileHeight +
                        gameGraphics.boarderHeight + gameGraphics.pieceInsetH, nil,
                        gameGraphics.scaleW, gameGraphics.scaleH)
                else
                    love.graphics.draw(gameGraphics.blackPieceImage,
                        gameGraphics.xPos + (square.position.column - 1) * gameGraphics.tileWidth +
                        gameGraphics.boarderWidth +
                        gameGraphics.pieceInsetW,
                        gameGraphics.yPos + (square.position.row - 1) * gameGraphics.tileHeight +
                        gameGraphics.boarderHeight + gameGraphics.pieceInsetH, nil,
                        gameGraphics.scaleW, gameGraphics.scaleH)
                end
            end
        end
    end
end
