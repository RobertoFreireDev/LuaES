require("libs/luaes")

function _init()
end

function _update(dt)
end

function _draw()
    print("Text", 10, 10, 10, 2)
    rect(10, 30, 30, 20, 8, 2)
    rectfill(10, 60, 30, 20, 9, 1)
    line(60, 10, 70, 30, 10, 2)
    circ(100, 30, 10, 11, 1)
    circfill(100, 60, 10, 12, 2)
end