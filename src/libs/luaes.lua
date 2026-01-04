local audio = require("libs/audio")
local bit = require("bit")
local sfxdata = require("data/sfx")
local spritesheetsdata = require("data/spritesheet")
local emptycartdata = require("data/emptycartdata")

--#region global variables
local VIRTUAL_WIDTH = 160
local VIRTUAL_HEIGHT = 120
local scale = 4
local window_width = VIRTUAL_WIDTH*scale
local window_height = VIRTUAL_HEIGHT*scale
local offsetX, offsetY
--#endregion

--#region colors
local function hexToRGB(hex, alfa)
    alfa = alfa ~= nil and alfa or "FF"
    hex = hex:gsub("#","")
    local r = tonumber(hex:sub(1,2), 16)/255
    local g = tonumber(hex:sub(3,4), 16)/255
    local b = tonumber(hex:sub(5,6), 16)/255
    local a = tonumber(alfa, 16) / 255
    return {r, g, b, a}
end

local COLORPALETTE = {
    [1] = "#f4f4f4",
    [2] = "#000000",
    [3] = "#5d275d",
    [4] = "#b13e53",
    [5] = "#ef7d57",
    [6] = "#ffcd75",
    [7] = "#a7f070",
    [8] = "#38b764",
    [9] = "#257179",
    [10] = "#29366f",
    [11] = "#3b5dc9",
    [12] = "#41a6f6",
    [13] = "#73eff7",
    [14] = "#94b0c2",
    [15] = "#566c86",
    [16] = "#6b4226"
}

local defaultColor = 1

local function getpalette(i, a)
    i = mid(0, i, 16)
    if i <= 0 then
        return hexToRGB("#000000","00") -- transparent
    end

    return hexToRGB(COLORPALETTE[i], a)
end

function alphaToHex(v)
    v = (v ~= nil and type(v) == "number") and v or 10
    v = mid(0,v,10)
    return string.format("%02X", floor((v / 10) * 255 + 0.5))
end

local function setcolor(c,a)
    c = (c ~= nil and type(c) == "number") and c or defaultColor
    love.graphics.setColor(getpalette(c,alphaToHex(a)))
end
--#endregion

--#region table
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
--#endregion

--#region math
function floor(v)
    return math.floor(v)
end

function min(a, b)
    return math.min(a, b)
end

function max(a, b)
    return math.max(a, b)
end

function mid(a, v, b)
    return max(a, min(b, v))
end

function sgn(x)
    if x > 0 then return 1
    elseif x < 0 then return -1
    else return 0
    end
end

function abs(x)
    return math.abs(x)
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
--#endregion

--#region io
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
--#endregion

--#region sfx
local SFX = {}  -- X indexes x 16 notes
local SOUNDS = {} -- X sounds.
local LUAESSFXDATA = "luaessfxdata"

local function parseSFX(str)
    local tone     = str:sub(1, 3):gsub("X", "")
    local volume   = tonumber(str:sub(4, 5))
    local waveType = tonumber(str:sub(6, 6))
    local effects  = tonumber(str:sub(7, 7))
    local length  = tonumber(str:sub(8, 9))

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
        local CHUNK_SIZE = 9
        local chunks = {}
        for i = 1, #line, CHUNK_SIZE do
            add(chunks, line:sub(i, i + CHUNK_SIZE - 1))
        end
        
        local newsound = {}
        for i = 1, #chunks do
            local sfxIdx = (soundIndex-1)*16 + i
            SFX[sfxIdx] = parseSFX(chunks[i])
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
    local length   = string.format("%02d", tonumber(data.length) or "01")
    return tone .. volume .. waveType .. effects .. length
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
        
        add(lines, line)
    end
    local content = table.concat(lines, "\n")
    saveFile(LUAESSFXDATA, content)
end

local lastPlayedTime = {}
local MIN_DELAY = 1/32

