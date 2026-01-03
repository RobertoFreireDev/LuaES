require("libs/luaes")

local player = {
    x = 76,
    y = 56,
    r = 4,
    c = 12,
    speed = 50
}

local SFX1 = {
  {note="C7", volume = 1,   length=6, wave=6, effect=5},
  {note="C7", volume = 0.8, length=6, wave=6, effect=5},
  {note="C7", volume = 0.7, length=6, wave=6, effect=5},
  {note="C7", volume = 0.6, length=6, wave=6, effect=5},
  {note="C7", volume = 0.4, length=6, wave=6, effect=5},
  {note="C7", volume = 0.4, length=6, wave=6, effect=5},
  {note="G6", volume = 0.8, length=6, wave=6, effect=5},
  {note="G6", volume = 0.6, length=6, wave=6, effect=5},
  {note="C7", volume = 1,   length=6, wave=6, effect=5},
  {note="C7", volume = 0.8, length=6, wave=6, effect=5},
  {note="C7", volume = 0.7, length=6, wave=6, effect=5},
  {note="C7", volume = 0.6, length=6, wave=6, effect=5},
  {note="C7", volume = 0.4, length=6, wave=6, effect=5},
  {note="C7", volume = 0.4, length=6, wave=6, effect=5},
  {note="G6", volume = 0.8, length=6, wave=6, effect=5},
  {note="G6", volume = 0.6, length=6, wave=6, effect=5},
}

local SFX2 = {
  {note="C3", volume = 0.4,   length=6, wave=1, effect=9},
  {note="C3", volume = 0.2, length=6, wave=1, effect=9},
  {note="C3", volume = 0.4, length=6, wave=1, effect=9},
  {note="C3", volume = 0.2, length=6, wave=1, effect=9},
  {note="C3", volume = 0.4, length=6, wave=1, effect=9},
  {note="C3", volume = 0.2, length=6, wave=1, effect=9},
  {note="C3", volume = 0.1, length=6, wave=1, effect=9},
  {note=0, volume = 0.0, length=6, wave=0, effect=9},
  {note="C3", volume = 0.4,   length=6, wave=1, effect=9},
  {note="C3", volume = 0.2, length=6, wave=1, effect=9},
  {note="C3", volume = 0.4, length=6, wave=1, effect=9},
  {note="C3", volume = 0.2, length=6, wave=1, effect=9},
  {note="C3", volume = 0.4, length=6, wave=1, effect=9},
  {note="C3", volume = 0.2, length=6, wave=1, effect=9},
  {note="C3", volume = 0.1, length=6, wave=1, effect=9},
  {note=0, volume = 0.0, length=6, wave=0, effect=9},
}

local SFX3 = {
  {note="Ds2", volume = 0.2,   length=6, wave=7, effect=5},
  {note="C5", volume = 0.1, length=6, wave=7, effect=5},
  {note=0, volume = 0.0, length=6, wave=0, effect=5},
  {note="Ds2", volume = 0.1, length=6, wave=7, effect=5},
  {note="C5", volume = 0.2, length=6, wave=7, effect=5},
  {note="Ds4", volume = 0.1, length=6, wave=7, effect=5},
  {note="As4", volume = 0.2, length=6, wave=7, effect=5},
  {note="Ds2", volume = 0.1, length=6, wave=7, effect=5},
  {note="Ds2", volume = 0.2,   length=6, wave=7, effect=5},
  {note="C5", volume = 0.1, length=6, wave=7, effect=5},
  {note=0, volume = 0.0, length=6, wave=0, effect=5},
  {note="Ds2", volume = 0.1, length=6, wave=7, effect=5},
  {note="C5", volume = 0.2, length=6, wave=7, effect=5},
  {note="Ds4", volume = 0.1, length=6, wave=7, effect=5},
  {note="As4", volume = 0.2, length=6, wave=7, effect=5},
  {note="Ds2", volume = 0.1, length=6, wave=7, effect=5},
}

local SFX4 = {
  {note="Fs6", volume = 1,   length=4, wave=4, effect=0},
  {note="B4", volume = 1, length=4, wave=5, effect=0},
  {note="B5", volume = 1, length=4, wave=4, effect=0},
  {note="F6", volume = 1, length=4, wave=5, effect=0},
  {note="Fs5", volume = 1, length=4, wave=4, effect=0},
  {note="B3", volume = 1, length=4, wave=5, effect=0},
  {note="Ds5", volume = 1, length=4, wave=4, effect=0},
  {note="G3", volume = 1, length=4, wave=5, effect=0},
}

