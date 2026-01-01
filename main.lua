require("libs/luaes")

local player = {
    x = 76,
    y = 56,
    r = 4,
    c = 12,
    speed = 50
}

-- DEMO --
function _init()
    
end

function _update(dt)
    local dx, dy = 0, 0

    -- Use btn() for movement
    if btn(2) then dy = dy - 1 end -- up
    if btn(3) then dy = dy + 1 end -- down
    if btn(0) then dx = dx - 1 end -- left
    if btn(1) then dx = dx + 1 end -- right

    -- Normalize vector to prevent faster diagonal movement
    local length = math.sqrt(dx*dx + dy*dy)
    if length > 0 then
        dx = dx / length
        dy = dy / length
    end

    -- Update player position
    player.x = player.x + dx * player.speed * dt
    player.y = player.y + dy * player.speed * dt
end

function _draw()
    print("FPS: " .. gfps(), 10, 10, 4)
    circfill(player.x, player.y, player.r, player.c)
end