function sfx(index, d)
    d = (d ~= nil and type(d) == "number") and d or 3
    delay = mid(1,d,16)
    local currentTime = os.clock()
    if lastPlayedTime[index] and (currentTime - lastPlayedTime[index] < MIN_DELAY*delay) then
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
        end
        add(newsound,SFX[i])
    end
    SOUNDS[soundIndex] = audio.genMusic(newsound)
end

local cmp = nil
local cmpIndex = 1
local toPlay = true

local function changecmpindex(i)
    cmpIndex = i
    toPlay = true
end

local MUSICS = {}

function music(i)
    i = mid(1,i,16)
    local p = MUSICS[i]
    if cmp ~= nil and #cmp > 0 and cmp[cmpIndex].play ~= nil then
        for i=1, #cmp[cmpIndex].play do
            SOUNDS[cmp[cmpIndex].play[i]]:stop()
        end
        cmp = nil
        changecmpindex(1)
    end

    cmp = p
end

function smusic(i,p)
    i = mid(1,i,16)
    MUSICS[i] = p
end

local function updatemusic()
    if cmp == nil or #cmp == 0 then return end

    if cmp[cmpIndex] ~= nil and type(cmp[cmpIndex].next) == "number" then
        changecmpindex(cmp[cmpIndex].next)
    end

    if cmpIndex > #cmp then 
        changecmpindex(1)
    end

    if cmp[cmpIndex].stop then
        cmp = nil
        changecmpindex(1)
        return
    end

    local isPlaying = false

    for i=1, #cmp[cmpIndex].play do
        if SOUNDS[cmp[cmpIndex].play[i]]:isPlaying() then
            isPlaying = true
        end
    end

    if isPlaying then
        return
    end

    if toPlay then
       for i=1, #cmp[cmpIndex].play do
            SOUNDS[cmp[cmpIndex].play[i]]:play()
        end
        toPlay = false
        return
    end

    changecmpindex(cmpIndex + 1)
end
--#endregion

--#region camera
function camera(x, y)
     -- Always resetcamera in the same frame if camera function was called
    love.graphics.push()
    love.graphics.translate(-x, -y)
end

function resetcamera()
    love.graphics.pop()
end
--#endregion

--#region sprite
local spriteSheets = {}
local spritesheetsdataastable = {}
local sheetWidth, sheetHeight = 160, 32
local spriteSheetImages = {}
local SPR_SIZE = 8
local MAX_SHEETS = 8
local spritesPerRow = sheetWidth / SPR_SIZE
local rerenderImage = { false, false, false, false, false, false, false, false } -- 8 spread sheets
local LUAESSPRITESSHEETSDATA = "luaesspritesheetsdata"

local function charToNum(c)
    if c >= '0' and c <= '9' then
        return tonumber(c)
    elseif c >= 'A' and c <= 'G' then
        return 10 + (c:byte() - string.byte('A'))
    else
        return 0
    end
end

local function numToChar(n)
    if n >= 0 and n <= 9 then
        return tostring(n)
    else
        return string.char(string.byte('A') + (n - 10))
    end
end

local function validSheet(i)
    return type(i) == "number" and i >= 1 and i <= MAX_SHEETS
end

local function validCoord(x, y)
    return type(x) == "number"
       and type(y) == "number"
       and x >= 1 and x <= sheetWidth
       and y >= 1 and y <= sheetHeight
end

local function validColor(c)
    return type(c) == "number" and c >= 0 and c <= 16
end

function spixel(i, x, y, c)
    if not validSheet(i) then return end
    if not validCoord(x, y) then return end
    if not validColor(c) then c = 0 end

    spritesheetsdataastable[i] = spritesheetsdataastable[i] or {}
    spritesheetsdataastable[i][y] = spritesheetsdataastable[i][y] or {}
    spritesheetsdataastable[i][y][x] = c

    local rgb = getpalette(c)
    spriteSheets[i]:setPixel(x-1, y-1, rgb[1], rgb[2], rgb[3], rgb[4])
    rerenderImage[i] = true
