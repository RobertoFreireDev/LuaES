require("libs/luaes")

local imageIndex = 1

function _init()
    for y = 1, 8 do
        for x = 1, 8 do
            local color = ((x + y) % 16) + 1
            spixel(imageIndex, x, y, color)
        end
    end

    for y = 1, 8 do
        for x = 1, 8 do
            local color = ((x * y) % 16) + 1
            spixel(imageIndex, x + 8, y, color)
        end
    end
end

function _update(dt)
    if btnp(4) or btnp(5) then
        save()
    end
end

function _draw()
    spr(1, 1, 20, 40)
    spr(1, 1, 20, 60, 1, 1, false, false, 12, 6)
    spr(1, 1, 20, 80, 1, 1, false, false, 4, 10)
end