--[[
Original code https://github.com/Bigfoot71/sounds-generator-love2d
using MIT License

Copyright (c) 2023 Le Juez Victor

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Modifications:
- Fix clicks/abrupt sounds generated when sound starts and/or ends at a non-zero sample value
- Mormalize amplitude of wave type sounds
- Add noise wave form
- Add organ wave form
- Add effects as a number parameter
- Use integer number for length
- Make rate and default sound constants
- Make fadeLength a constant
- Add volume
]]

local floor = math.floor
local sin   = math.sin
local pi    = math.pi
local exp   = math.exp
local rate = 44100
local fadeLength = 1/10
local noiseValue = 0
local noiseCounter = 0
local noiseRate = 32
local notes = {}; do
    local A4 = 440.0
    local names = {"C","Cs","D","Ds","E","F","Fs","G","Gs","A","As","B"}

    for n = 12, 131 do
        local freq = A4 * 2 ^ ((n - 69) / 12)
        local octave = floor(n / 12) - 1
        notes[names[n % 12 + 1] .. octave] = freq
    end
end

local EFFECTS = {
    [1] = {
        slide = {
            depth = 12,
            speed = 3
        }
    }, -- Slide   
    [2] = {
        vibrato = { depth = 0.02, speed = 6 },
    }, -- Vibrato   
    [3] = {
        drop = 2.0
    }, -- drop
    [4] = {
        fade_in = 0.1,
    }, -- Fade in
    [5] = {
        fade_out = 0.1
    }, -- Fade out
    [6] = {
        arp = {0, 4, 7},
        arpSpeed = 0.03,
    }, -- Fast Arpeggio
    [7] = {
        arp = {0, 4, 7},
        arpSpeed = 0.12,
    }, -- Slow Arpeggio
    [8] = {
        tremolo = { depth = 0.8, speed = 6 }
    }, -- Tremolo
    [9] = {
        fade_in = 0.05,
        fade_out = 0.05
    } -- Fade in and Fade out- 
}

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

local function envelope(i, total)
    local fs = math.floor(fadeLength * rate)
    fs = math.min(fs, math.floor(3*total/4))

    if i < fs then
        return i / fs
    elseif i > total - fs then
        return (total - i) / fs
    end
    return 1
end

local function normalizeLength(length)
    length = length or 1
    return length / 32
end

local function genSound(length, tone, waveType, effects, volume)
    if type(tone) == "string" then
        tone = notes[tone]
    end

    length     = normalizeLength(length)
    tone       = tone       or 440
    waveType   = type(waveType) == "number" and WAVES[waveType] or "square"
    effects = type(effects) == "number" and EFFECTS[effects] or {}
    volume = volume or 0
    volume = math.max(0, math.min(volume or 1.0, 1.0))

    local sampleCount = floor(length * rate)
    local soundData = love.sound.newSoundData(sampleCount, rate, 16, 1)

    local phase = 0
    local t  = 0
    local dt = 1 / rate
    local baseFreq = tone

    for i = 0, sampleCount - 1 do
        local freq = baseFreq
        local k = i / sampleCount

        if effects.arp then
            local spd = effects.arpSpeed or 0.05
            local step = floor(t / spd)
            local semi = effects.arp[(step % #effects.arp) + 1]
            freq = freq * (2 ^ (semi / 12))
        end

        if effects.slide then
            local bubble = math.exp(-t * (effects.slide.speed or 10))
            local semi = (effects.slide.depth or 6) * bubble
            freq = freq * (2 ^ (semi / 12))
        end

        if effects.drop then
            freq = freq * exp(-effects.drop * k)
        end

        if effects.vibrato then
            freq = freq * (1 + sin(t * effects.vibrato.speed * 2*pi)
                * effects.vibrato.depth)
        end

        local phaseInc = 2 * pi * freq * dt

        local v = 0

        if waveType == "tilted saw" then
            local t = (phase / (2 * pi)) % 1
            if t < 0.5 then
                v = -1 + t * 4
            else
                v = 1 - (t - 0.5) * 2
            end

        elseif waveType == "square" then
            local step = math.floor((phase / (2*pi)) * 32) % 32
            v = (step < 16) and 1 or -1
            v = v * 0.4

        elseif waveType == "triangle" then
            local t = (phase / (2 * math.pi)) % 1
            if t < 0.25 then -- -1 → 0
                v = -1 + t * 4
            elseif t < 0.5 then -- 0 → +1
                v = (t - 0.25) * 4
            elseif t < 0.75 then -- +1 → 0
                v = 1 - (t - 0.5) * 4
            else -- 0 → -1
                v = -(t - 0.75) * 4
            end

        elseif waveType == "saw" then
            v = 2 * ((phase / (2 * pi)) % 1) - 1

        elseif waveType == "pulser" then
            local step = math.floor(phase * 32 / (2*pi)) % 32
            local duty = 4 + math.floor((math.sin(phase * 0.25) + 1) * 6)
            v = (step < duty) and 1 or -1
            v = v * 0.4

        elseif waveType == "noise" then
            noiseCounter = noiseCounter + 1
            if noiseCounter >= noiseRate then
                noiseCounter = 0
                noiseValue = (love.math.random(0, 1) * 2 - 1)
            end
            v = noiseValue * 0.5

        elseif waveType == "phaser" then
            local lfo = 0.5 * sin(phase * 0.5)
            v = sin(phase + lfo * 3)
        elseif waveType == "organ" then
            v = 1.00 * sin(phase) +      
                0.50 * sin(phase * 2) + 
                0.30 * sin(phase * 3) +
                0.20 * sin(phase * 4) +
                0.10 * sin(phase * 6)  
            v = v * 0.25
        end

        local env = envelope(i, sampleCount)

        if effects.fade_in then
            env = math.min(env, t / effects.fade_in)
        end

        if effects.fade_out then
            env = math.min(env, (length - t) / effects.fade_out)
        end

        if effects.tremolo then
            env = env * (1 - effects.tremolo.depth *
                (0.5 + 0.5 * sin(t * effects.tremolo.speed * 2*pi)))
        end

        soundData:setSample(i, v * env * volume)

        phase = phase + phaseInc
        t = t + dt
    end

    return soundData
end

local function genMusic(sounds)
    local totalLen = 0
    for _, s in ipairs(sounds) do
        totalLen = totalLen + normalizeLength(s.length)
    end

    local soundData = love.sound.newSoundData(
        floor(totalLen * rate), rate, 16, 1
    )

    local offset = 0

    for _, s in ipairs(sounds) do
        local data = genSound(
            s.length,
            s.tone,
            s.waveType,
            s.effects,
            s.volume
        )

        for i = 0, data:getSampleCount() - 1 do
            soundData:setSample(offset + i, data:getSample(i))
        end

        offset = offset + data:getSampleCount()
        data:release()
    end

    local src = love.audio.newSource(soundData)
    soundData:release()
    return src
end

return {
    genMusic = genMusic
}
