---This contains the config settings for game

function love.conf(t)
    t.window.highdpi = true
    t.modules.physics = false
    t.window.title = "Checkers"
    t.window.icon = "graphics/checkerBoard.png"
end
