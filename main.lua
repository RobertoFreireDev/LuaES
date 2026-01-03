require("libs/luaes")

local player = {
    x = 76,
    y = 56,
    r = 4,
    c = 12,
    speed = 50
}

local SFX1 = {
  {note="C7", volume = 1,   length=0.25, wave=6, effect=5},
  {note="C7", volume = 0.8, length=0.25, wave=6, effect=5},
  {note="C7", volume = 0.7, length=0.25, wave=6, effect=5},
  {note="C7", volume = 0.6, length=0.25, wave=6, effect=5},
  {note="C7", volume = 0.4, length=0.25, wave=6, effect=5},
  {note="C7", volume = 0.4, length=0.25, wave=6, effect=5},
  {note="G6", volume = 0.8, length=0.25, wave=6, effect=5},
  {note="G6", volume = 0.6, length=0.25, wave=6, effect=5},
}

local SFX2 = {
  {note="C3", volume = 0.4,   length=0.25, wave=1, effect=8},
  {note="C3", volume = 0.2, length=0.25, wave=1, effect=8},
  {note="C3", volume = 0.4, length=0.25, wave=1, effect=8},
  {note="C3", volume = 0.2, length=0.25, wave=1, effect=8},
  {note="C3", volume = 0.4, length=0.25, wave=1, effect=8},
  {note="C3", volume = 0.2, length=0.25, wave=1, effect=8},
  {note="C3", volume = 0.1, length=0.25, wave=1, effect=8},
  {note=0, volume = 0.0, length=0.25, wave=0, effect=8},
}

local SFX3 = {
  {note="Ds2", volume = 0.2,   length=0.25, wave=7, effect=5},
  {note="C5", volume = 0.1, length=0.25, wave=7, effect=5},
  {note=0, volume = 0.0, length=0.25, wave=0, effect=5},
  {note="Ds2", volume = 0.1, length=0.25, wave=7, effect=5},
  {note="C5", volume = 0.2, length=0.25, wave=7, effect=5},
  {note="Ds4", volume = 0.1, length=0.25, wave=7, effect=5},
  {note="As4", volume = 0.2, length=0.25, wave=7, effect=5},
  {note="Ds2", volume = 0.1, length=0.25, wave=7, effect=5},
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
            { play = {1,2,3} },
            { stop = true }
          })
    end

    if btnp(5) then
      for i=1,8 do
        ssfx(i, SFX1[i].note, SFX1[i].volume, SFX1[i].wave, SFX1[i].effect, SFX1[i].length*16)
      end
      
      for i=1,8 do
        ssfx(i+16, SFX2[i].note, 10, SFX2[i].wave, SFX2[i].effect, SFX2[i].length*16)
      end

      for i=1,8 do
        ssfx(i+32, SFX3[i].note, 10, SFX3[i].wave, SFX3[i].effect, SFX3[i].length*16)
      end
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