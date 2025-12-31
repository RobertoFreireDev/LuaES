require("libs/luaes")

-- DEMO --
function _init()
end

function _update(dt)
    if btn(4) or btnp(5) then
        sfx(1)
    end
end

function _draw()
    line(20, 80, 80, 120, 4)
    circ(10, 30, 20, 5)
    circfill(20, 30, 10, 6)
    line(50, 10, 60, 80)
    circ(100, 20, 40)
    circfill(120, 120, 20)
end