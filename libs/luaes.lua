local audio = require("libs/audio")

---------- table functions --------------
function add(t, v)
    t[#t + 1] = v
    return v
end

---------- math functions --------------
function mid(min, v, max)
    return math.max(min, math.min(max, v))
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

local lastPlayedTime = {}
local MIN_DELAY = 3/32

function sfx(index)
    local currentTime = os.clock()
    if lastPlayedTime[index] and (currentTime - lastPlayedTime[index] < MIN_DELAY) then
        return
    end
    lastPlayedTime[index] = currentTime
    
    if SOUNDS[index]:isPlaying() then
        SOUNDS[index]:stop()
        SOUNDS[index]:play()
    else
        SOUNDS[index]:play()
    end
end

---------- draw functions ----------------
local function hexToRGB(hex)
    hex = hex:gsub("#","")
    local r = tonumber(hex:sub(1,2), 16)/255
    local g = tonumber(hex:sub(3,4), 16)/255
    local b = tonumber(hex:sub(5,6), 16)/255
    return {r, g, b}
end

local PALETTE = {
    hexToRGB("#f4f4f4"), -- 0
    hexToRGB("#5d275d"), -- 1
    hexToRGB("#b13e53"), -- 2
    hexToRGB("#ef7d57"), -- 3
    hexToRGB("#ffcd75"), -- 4
    hexToRGB("#a7f070"), -- 5
    hexToRGB("#38b764"), -- 6
    hexToRGB("#257179"), -- 7
    hexToRGB("#29366f"), -- 8
    hexToRGB("#3b5dc9"), -- 9
    hexToRGB("#41a6f6"), -- 10
    hexToRGB("#73eff7"), -- 11
    hexToRGB("#94b0c2"), -- 12
    hexToRGB("#566c86"), -- 13
    hexToRGB("#333c57"), -- 14
    hexToRGB("#1a1c2c"), -- 15
}

local defaultColor = 1

local function setcolor(c)
    c = (c ~= nil and type(c) == "number") and c or defaultColor
    love.graphics.setColor(PALETTE[mid(0, c, 15)])
end

local function getRect(x0, y0, x1, y1)
    local x = math.min(x0, x1)
    local y = math.min(y0, y1)
    local w = math.abs(x1 - x0)
    local h = math.abs(y1 - y0)
    return x, y, w, h
end

function print(text, x, y, c)
    setcolor(c)
    love.graphics.print(text, x, y)
    setcolor()
end

function rect(x0, y0, x1, y1, c)
    setcolor(c)
    local x, y, w, h = getRect(x0, y0, x1, y1)
    love.graphics.rectangle("line", x, y, w, h)
    setcolor()
end

function rectfill(x0, y0, x1, y1, c)
    setcolor(c)
    local x, y, w, h = getRect(x0, y0, x1, y1)
    love.graphics.rectangle("fill", x, y, w, h)
    setcolor()
end

function line(x0, y0, x1, y1, c)
    setcolor(c)
    love.graphics.line(x0, y0, x1, y1)
    setcolor()
end

function circ(x, y, r, c)
    setcolor(c)
    love.graphics.circle("line", x, y, r)
    setcolor()
end

function circfill(x, y, r, c)
    setcolor(c)
    love.graphics.circle("fill", x, y, r)
    setcolor()
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
local scale = 4
local window_width = VIRTUAL_WIDTH*scale
local window_height = VIRTUAL_HEIGHT*scale
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
    love.window.setMode(window_width, window_height, {resizable = true, fullscreen = false, minwidth = VIRTUAL_WIDTH, minheight = VIRTUAL_HEIGHT})
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
    -- math functions --
    mid = mid,
    -- sfx functions --
    sfx    = sfx,
    -- system functions --
    gfps = gfps,
    -- draw functions --
    print = print,
    rect = rect,
    rectfill = rectfill,
    line = line,
    circ = circ,
    circfill = circfill,
    -- input functions --
    btn = btn,
    btnp = btnp,
    -- loop functions --
    _init = _init,
    _update = _update,
    _draw = _draw,
}