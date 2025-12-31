require("libs/global")

-- DEMO --
function love.load()
    _loadsfxdata()
    FONT = love.graphics.getFont()
end

local pressed;

function love.update(dt)

    if love.mouse.isDown(1) or love.mouse.isDown(2) then
        if not pressed then
            sfx(1)
        end
    end
end

function love.mousereleased()
    pressed = false
end

function love.draw()
    print("test")
end