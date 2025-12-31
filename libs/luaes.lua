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
     if SOUNDS[index]:isPlaying() then
        SOUNDS[index]:stop()
        SOUNDS[index]:play()
    else
        SOUNDS[index]:play()
    end
end

---------- draw functions ----------------
function print(text, x, y, color)
    color = color or {1, 1, 1} -- default white
    love.graphics.setColor(color)
    love.graphics.print(text, x, y)
    love.graphics.setColor(1, 1, 1) -- reset to white
end

---------- system functions ----------------
function gfps()
    return love.timer.getFPS()
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
local VIRTUAL_WIDTH = 160
local VIRTUAL_HEIGHT = 120
local window_width, window_height = VIRTUAL_WIDTH, VIRTUAL_HEIGHT
local scale
local offsetX, offsetY

_init = function() end
_update = function(dt) end
_draw = function() end

function love.resize(w, h)
    window_width = w
    window_height = h
    updateScale()
end

function updateScale()
    local scaleXRaw = math.floor(window_width / VIRTUAL_WIDTH)
    local scaleYRaw = math.floor(window_height / VIRTUAL_HEIGHT)
    scale = math.min(scaleXRaw, scaleYRaw)
    offsetX = (window_width - VIRTUAL_WIDTH * scale) / 2
    offsetY = (window_height - VIRTUAL_HEIGHT * scale) / 2
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {resizable = true, fullscreen = false, minwidth = VIRTUAL_WIDTH, minheight = VIRTUAL_HEIGHT})
    love.graphics.setFont(love.graphics.newFont("fonts/Pixelzone.ttf", 16))
    updateScale()
    loadsfxdata()
    _init()
end

function love.update(dt)
    _update(dt)
    updatePrevKeys()
end

function love.draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setScissor(offsetX, offsetY, scale*VIRTUAL_WIDTH, scale*VIRTUAL_HEIGHT)
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale, scale)

    _draw()

    love.graphics.pop()
    love.graphics.setScissor()
end

return {
    -- table functions --
    add    = add,
    -- sfx functions --
    sfx    = sfx,
    -- system functions --
    gfps = gfps,
    -- draw functions --
    print = print,
    -- input functions --
    btn = btn,
    btnp = btnp,
    -- loop functions --
    _init = _init,
    _update = _update,
    _draw = _draw,
}