local SFX5 = {
  {note="E3", volume = 1, length=6, wave=3, effect=0},
  {note="E3", volume = 1, length=6, wave=3, effect=0},
  {note="E3", volume = 1, length=6, wave=3, effect=0},
  {note="E3", volume = 1, length=6, wave=3, effect=0},
  {note="E3", volume = 1, length=6, wave=2, effect=0},
  {note="E3", volume = 1, length=6, wave=2, effect=0},
  {note="E3", volume = 1, length=6, wave=2, effect=0},
  {note="E3", volume = 1, length=6, wave=2, effect=0},
}

local SFX6 = {
  {note="Fs2", volume = 0.2, length=6, wave=5, effect=0},
  {note="Gs2", volume = 0.2, length=6, wave=5, effect=0},
  {note="A2", volume = 0.2, length=6, wave=5, effect=0},
  {note="B2", volume = 0.2, length=6, wave=5, effect=0},
  {note="As4", volume = 0.2, length=6, wave=5, effect=0},
  {note="Fs5", volume = 0.2, length=6, wave=5, effect=0},
  {note="C7", volume = 1, length=6, wave=7, effect=0},
  {note="B6", volume = 1, length=6, wave=7, effect=0},
  {note="B6", volume = 1, length=6, wave=7, effect=0},
  {note="A6", volume = 1, length=6, wave=7, effect=0},
  {note="Fs6", volume = 1, length=6, wave=7, effect=0},
  {note="D6", volume = 1, length=6, wave=7, effect=0},
  {note="A5", volume = 1, length=6, wave=7, effect=0},
  {note="E5", volume = 1, length=6, wave=7, effect=0},
  {note="C5", volume = 1, length=6, wave=7, effect=0},
  {note="A4", volume = 1, length=6, wave=7, effect=0},
}

local SFX7 = {
  {note="C7", volume = 1,   length=1, wave=6, effect=5},
  {note="C7", volume = 0.8, length=1, wave=6, effect=5},
  {note="C7", volume = 0.7, length=1, wave=6, effect=5},
  {note="C7", volume = 0.6, length=1, wave=6, effect=5},
  {note="C7", volume = 0.4, length=1, wave=6, effect=5},
  {note="C7", volume = 0.4, length=1, wave=6, effect=5},
  {note="G6", volume = 0.8, length=1, wave=6, effect=5},
  {note="G6", volume = 0.6, length=1, wave=6, effect=5},
}

local SFX8 = { 
  {note="C3", volume = 0.4,   length=1, wave=1, effect=9},
  {note="C3", volume = 0.2, length=1, wave=1, effect=9},
  {note="C3", volume = 0.4, length=1, wave=1, effect=9},
  {note="C3", volume = 0.2, length=1, wave=1, effect=9},
  {note="C3", volume = 0.4, length=1, wave=1, effect=9},
  {note="C3", volume = 0.2, length=1, wave=1, effect=9},
  {note="C3", volume = 0.1, length=1, wave=1, effect=9},
  {note=0, volume = 0.0, length=1, wave=0, effect=9},
}

local SFX9 = {
  {note="Ds2", volume = 0.2,   length=1, wave=7, effect=5},
  {note="C5", volume = 0.1, length=1, wave=7, effect=5},
  {note=0, volume = 0.0, length=1, wave=0, effect=5},
  {note="Ds2", volume = 0.1, length=1, wave=7, effect=5},
  {note="C5", volume = 0.2, length=1, wave=7, effect=5},
  {note="Ds4", volume = 0.1, length=1, wave=7, effect=5},
  {note="As4", volume = 0.2, length=1, wave=7, effect=5},
  {note="Ds2", volume = 0.1, length=1, wave=7, effect=5},
}

local SFX10 = {
  {note="Fs6", volume = 1,   length=1, wave=4, effect=0},
  {note="B4", volume = 1, length=1, wave=5, effect=0},
  {note="B5", volume = 1, length=1, wave=4, effect=0},
  {note="F6", volume = 1, length=1, wave=5, effect=0},
  {note="Fs5", volume = 1, length=1, wave=4, effect=0},
  {note="B3", volume = 1, length=1, wave=5, effect=0},
  {note="Ds5", volume = 1, length=1, wave=4, effect=0},
  {note="G3", volume = 1, length=1, wave=5, effect=0},
}

