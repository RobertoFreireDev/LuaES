require("libs/luaes")

-- DEMO --
function _init()
end

function _update(dt)
    if btnp(4) then
        sfx(1)
    end

    if btnp(5) then
        save()
    end
end

function _draw()
    print("FPS: " .. gfps(), 10, 10, 4)
end