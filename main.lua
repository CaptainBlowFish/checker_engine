if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

require("checkers.checkerBoard")
require("drawing.boardGraphics")

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
    gameGraphics:drawBackground()
    gameGraphics:drawBoard()
    gameGraphics:drawHighlightedPieces(player, game)
    gameGraphics:drawPieces(game)
    gameGraphics:drawStatisticsPannel()
end
