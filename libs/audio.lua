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
]]

local floor = math.floor

local notes = {}; do
    local A4 = 440.0
    local note_names = {
        "C","Cs","D","Ds","E","F",
        "Fs","G","Gs","A","As","B"
    }

    for n = 12, 131 do -- C0 → B9
        local freq = A4 * 2 ^ ((n - 69) / 12)
        local octave = floor(n / 12) - 1
        local name = note_names[n % 12 + 1] .. octave
        notes[name] = freq
    end
end

local function envelope(i, total, rate, fadeLength)
    if not fadeLength then return 1 end

    local fadeSamples = floor(fadeLength * rate)

    if i < fadeSamples then
        return i / fadeSamples
    end

    if i > total - fadeSamples then
        return (total - i) / fadeSamples
    end

    return 1
end

local function genSound(length, tone, rate, p, waveType, fadeLength, getData)

    if type(tone) == "string" then
        tone = notes[tone]
    end

    length     = length     or 1/32
    tone       = tone       or 440
    rate       = rate       or 44100
    p          = p          or floor(rate / tone)
    waveType   = waveType   or "square"
    fadeLength = fadeLength or 1/200

    local sampleCount = floor(length * rate)

    local soundData = love.sound.newSoundData(
        sampleCount, rate, 16, 1
    )

    local phase = 0
    local phaseInc = (2 * math.pi) / p

    for i = 0, sampleCount - 1 do
        local env = envelope(i, sampleCount, rate, fadeLength)
        local v = 0

        if waveType == "sine" then
            v = math.sin(phase) * 1.0

        elseif waveType == "square" then
            v = (math.sin(phase) >= 0 and 1 or -1) * 0.4

        elseif waveType == "triangle" then
            v = ((2 / math.pi) * math.asin(math.sin(phase))) * 0.8

        elseif waveType == "sawtooth" then
            v = (2 * (phase / (2 * math.pi)
                - math.floor(0.5 + phase / (2 * math.pi)))) * 0.5

        elseif waveType == "pulser" then
            v = (math.sin(phase) * math.sin(phase * 10)) * 0.7

        elseif waveType == "composite" then
            v = (math.sin(phase) + 0.5 * math.sin(phase * 2)) * 0.5
        end

        soundData:setSample(i, v * env)
        phase = phase + phaseInc
    end

    if getData then return soundData end

    local src = love.audio.newSource(soundData)
    soundData:release()
    return src
end

local function genMusic(sounds, consts, rate)

    rate = rate or 44100

    local totalLen = 0
    for _, s in ipairs(sounds) do
        totalLen = totalLen + (s.length or 1/32)
    end

    local soundData = love.sound.newSoundData(
        floor(totalLen * rate), rate, 16, 1
    )

    local offset = 0

    for _, s in ipairs(sounds) do
        local data = genSound(
            consts and consts.length     or s.length,
            consts and consts.tone       or s.tone,
            rate,
            consts and consts.p          or s.p,
            consts and consts.waveType   or s.waveType,
            consts and consts.fadeLength or s.fadeLength,
            true
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
    notes    = notes,
    genSound = genSound,
    genMusic = genMusic
}