local SFX11 = {
  {note="E3", volume = 1, length=1, wave=3, effect=0},
  {note="E3", volume = 1, length=1, wave=3, effect=0},
  {note="E3", volume = 1, length=1, wave=3, effect=0},
  {note="E3", volume = 1, length=1, wave=3, effect=0},
  {note="E3", volume = 1, length=1, wave=2, effect=0},
  {note="E3", volume = 1, length=1, wave=2, effect=0},
  {note="E3", volume = 1, length=1, wave=2, effect=0},
  {note="E3", volume = 1, length=1, wave=2, effect=0},
}

local SFX12 = {
  {note="Fs2", volume = 0.2, length=1, wave=5, effect=0},
  {note="Gs2", volume = 0.2, length=1, wave=5, effect=0},
  {note="A2", volume = 0.2, length=1, wave=5, effect=0},
  {note="B2", volume = 0.2, length=1, wave=5, effect=0},
  {note="As4", volume = 0.2, length=1, wave=5, effect=0},
  {note="Fs5", volume = 0.2, length=1, wave=5, effect=0},
  {note="C7", volume = 1, length=1, wave=7, effect=0},
  {note="B6", volume = 1, length=1, wave=7, effect=0},
  {note="B6", volume = 1, length=1, wave=7, effect=0},
  {note="A6", volume = 1, length=1, wave=7, effect=0},
  {note="Fs6", volume = 1, length=1, wave=7, effect=0},
  {note="D6", volume = 1, length=1, wave=7, effect=0},
  {note="A5", volume = 1, length=1, wave=7, effect=0},
  {note="E5", volume = 1, length=1, wave=7, effect=0},
  {note="C5", volume = 1, length=1, wave=7, effect=0},
  {note="A4", volume = 1, length=1, wave=7, effect=0},
}

indexsound = 0
SOUNDINDEX = 5
SOUNDS = {
  {{ play = {1,2,3} }},
  {{ play = {2} } , { stop = true } },
  {{ play = {3} } , { stop = true } },
  {{ play = {4} } , { stop = true } },
  {{ play = {5} } , { stop = true } },
  {{ play = {6} } },
  {{ play = {7} } , { stop = true } },
  {{ play = {8} } , { stop = true } },
  {{ play = {9} } , { stop = true } },
  {{ play = {10} } , { stop = true } },
  {{ play = {11} } , { stop = true } },
  {{ play = {12} } , { stop = true } },
}

function addsounds(s)
  for i=1,#s do
    ssfx(i + indexsound, s[i].note, s[i].volume, s[i].wave, s[i].effect, s[i].length)
  end
  indexsound = indexsound + 16
end

function _init()
  addsounds(SFX1)
  addsounds(SFX2)
  addsounds(SFX3)
  addsounds(SFX4)
  addsounds(SFX5)
  addsounds(SFX6)
  addsounds(SFX7)
  addsounds(SFX8)
  addsounds(SFX9)
  addsounds(SFX10)
  addsounds(SFX11)
  addsounds(SFX12)

  for i=1,#SOUNDS do
    smusic(i,SOUNDS[i])
  end
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
        music(SOUNDINDEX)
    end

    if btnp(1) and SOUNDINDEX < #SOUNDS  then
        SOUNDINDEX = SOUNDINDEX + 1
    elseif btnp(0) and SOUNDINDEX > 1 then
        SOUNDINDEX = SOUNDINDEX - 1
    end
end

function _draw()    
    print("Ifx: " ..SOUNDINDEX, 10, 10, 4)
    print("FPS: " ..stat(1), 10, 10, 4)
    camera(cam_x, cam_y)
    rectfill(0,0,8,8,16)
    rectfill(144,104,160,120,3)
    spr(1, 1, player.x, player.y)
    circfill(player.x, player.y, player.r, player.c)
    resetcamera()
    local m = mouse()
    print(string.format("Mouse: x=%d y=%d",m.x, m.y), 10, 0, 4)
    local info = stat(10)
    local infoStr = string.format("w=%d h=%d sc=%d ox=%d oy=%d",info.x, info.y, info.scale, info.ofx, info.ofy)
    print(infoStr, 10, 50, 5)
    print(stat(2), 10, 40, 5)
    print(stat(3), 10, 50, 5)
    print(stat(4), 10, 60, 5)
    print(stat(5), 10, 70, 5)
    print(stat(6), 10, 80, 5)
    local local_time = stat(7)
    print(string.format("Local time: %02d:%02d:%02d", local_time.hour, local_time.min, local_time.sec), 10, 90, 5)
    local utc_time = stat(8)
    print(string.format("UTC time: %02d:%02d:%02d", utc_time.hour, utc_time.min, utc_time.sec), 10, 100, 5)
end