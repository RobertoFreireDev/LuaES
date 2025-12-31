local audio = require("libs/audio")

---------- table functions --------------
function add(t, v)
    t[#t + 1] = v
    return v
end

---------- sfx functions ----------------
local SFX = {}  -- 128 indexes x 16 notes

local SOUNDS = {} -- 128 sounds.

local function parseSFX(str, length)
    local tone     = str:sub(1, 3):gsub("X", "")
    local volume   = tonumber(str:sub(4, 5))
    local waveType = tonumber(str:sub(6, 6))
    local effects  = tonumber(str:sub(7, 7))

    return {
        tone = tone,
        volume = volume,
        waveType = waveType,
        effects = effects,
        length = length
    }
end

local function loadsfxdata()
    local soundIndex = 1
    for line in io.lines("data/sfx.txt") do
        local CHUNK_SIZE = 7
        local chunks = {}
        local sfxlength = line:sub(-2)
        local main = line:sub(1, -3)
        for i = 1, #main, CHUNK_SIZE do
            add(chunks, main:sub(i, i + CHUNK_SIZE - 1))
        end
        
        local newsound = {}
        for i = 1, #chunks do
            local sfxIdx = (soundIndex-1)*16 + i
            SFX[sfxIdx] = parseSFX(chunks[i], sfxlength)
            add(newsound,SFX[sfxIdx])
        end
        SOUNDS[soundIndex] = audio.genMusic(newsound)
        
        soundIndex = soundIndex + 1
    end
end

function sfx(index)
    SOUNDS[index]:play()
end

---------- button functions ----------------

local btnKeys = {
    [0] = "left",
    [1] = "right",
    [2] = "up",
    [3] = "down",
    [4] = "z",
    [5] = "x"
}

local prevKeys = {}

local function updatePrevKeys()
    prevKeys = {}
    for i = 0, 5 do
        prevKeys[i] = love.keyboard.isDown(btnKeys[i])
    end
end

function btn(n)
    local key = btnKeys[n]
    if not key then return false end
    return love.keyboard.isDown(key)
end

function btnp(n)
    local key = btnKeys[n]
    if not key then return false end
    return love.keyboard.isDown(key) and not prevKeys[n]
end

---------- main functions ----------------
_init = function() end
_update = function(dt) end
_draw = function() end

function love.load()
    loadsfxdata()
    _init()
end

function love.update(dt)
    _update(dt)
    updatePrevKeys()
end

function love.draw()
    _draw()
end

return {
    -- table functions --
    add    = add,
    -- sfx functions --
    sfx    = sfx,
    -- input functions --
    btn = btn,
    btnp = btnp,
    -- loop functions --
    _init = _init,
    _update = _update,
    _draw = _draw,
}