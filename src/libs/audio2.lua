local floor = math.floor
local sin   = math.sin
local pi    = math.pi
local exp   = math.exp
local rate = 22050

local notes = {}
do
    local A4 = 440.0
    local names = {"C","Cs","D","Ds","E","F","Fs","G","Gs","A","As","B"}

    for n = 12, 131 do
        local freq = A4 * 2 ^ ((n - 69) / 12)
        local octave = floor(n / 12) - 1
        notes[names[n % 12 + 1] .. octave] = freq
    end
end

local EFFECTS = {
    [1] = { slide = { depth = 12, speed = 3 } },
    [2] = { vibrato = { depth = 0.02, speed = 6 } },
    [3] = { drop = 2.0 },
    [4] = { fade_in = 0.05 },
    [5] = { fade_out = 0.05 },
    [6] = { arp = {0,4,7}, arpSpeed = 0.03 },
    [7] = { arp = {0,4,7}, arpSpeed = 0.12 },
    [8] = { tremolo = { depth = 0.8, speed = 6 } },
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

local noiseValue = 0
local noiseCounter = 0
local noiseRate = 32

local function envelope(i, total, fadeLength)
    local fs = math.floor(fadeLength * rate)
    fs = math.min(fs, math.floor(3*total/4))

    if i < fs then
        return i / fs
    elseif i > total - fs then
        return (total - i) / fs
    end
    return 1
end

local function sampleWave(phase, wave)
    if wave == "square" then
        return (sin(phase) > 0) and 0.4 or -0.4

    elseif wave == "triangle" then
        return (2 / pi) * math.asin(sin(phase))

    elseif wave == "saw" then
        return 2 * ((phase / (2*pi)) % 1) - 1

    elseif wave == "tilted saw" then
        local t = (phase / (2*pi)) % 1
        return t < 0.5 and (-1 + t*4) or (1 - (t-0.5)*2)

    elseif wave == "pulser" then
        local step = floor(phase * 32 / (2*pi)) % 32
        local duty = 6
        return (step < duty) and 0.4 or -0.4

    elseif wave == "organ" then
        return (
            1.00 * sin(phase) +
            0.50 * sin(phase*2) +
            0.30 * sin(phase*3) +
            0.20 * sin(phase*4) +
            0.10 * sin(phase*6)
        ) * 0.25

    elseif wave == "phaser" then
        local lfo = 0.5 * sin(phase * 0.5)
        return sin(phase + lfo * 3)

    elseif wave == "noise" then
        noiseCounter = noiseCounter + 1
        if noiseCounter >= noiseRate then
            noiseCounter = 0
            noiseValue = love.math.random() * 2 - 1
        end
        return noiseValue * 0.5
    end

    return 0
end

local function genMusic(pattern, fadeLength)
    fadeLength = fadeLength and fadeLength or 1/10
    local totalLen = 0
    for _, n in ipairs(pattern) do
        totalLen = totalLen + (n.length or 1) / 32
    end

    local sampleCount = floor(totalLen * rate)
    local soundData = love.sound.newSoundData(sampleCount, rate, 16, 1)

    local phase = 0
    local t = 0
    local dt = 1 / rate

    local noteIndex = 1
    local noteTime = 0

    for i = 0, sampleCount - 1 do
        local note = pattern[noteIndex]
        local noteLen = (note.length or 1) / 32

        if noteTime >= noteLen then
            noteTime = noteTime - noteLen
            noteIndex = math.min(noteIndex + 1, #pattern)
            note = pattern[noteIndex]
        end

        local freq = type(note.tone) == "string"
            and notes[note.tone]
            or note.tone or 440

        local effects = EFFECTS[note.effects or 0] or {}

        if effects.arp then
            local step = floor(t / (effects.arpSpeed or 0.05))
            local semi = effects.arp[(step % #effects.arp) + 1]
            freq = freq * (2 ^ (semi / 12))
        end

        if effects.slide then
            local bubble = exp(-noteTime * effects.slide.speed)
            freq = freq * (2 ^ ((effects.slide.depth * bubble) / 12))
        end

        if effects.drop then
            freq = freq * exp(-effects.drop * noteTime)
        end

        if effects.vibrato then
            freq = freq * (1 + sin(t * effects.vibrato.speed * 2*pi)
                * effects.vibrato.depth)
        end

        local phaseInc = 2 * pi * freq * dt
        phase = phase + phaseInc

        local v = sampleWave(phase, WAVES[note.waveType] or "square")

        local env = envelope(i, sampleCount, fadeLength)

        if effects.fade_in then
            env = math.min(1, noteTime / effects.fade_in)
        end
        if effects.fade_out then
            env = math.min(env, (noteLen - noteTime) / effects.fade_out)
        end
        if effects.tremolo then
            env = env * (1 - effects.tremolo.depth *
                (0.5 + 0.5 * sin(t * effects.tremolo.speed * 2*pi)))
        end

        soundData:setSample(i, v * env * (note.volume or 1))

        t = t + dt
        noteTime = noteTime + dt
    end

    return love.audio.newSource(soundData)
end

return {
    genMusic = genMusic
}