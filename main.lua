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

delay = 1

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
        music({
            { play = {1} },
            { next = 3 },
            { play = {2} },
            --{ stop = true },
            { play = {1,2} }
          })
    end

    if btnp(5) then
        ssfx(1, "B2", 10, 2, 0, 12)
        ssfx(2, "C2", 10, 2, 0, 12)
        ssfx(3, "D2", 10, 2, 0, 12)
        ssfx(4, "E2", 10, 2, 0, 12)
        ssfx(5, "D2", 10, 2, 0, 12)
        ssfx(6, "C2", 10, 2, 0, 12)
        ssfx(7, "B2", 10, 2, 0, 16)
        ssfx(8, "E2", 10, 2, 0, 16)
        ssfx(9, "B2", 10, 2, 0, 12)
        ssfx(10, "C2", 10, 2, 0, 12)
        ssfx(11, "D2", 10, 2, 0, 12)
        ssfx(12, "E2", 10, 2, 0, 12)
        ssfx(13, "D2", 10, 2, 0, 12)
        ssfx(14, "C2", 10, 2, 0, 12)
        ssfx(15, "B2", 10, 2, 0, 16)
        ssfx(16, "E2", 10, 2, 0, 16)

        ssfx(17, "C3", 10, 2, 0, 12)
        ssfx(18, "D3", 10, 2, 0, 12)
        ssfx(19, "D3", 10, 2, 0, 12)
        ssfx(20, "F3", 10, 2, 0, 12)
        ssfx(21, "A4", 10, 1, 0, 12)
        ssfx(22, "A4", 10, 1, 0, 12)
        ssfx(23, "A4", 10, 1, 2, 16)
        ssfx(24, "F4", 10, 3, 0, 16)
        ssfx(25, "F4", 10, 3, 0, 16)
        ssfx(26, "B3", 10, 3, 3, 12)
        ssfx(27, "C3", 10, 3, 0, 12)
        ssfx(28, "D3", 10, 2, 0, 12)
        ssfx(29, "C3", 10, 2, 1, 12)
        ssfx(30, "D3", 10, 3, 0, 12)
        ssfx(31, "A3", 10, 3, 4, 12)
        ssfx(32, "B3", 10, 3, 0, 16)
        
        ssfx(33, "E2", 10, 2, 0, 12)
        ssfx(34, "G2", 10, 2, 0, 12)
        ssfx(35, "A2", 10, 2, 0, 12)
        ssfx(36, "B2", 10, 2, 0, 12)
        ssfx(37, "A2", 10, 2, 0, 12)
        ssfx(38, "G2", 10, 2, 0, 12)
        ssfx(39, "E2", 10, 2, 0, 16)
        ssfx(40, "B2", 10, 2, 0, 16)
        ssfx(41, "E3", 10, 2, 0, 12)
        ssfx(42, "G3", 10, 2, 0, 12)
        ssfx(43, "A3", 10, 2, 0, 12)
        ssfx(44, "B3", 10, 2, 0, 12)
        ssfx(45, "A3", 10, 2, 0, 12)
        ssfx(46, "G3", 10, 2, 0, 12)
        ssfx(47, "E3", 10, 2, 1, 16)
        ssfx(48, "B3", 10, 2, 2, 16)

        ssfx(49, "C3", 10, 4, 0, 12)
        ssfx(50, "D3", 10, 4, 0, 12)
        ssfx(51, "E3", 10, 4, 0, 12)
        ssfx(52, "G3", 10, 4, 0, 12)
        ssfx(53, "E3", 10, 4, 0, 12)
        ssfx(54, "D3", 10, 4, 0, 12)
        ssfx(55, "C3", 10, 4, 1, 16)
        ssfx(56, "G2", 10, 4, 2, 16)
        ssfx(57, "C4", 10, 1, 0, 12)
        ssfx(58, "D4", 10, 1, 0, 12)
        ssfx(59, "E4", 10, 1, 0, 12)
        ssfx(60, "G4", 10, 1, 0, 12)
        ssfx(61, "A4", 10, 1, 0, 12)
        ssfx(62, "G4", 10, 1, 0, 12)
        ssfx(63, "E4", 10, 1, 3, 16)
        ssfx(64, "C4", 10, 1, 4, 24)
    end
end

function _draw()
    --print("FPS: " ..stat(1), 10, 10, 4)
    camera(cam_x, cam_y)
    --rectfill(0,0,8,8,16)
    --rectfill(144,104,160,120,3)
    --spr(1, 1, player.x, player.y)
    circfill(player.x, player.y, player.r, player.c)
    resetcamera()
    --local m = mouse()
    --print(string.format("Mouse: x=%d y=%d",m.x, m.y), 10, 0, 4)
    --local info = stat(10)
    --local infoStr = string.format("w=%d h=%d sc=%d ox=%d oy=%d",info.x, info.y, info.scale, info.ofx, info.ofy)
    --print(infoStr, 10, 50, 5)
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