require("libs/luaes")

-- DEMO --
function _init()
    FONT = love.graphics.getFont()
end

local pressed;

function _update(dt)
    if btnp(4) or btnp(5) then
        if not pressed then
            sfx(1)
        end
    end
end

function love.mousereleased()
    pressed = false
end

function _draw()
end