end

function gpixel(i, x, y)
    if not validSheet(i) then return 0 end
    if not validCoord(x, y) then return 0 end
    
    return spritesheetsdataastable[i][y][x]
end

local function loadspritesheetdata()
    createIfDoesntExist(LUAESSPRITESSHEETSDATA, spritesheetsdata)

    local lineIter = loadFile(LUAESSPRITESSHEETSDATA)
    local LINES_PER_IMAGE = 32

    local img = 1
    local y = 1

    spriteSheets[img] = love.image.newImageData(sheetWidth, sheetHeight)

    for line in lineIter do
        for x = 1, #line do
            spixel(img, x, y, charToNum(line:sub(x, x)))
        end

        y = y + 1

        if y > LINES_PER_IMAGE then
            spriteSheetImages[img] = love.graphics.newImage(spriteSheets[img])

            img = img + 1
            if img > 8 then break end

            spriteSheets[img] = love.image.newImageData(sheetWidth, sheetHeight)
            y = 1
        end
    end
end

local function savespritesheetdata()
    local lines = {}
    local LINES_PER_IMAGE = 32

    for img = 1, 8 do
        for y = 1, LINES_PER_IMAGE do
            local row = {}
            for x = 1, sheetWidth do
                local c = gpixel(img, x, y)
                row[#row + 1] = numToChar(c)
            end
            lines[#lines + 1] = table.concat(row)
        end
    end

    saveFile(LUAESSPRITESSHEETSDATA, table.concat(lines, "\n"))
end

function updatespritesheetimages()
    for i=1,8 do
        if rerenderImage[i] then
            spriteSheetImages[i] = love.graphics.newImage(spriteSheets[i])
        end
    end
end
--#endregion

--#region draw
function print(text, x, y, c, a)
    setcolor(c, a)
    love.graphics.print(text, x, y)
    setcolor()
end

function rect(x, y, w, h, c, a)
    setcolor(c, a)
    love.graphics.rectangle("line", x, y, w, h)
    setcolor()
end

function rectfill(x, y, w, h, c, a)
    setcolor(c, a)
    love.graphics.rectangle("fill", x, y, w, h)
    setcolor()
end

function line(x0, y0, x1, y1, c, a)
    setcolor(c, a)
    love.graphics.line(x0, y0, x1, y1)
    setcolor()
end

function circ(x, y, r, c, a)
    setcolor(c, a)
    love.graphics.circle("line", x, y, r)
    setcolor()
end

function circfill(x, y, r, c, a)
    setcolor(c, a)
    love.graphics.circle("fill", x, y, r)
    setcolor()
end

function spr(i, n, x, y, w, h, flip_x, flip_y, c, a)
    w = w or 1
    h = h or 1
    flip_x = flip_x and -1 or 1
    flip_y = flip_y and -1 or 1

    local sx = ((n - 1) % spritesPerRow) * SPR_SIZE
    local sy = ((n - 1) / spritesPerRow) * SPR_SIZE
    local sw, sh = SPR_SIZE * w, SPR_SIZE * h

    local ox = flip_x == -1 and sw or 0
    local oy = flip_y == -1 and sh or 0

    setcolor(c, a)
    love.graphics.draw(
        spriteSheetImages[i],
        love.graphics.newQuad(sx, sy, sw, sh, sheetWidth, sheetHeight),
        x, y,
        0,
        flip_x, flip_y,
        ox, oy
    )
    setcolor()
end
--#endregion

--#region time
timer = {
    list = {}
}

local function newTime()
    return {
        startTime = love.timer.getTime(),
        pauseTime = 0,
        offset    = 0,
        paused    = false
    }
end

local function normIndex(i)
    i = (type(i) == "number") and i or 1
    return mid(1, i, 64)
end

function timer:create(i)
    i = normIndex(i)
    self.list[i] = newTime()
end

function timer:get(i)
    i = normIndex(i)
    local t = self.list[i]
    if not t then return 0 end

    if t.paused then
        return t.pauseTime
    end

    return love.timer.getTime() - t.startTime + t.offset
end

function timer:pause(i)
    i = normIndex(i)
    local t = self.list[i]
    if not t or t.paused then return end

    t.pauseTime = self:get(i)
    t.paused = true
end

function timer:resume(i)
    i = normIndex(i)
    local t = self.list[i]
    if not t or not t.paused then return end

    t.startTime = love.timer.getTime()
    t.offset    = t.pauseTime
    t.paused    = false
end

--#endregion

--#region status
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
    elseif n == 6 then -- Seconds after application started
        return love.timer.getTime()
    elseif n == 7 then -- Local time as table        
        return os.date("*t")
    elseif n == 8 then -- UTC time as table
        return os.date("!*t")
    elseif n == 9 then
        return { x = VIRTUAL_WIDTH,  y = VIRTUAL_HEIGHT}
    elseif n == 10 then
        return { x = window_width,  y = window_height, scale = scale, ofx = offsetX,  ofy = offsetY }
    else
        return nil
    end
end
--#endregion

--#region buttons
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
local prevMouseLeft, prevMouseRight = false, false

local function updatePrevKeys()
    prevKeys = {}
    for i = 0, 8 do
        prevKeys[i] = love.keyboard.isDown(btnKeys[i])
    end

    prevMouseLeft  = love.mouse.isDown(1)
    prevMouseRight = love.mouse.isDown(2)
end

function mouse()
    local x, y = love.mouse.getPosition()
    x = floor((x - offsetX) / scale)
    y = floor((y - offsetY) / scale)
    local left  = love.mouse.isDown(1)
    local right = love.mouse.isDown(2)
    return {
        x = x,
        y = y,
        l = left,
        r = right,
        lp = left and not prevMouseLeft,
        rp = right and not prevMouseRight,
    }
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
--#endregion

--#region save game
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
--#endregion

--#region main
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
    local icon = love.image.newImageData("icon.png")
    love.window.setIcon(icon)
    love.window.setTitle("LuaES")
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(window_width, window_height, {resizable = true, fullscreen = false, minwidth = VIRTUAL_WIDTH, minheight = VIRTUAL_HEIGHT})
    love.graphics.setFont(love.graphics.newFont("fonts/Tiny5-Regular.ttf", 8))
    updateScale()
    loadsfxdata()
    loadspritesheetdata()
    _init()
    updatespritesheetimages()
end

function love.update(dt)
    rerenderImage = { false, false, false, false, false, false, false, false }
    _update(dt)
    updatemusic()
    updatespritesheetimages()
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

function exit()
    love.event.quit()
end

function save()
    savesfxdata()
    savespritesheetdata()
end
--#endregion

return {
    -- table --
    add     = add,
    del     = del,
    foreach = foreach,
    all     = all,
    -- math --
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
    -- sfx --
    sfx    = sfx,
    ssfx   = ssfx,
    music  = music,
    smusic = smusic,
    -- system --
    stat = stat,
    save = save,
    exit = exit,
    -- save game --
    sdata = sdata,
    gdata = gdata,
    cdata = cdata,
    -- camera --
    camera = camera,
    resetcamera = resetcamera,
    -- sprite --
    spixel = spixel,
    gpixel = gpixel,
    -- draw --
    print = print,
    rect = rect,
    rectfill = rectfill,
    line = line,
    circ = circ,
    circfill = circfill,
    spr = spr,
    -- time --
    timer = timer,
    -- input --
    btn = btn,
    btnp = btnp,
    mouse = mouse,
    -- loop --
    _init = _init,
    _update = _update,
    _draw = _draw,
}