require("libs/luaes")

-- DEMO --
function _init()
end

function _update(dt)
    if btn(4) or btnp(5) then
        sfx(2)
    end
end

function _draw()
    print("FPS: " .. gfps(), 10, 10, 4)
end