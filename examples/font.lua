require("libs/luaes")

local idx = 1
local limit = 6
function _init()
    font(idx)
end

function _update(dt)
    if btnp(1) and idx < limit  then
        idx = idx + 1
        font(idx)
    elseif btnp(0) and idx > 1 then
        idx = idx - 1
        font(idx)
    end
end

function _draw()
    print("0123456789 {|}~", 0, 0, 4)
    print("!\"#$%&'()*+,-./", 0, 20, 4)
    print("ABCDEFGHIJKLMNO", 0, 40, 4)
    print("PQRSTUVWXYZ", 0, 60, 4)
    print("abcdefghijklmno", 0, 80, 4)
    print("pqrstuvwxyz", 0, 100, 4)
end