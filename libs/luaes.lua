local audio = require("libs/audio")
local bit = require("bit")
local sfxdata = require("data/sfx")
local emptycartdata = require("data/emptycartdata")

---------- table functions --------------
function add(t, v)
    t[#t + 1] = v
    return v
end

function del(tbl, val)
    for i = #tbl, 1, -1 do
        if tbl[i] == val then
            table.remove(tbl, i)
            return val
        end
    end
    return nil
end

function foreach(tbl, func)
    for i, v in ipairs(tbl) do
        func(v, i)
    end
end

function all(tbl)
    local t = {}
    for i, v in ipairs(tbl) do
        t[i] = v
    end
    return t
end

---------- math functions --------------
function floor(v)
    return math.floor(v)
end

function min(v)
    return math.min(v)
end

function mid(min, v, max)
    return math.max(min, math.min(max, v))
end

function sgn(x)
    if x > 0 then return 1
    elseif x < 0 then return -1
    else return 0
    end
end

function abs(x) 
    return x < 0 and -x or x
end

function ceil(x)
    return math.ceil(x)
end

function rnd(x)
    if x then
        return love.math.random() * x
    else
        return love.math.random()
    end
end

function srnd(x)
    love.math.setRandomSeed(x)
end

function sqrt(x)
    return math.sqrt(x)
end

function sin(x)
    return math.sin(x)
end

function cos(x)
    return math.cos(x)
end

function atan2(y, x)
    return math.atan2(y, x)
end

function max(a, b)
    return math.max(a, b)
end

function band(a, b)
    return bit.band(a, b)
end

function bor(a, b)
    return bit.bor(a, b)
end

function bxor(a, b)
    return bit.bxor(a, b)
end

function shl(a, n)
    return bit.lshift(a, n)
end

function shr(a, n)
    return bit.rshift(a, n)
end

---------- io functions --------------
local function loadFile(filename)
    return io.lines(filename..".txt")
end

local function saveFile(filename, content)
    local file, err = io.open(filename..".txt", "w")
    assert(file, err)
    file:write(content)
    file:close()
end

local function fileExists(filename)
    local f = io.open(filename..".txt", "r")
    if f then
        f:close()
        return true
    end
    return false
end

local function createIfDoesntExist(filename, content)
    if not fileExists(filename) then
        local f, err = io.open(filename..".txt", "w")
        assert(f, "Failed to create file: " .. (err or "unknown error"))
        f:write(content)
        f:close()
    end
end

---------- sfx functions ----------------
local SFX = {}  -- X indexes x 16 notes
local SOUNDS = {} -- X sounds.
local LUAESSFXDATA = "luaessfxdata"

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
    createIfDoesntExist(LUAESSFXDATA, sfxdata)
    local lines = loadFile(LUAESSFXDATA)
    local soundIndex = 1

    for line in lines do
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

local function buildSFX(data)
    local tone = data.tone or ""

    if tone == "" or #tone == 1 then
        tone = "XX0"
    elseif #tone == 2 then
        tone = ("X"..data.tone)
    end

    local volume = string.format("%02d", tonumber(data.volume) or 0)
    local waveType = tostring(tonumber(data.waveType) or 0)
    local effects  = tostring(tonumber(data.effects) or 0)
    return tone .. volume .. waveType .. effects
end

local function savesfxdata()
    local lines = {}
    local count = #SFX/16

    for i = 1, count do
        local line = ""

        for j = 1, 16 do
            local sfxIdx = (i - 1) * 16 + j
            line = line .. buildSFX(SFX[sfxIdx])
        end

        local length = SFX[(i - 1) * 16 + 1].length
        line = line .. string.format("%02d", tonumber(length) or 0)
        add(lines, line)
    end
    local content = table.concat(lines, "\n")
    saveFile(LUAESSFXDATA, content)
end

local lastPlayedTime = {}
local MIN_DELAY = 2/32

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

function ssfx(index, t, v, w, e, l)
    -- lentgth must be the same for all notes of the same sound
    local soundIndex = floor(index/16) + 1
    local newsound = {}
    local startIndex = floor(index/16)*16 + 1
    for i=startIndex,startIndex+15 do
        if index == i then
            SFX[i] = {
                tone = t,
                volume = v,
                waveType = w,
                effects = e,
                length = l
            }
        else
            SFX[i].length = l
        end
        add(newsound,SFX[i])
    end
    SOUNDS[soundIndex] = audio.genMusic(newsound)
end

---------- camera functions ----------------
--- Always resetcamera in the same frame if camera function was called
function camera(x, y)
    love.graphics.push()
    love.graphics.translate(-x, -y)
end

-- reset camera
function resetcamera()
    love.graphics.pop()
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
    local x = min(x0, x1)
    local y = min(y0, y1)
    local w = abs(x1 - x0)
    local h = abs(y1 - y0)
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

---------- status functions ----------------
function stat(n)
    if n == 1 then
        return love.timer.getFPS()
    elseif n == 2 then
        return collectgarbage("count")
    elseif n == 3 then
        return love.graphics.getWidth()     
    elseif n == 4 then
        return love.graphics.getHeight()
    elseif n == 5 then
        return love.system.getOS()
    elseif n == 6 then -- Seconds afte application started
        return love.timer.getTime()
    elseif n == 7 then -- Local time as table        
        return os.date("*t")
    elseif n == 8 then -- UTC time as table
        return os.date("!*t")
    else
        return nil
    end
end

---------- button functions ----------------
local btnKeys = {
    [0] = {"left","a"}, -- left
    [1] = {"right","d"}, -- right
    [2] = {"up","w"}, -- up
    [3] = {"down","s"}, -- down
    [4] = {"lshift","x"}, -- b
    [5] = {"z"}, -- a
    [6] = {"space","c"}, -- x
    [7] = {"b","v"}, -- y
    [8] = {"return"} -- start
}

local prevKeys = {}

local function updatePrevKeys()
    prevKeys = {}
    for i = 0, 5 do
        prevKeys[i] = love.keyboard.isDown(btnKeys[i])
    end
end

function btn(n)
    local keys = btnKeys[n]
    if not keys then return false end

    for i = 1, #keys do
        if love.keyboard.isDown(keys[i]) then
            return true
        end
    end
end

function btnp(n) 
    local keys = btnKeys[n] 
    if not keys then return false end

    for i = 1, #keys do 
        if love.keyboard.isDown(keys[i]) and not prevKeys[n] then
            return true
        end
    end
end

---------- save game functions ----------------
local cartDataName = "cartdata_"

function cdata(name)
    if cartDataName ~= "cartdata_" then
        error("calling cdata function multiple times")
        return
    end

    cartDataName = cartDataName .. name
end

function gdata(index)
    if cartDataName == "cartdata_" then
        error("call cdata function to set name of cart data")
        return
    end

    createIfDoesntExist(cartDataName, emptycartdata)

    local lines = loadFile(cartDataName)
    local lineIndex = 1
    for line in lines do
        if lineIndex == index then
            return line
        end
        lineIndex = lineIndex + 1
    end

    return ""
end

function sdata(index, value)
    index = (index ~= nil and type(index) == "number") and index or ""

    if cartDataName == "cartdata_" then
        error("call cdata function to set name of cart data")
        return
    end

    createIfDoesntExist(cartDataName, emptycartdata)

    local lines = loadFile(cartDataName)
    local lineIndex = 1
    local newLines =  {}
    for line in lines do
        if lineIndex == index then
            add(newLines, value)
        else
            add(newLines, line)
        end
        lineIndex = lineIndex + 1        
    end

    local content = table.concat(newLines, "\n")
    saveFile(cartDataName, content)
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
    local scaleXRaw = floor(window_width / VIRTUAL_WIDTH)
    local scaleYRaw = floor(window_height / VIRTUAL_HEIGHT)
    scale = min(scaleXRaw, scaleYRaw)
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

function save()
    savesfxdata()
end

return {
    -- table functions --
    add    = add,
    -- math functions --
    mid    = mid,
    sgn    = sgn,
    abs    = abs,
    floor  = floor,
    ceil   = ceil,
    rnd    = rnd,
    srnd   = srnd,
    sqrt   = sqrt,
    sin    = sin,
    cos    = cos,
    atan2  = atan2,
    max    = max,
    min    = min,
    band   = band,
    bor    = bor,
    bxor   = bxor,
    shl    = shl,
    shr    = shr,
    -- sfx functions --
    sfx    = sfx,
    ssfx   = ssfx,
    -- system functions --
    stat = stat,
    save = save,
    -- save game functions --
    sdata = sdata,
    gdata = gdata,
    cdata = cdata,
    -- camera functions --
    camera = camera,
    resetcamera = resetcamera,
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