require("libs/luaes")

local n,v,l,w,e ="C3",1,1,1,4

function addsounds()
  for i=1,16 do
    ssfx(i, n, v, w, e, l)
  end
end

function _init()
  addsounds()
  smusic(1,{{ play = {1} } , { stop = true }})
  font(2)
end

function _update(dt)
    if btnp(4) then
        sfx(1)
    end

    if btnp(1) and w < 8  then
        w = w + 1
        addsounds()
    elseif btnp(0) and w > 1 then
        w = w - 1
        addsounds()
    end

    if btnp(2) and e < 8 then
        e = e + 1
        addsounds()
    elseif btnp(3) and e > 0 then
        e = e - 1
        addsounds()
    end
end

local WAVES = {
    [1] = "triangle",
    [2] = "tilted saw",
    [3] = "saw",
    [4] = "square",
    [5] = "pulser",
    [6] = "organ",
    [7] = "noise",
    [8] = "phaser",
}

local EFFECTS = {
    [0] = "none",
    [1] = "slide",
    [2] = "vibrato",
    [3] = "drop",
    [4] = "fade_in",
    [5] = "fade_out",
    [6] = "fast arp",
    [7] = "slow arp",
    [8] = "tremolo",
}

function _draw()
    print("length: " ..l, 10, 10, 4)
    print("Wave: " ..WAVES[w], 10, 20, 4)
    print("Effects: " ..EFFECTS[e], 10, 30, 4)
end