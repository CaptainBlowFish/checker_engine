if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

require("checkers.checkerBoard")
require("boardGraphics")
function love.load()
    game = board.init()
    game:setupCheckers()
    local screenWidth = 480
    local screenHeight = 340
    gameGraphics = boardGraphics.init(screenWidth, screenHeight)
    love.window.setMode(screenWidth, screenHeight, { resizable = true, vsync = false, minwidth = 480, minheight = 340 })

    ---font
    font = love.graphics.newImageFont("graphics/font.png",
        " abcdefghijklmnopqrstuvwxyz" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ" .. "0123456789.,!?'\"")
    love.graphics.setFont(font)

    ---@class player holds all info reguarding the player
    ---@field selectedPiece coordinate
    player = {
        selectedPiece = coordinate.init(-1, -1),
    }
end

function love.mousepressed(x, y, button)
    local mousePos = coordinate.init(
        math.ceil((y - gameGraphics.yPos - gameGraphics.boarderHeight) / gameGraphics.tileHeight),
        math.ceil((x - gameGraphics.xPos - gameGraphics.boarderWidth) / gameGraphics.tileWidth)
    )
    print("Row:" .. mousePos.row)
    print("Col:" .. mousePos.column)
    if button == 1 then
        if player.selectedPiece:isPositive() and player.selectedPiece:lessThan(game.height, game.width) then
            if game.playarea[player.selectedPiece.row][player.selectedPiece.column].isRed ~= nil then
                if game:makeMove(player.selectedPiece, mousePos) then
                    player.selectedPiece.row = -1
                    player.selectedPiece.column = -1
                else
                    player.selectedPiece.row = -1
                    player.selectedPiece.column = -1
                end
            elseif game.playarea[mousePos.row][mousePos.column].isRed ~= nil then
                player.selectedPiece = mousePos
            else
                player.selectedPiece.row = -1
                player.selectedPiece.column = -1
            end
        elseif mousePos:lessThan(game.height, game.width) then
            if game.playarea[mousePos.row][mousePos.column].isRed ~= nil then
                player.selectedPiece = mousePos
            else
                player.selectedPiece.row = -1
                player.selectedPiece.column = -1
            end
        end
    end
end

function love.update(dt)

end

function love.resize(w, h)
    local originalAspectRatio = gameGraphics.originalScreenWidth / gameGraphics.originalScreenHeight
    local newAspectRatio = w / h
    if originalAspectRatio > newAspectRatio then
        gameGraphics:resize(w, w / originalAspectRatio)
    elseif originalAspectRatio < newAspectRatio then
        gameGraphics:resize(h * originalAspectRatio, h)
    else
        gameGraphics:resize(w, h)
    end
end

function love.draw()
    love.graphics.clear()
    --- backdrop
    love.graphics.draw(gameGraphics.backDrop, gameGraphics.xPos, gameGraphics.yPos, nil,
        gameGraphics.scaleW, gameGraphics.scaleH)

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
                local pieceImage = nil
                if square.isRed then
                    if square.pieceName == "king" then
                        pieceImage = gameGraphics.redKingPieceImage
                    else
                        pieceImage = gameGraphics.redPieceImage
                    end
                else
                    if square.pieceName == "king" then
                        pieceImage = gameGraphics.blackKingPieceImage
                    else
                        pieceImage = gameGraphics.blackPieceImage
                    end
                end
                love.graphics.draw(pieceImage,
                    gameGraphics.xPos + (square.position.column - 1) * gameGraphics.tileWidth +
                    gameGraphics.boarderWidth +
                    gameGraphics.pieceInsetW,
                    gameGraphics.yPos + (square.position.row - 1) * gameGraphics.tileHeight +
                    gameGraphics.boarderHeight + gameGraphics.pieceInsetH, nil,
                    gameGraphics.scaleW, gameGraphics.scaleH)
            end
        end
    end

    --- UI/statistics
    do
        local textOffset = 10
        local capturedGraphicYOffset = 60
        local fontScale = 1 / 4
        local textSx = fontScale * gameGraphics.scaleW
        local textSy = fontScale * gameGraphics.scaleH

        --- black captured
        local x = gameGraphics.width + gameGraphics.xPos + (textOffset) * gameGraphics.scaleW
        local y = gameGraphics.yPos + capturedGraphicYOffset * gameGraphics.scaleH + gameGraphics.boarderHeight
        love.graphics.draw(gameGraphics.blackPieceImage, x, y, nil,
            gameGraphics.scaleW, gameGraphics.scaleH)

        love.graphics.print("x" .. tostring(game.blackCaptured), x + gameGraphics.tileWidth, y, nil,
            textSx, textSy)

        --- red captured
        y = y + gameGraphics.tileHeight
        love.graphics.draw(gameGraphics.redPieceImage, x, y, nil,
            gameGraphics.scaleW, gameGraphics.scaleH)

        love.graphics.print("x" .. tostring(game.redCaptured), x + gameGraphics.tileWidth, y, nil,
            textSx, textSy)

        --- turn indicator
        local text = "Player "
        if game.redTurn then
            text = text .. "1"
        else
            text = text .. "2"
        end
        love.graphics.print(text, x, textOffset + gameGraphics.yPos, nil, textSx, textSy)
    end
end
