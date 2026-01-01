require("libs/luaes")

-- DEMO --
function _init()
    cdata("test")
end

function _update(dt)
    if btnp(4) then
        sfx(1)
    end

    if btnp(5) then
        sdata(2,10)
    end
end

function _draw()
    print("FPS: " .. gfps(), 10, 10, 4)
    print("data: " .. gdata(2), 10, 30, 4)
end