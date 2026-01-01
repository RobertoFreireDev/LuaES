require("libs/luaes")

local player = {
    x = 76,
    y = 56,
    r = 4,
    c = 12,
    speed = 50
}

function _init()
    
end

-- camera
dead_zone_w = 128
dead_zone_h = 92
screen_w = 160
screen_h = 120
cam_x = 0
cam_y = 0

function update_camera(o)
  local cx = cam_x + screen_w / 2
  local cy = cam_y + screen_h / 2

  local dx = o.x - cx
  local dy = o.y - cy

  if abs(dx) > dead_zone_w / 2 then
    cam_x = cam_x + dx - sgn(dx) * dead_zone_w / 2
  end

  if abs(dy) > dead_zone_h / 2 then
    cam_y = cam_y + dy - sgn(dy) * dead_zone_h / 2
  end
end

function _update(dt)
    local dx, dy = 0, 0

    if btn(2) then dy = dy - 1 end
    if btn(3) then dy = dy + 1 end
    if btn(0) then dx = dx - 1 end
    if btn(1) then dx = dx + 1 end

    local length = sqrt(dx*dx + dy*dy)
    if length > 0 then
        dx = dx / length
        dy = dy / length
    end

    player.x = player.x + dx * player.speed * dt
    player.y = player.y + dy * player.speed * dt

    update_camera(player)

    if btnp(4) then
        sfx(1)
    end

    if btnp(5) then
        exit()
    end
end

function _draw()    
    print("FPS: " ..stat(1), 10, 10, 4)
    camera(cam_x, cam_y)
    rectfill(0,0,16,16,8)
    rectfill(144,104,160,120,3)
    circfill(player.x, player.y, player.r, player.c)
    resetcamera()
    local m = mouse()
    print(string.format("Mouse: x=%d y=%d",m.x, m.y), 10, 20, 4)
    local info = stat(10)
    local infoStr = string.format("w=%d h=%d sc=%d ox=%d oy=%d",info.x, info.y, info.scale, info.ofx, info.ofy)

    print(infoStr, 10, 50, 5)

    -- print(stat(2), 10, 40, 5)
    -- print(stat(3), 10, 50, 5)
    -- print(stat(4), 10, 60, 5)
    -- print(stat(5), 10, 70, 5)
    -- print(stat(6), 10, 80, 5)
    -- local local_time = stat(7)
    -- print(string.format("Local time: %02d:%02d:%02d", local_time.hour, local_time.min, local_time.sec), 10, 90, 5)
    -- local utc_time = stat(8)
    -- print(string.format("UTC time: %02d:%02d:%02d", utc_time.hour, utc_time.min, utc_time.sec), 10, 100, 5)
end