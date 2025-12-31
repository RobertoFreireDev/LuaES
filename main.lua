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
    print("!#$%&'()*+,-./0123456789:;", 10, 10)
    print("<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ", 10, 30)
    print("[^_`abcdefghijklmnopqrstuvwxyz{|}~", 10, 50)
    print("FPS: " .. gfps(), 140, 110)
end