local audio = require("libs/audio")

-- DEMO --

function love.load()

    GW, GH = love.graphics.getDimensions()

    MUSIC = audio.genMusic({
        {tone = "C5", length = 8},
        {tone = 0,    length = 1},
        {tone = "E5", length = 8},
        {tone = 0,    length = 1},
        {tone = "G5", length = 8},
        {tone = 0,    length = 1},
        {tone = "E5", length = 8},

        {tone = "D5", length = 8},
        {tone = 0,    length = 1},
        {tone = "F5", length = 8},
        {tone = 0,    length = 1},
        {tone = "A5", length = 8},
        {tone = 0,    length = 1},
        {tone = "F5", length = 8},

        {tone = "E5", length = 8},
        {tone = 0,    length = 1},
        {tone = "G5", length = 8},
        {tone = 0,    length = 1},
        {tone = "C6", length = 12},

        {tone = 0,    length = 2},

        {tone = "B5", length = 8},
        {tone = 0,    length = 1},
        {tone = "G5", length = 8},
        {tone = 0,    length = 1},
        {tone = "E5", length = 8},
        {tone = 0,    length = 1},
        {tone = "C5", length = 16},
    })

    MUSICWITHEFFECTS = audio.genMusic({
        { tone = "C5", length = 8, effects = 1 },
        { tone = 0, length = 1 },

        { tone = "E5", length = 8, effects = 3 },
        { tone = 0, length = 1 },

        { tone = "G5", length = 8, effects = 2 },
        { tone = 0, length = 1 },

        { tone = "E5", length = 8, effects = 3 },
        { tone = "D5", length = 8, effects = 1 },
        { tone = 0, length = 1 },

        { tone = "F5", length = 8, effects = 2 },
        { tone = 0, length = 1 },

        { tone = "A5", length = 8, effects = 4 },
        { tone = 0, length = 1 },

        { tone = "F5", length = 8 },

        { tone = "E5", length = 8, effects = 1 },
        { tone = 0, length = 1 },

        { tone = "G5", length = 8, effects = 2 },
        { tone = 0, length = 1 },

        { tone = "C6", length = 12, effects = 4 },
        { tone = 0, length = 2 },

        { tone = "B5", length = 8, effects = 2 },
        { tone = 0, length = 1 },

        { tone = "G5", length = 8, effects = 3 },
        { tone = 0, length = 1 },

        { tone = "E5", length = 8 },
        { tone = 0, length = 1 },

        { tone = "C5", length = 16, effects = 7 }
    })

    MUSICWITHEFFECTS2 = audio.genMusic({
        { tone = "C4", length = 6, effects = 1 },
        { tone = "E4", length = 6, effects = 2 },
        { tone = "G4", length = 6, effects = 1 },

        { tone = 0, length = 1/16 },

        { tone = "C5", length = 8, effects = 4 },
        { tone = "D5", length = 8, effects = 3 },
        { tone = "E5", length = 8, effects = 2 },

        { tone = "G5", length = 16, effects = 6 },
        { tone = 0, length = 2 },

        { tone = "C3", length = 6, effects = 5 },
        { tone = "C3", length = 6, effects = 0 },
        { tone = "C3", length = 6, effects = 7 },

        { tone = 0, length = 3 },

        { tone = "G4", length = 6, effects = 6 },
        { tone = "E4", length = 6, effects = 6 },
        { tone = "C4", length = 6, effects = 4 }
    })

    MUSICWITHEFFECTS3 = audio.genMusic({
        { tone = "C4", length = 8, waveType = "sine",      effects = 5 },
        { tone = "E4", length = 8, waveType = "sine",      effects = 2 },
        { tone = "G4", length = 8, waveType = "sine",      effects = 2 },
        { tone = 0,  length = 1 },
        { tone = "C5", length = 8, waveType = "square",    effects = 1 },
        { tone = "E5", length = 8, waveType = "square",    effects = 3 },
        { tone = "G5", length = 8, waveType = "square",    effects = 3 },
        { tone = 0,  length = 1 },
        { tone = "C6", length = 12, waveType = "sawtooth", effects = 4 },
        { tone = 0,  length = 2 },
        { tone = "C3", length = 10, waveType = "triangle", effects = 8 },
        { tone = "C3", length = 10, waveType = "triangle", effects = 8 },
        { tone = 0,  length = 1 },
        { tone = "G4", length = 8, waveType = "pulser",    effects = 6 },
        { tone = "E4", length = 8, waveType = "pulser",    effects = 6 },
        { tone = 0,  length = 1 },
        { tone = "C5", length = 4, waveType = "noise",     effects = 4 },
        { tone = 0,  length = 1 },
        { tone = "C5", length = 16, waveType = "composite", effects = 4 }
    })

    JUMPEFFECT = audio.genMusic({
        { tone = "C2", length = 1 },
        { tone = "E2", length = 1 },
        { tone = "G2", length = 1 },
        { tone = "C3", length = 1 },
        { tone = "E3", length = 1 },
        { tone = "G3", length = 2 },
        { tone = "C4", length = 2 }
    })

    JUMPEFFECT2 = audio.genMusic({
        { tone = "C3", length = 1 },
        { tone = "E3", length = 1 },
        { tone = "G3", length = 1 },
        { tone = "C4", length = 1 },
        { tone = "E4", length = 1 },
        { tone = "G4", length = 2 },
        { tone = "C5", length = 2 }
    })

    GETHITEFFECT = audio.genMusic({     
        { tone = "C5", length = 1 },
        { tone = "G4", length = 1 },
        { tone = "E4", length = 1 },
        { tone = "C4", length = 1 },
        { tone = "G3", length = 1 },
        { tone = "E3", length = 1 },
        { tone = "C3", length = 1 },
    })

    GETCOIN = audio.genMusic({
        { tone = "C5", length = 1 },
        { tone = "E5", length = 1 },
        { tone = "G5", length = 1 },
        { tone = "C6", length = 2 }
    })

    SHOOTEFFECT = audio.genMusic({
        { tone = "C5", length = 1 },
        { tone = "G4", length = 1 },
        { tone = "E4", length = 1 },
        { tone = "C4", length = 2 }
    })

    MUSIC_STRESS_STACK = audio.genMusic({
        { tone="C4", length=4, waveType="square",   effects=1 }, -- arp
        { tone="C4", length=4, waveType="square",   effects=2 }, -- vibrato
        { tone="C4", length=4, waveType="square",   effects=3 }, -- slide
        { tone="C4", length=4, waveType="square",   effects=6 }, -- tremolo
        { tone="C4", length=4, waveType="square",   effects=7 }, -- pitch drop
        { tone=0,    length=1 },

        { tone="C5", length=12, waveType="sawtooth", effects=6 },
        { tone="C3", length=12, waveType="triangle", effects=7 },
    })

    MUSIC_ENVELOPE_TEST = audio.genMusic({
        { tone="C5", length=1, effects=5 }, -- fade in only
        { tone="C5", length=1, effects=4 }, -- fade out only
        { tone="C5", length=1 },            -- no fade
        { tone=0,    length=1/32 },

        { tone="C5", length=2, effects=5 },
        { tone=0,    length=1/64 },
        { tone="C5", length=2, effects=4 },
        { tone=0,    length=1/64 },

        { tone="C5", length=8, effects=6 }, -- tremolo vs envelope
    })

    MUSIC_PITCH_TEST = audio.genMusic({
        { tone="C4", length=8 },
        { tone="Cs4", length=8 },
        { tone="D4", length=8 },
        { tone="Ds4", length=8 },
        { tone="E4", length=8 },
        { tone="F4", length=8 },
        { tone="Fs4", length=8 },
        { tone="G4", length=8 },
        { tone="Gs4", length=8 },
        { tone="A4", length=8 },
        { tone="As4", length=8 },
        { tone="B4", length=8 },
        { tone="C5", length=16 },
    })

    MUSIC_WAVE_COMPARE = audio.genMusic({
        { tone="C4", length=6, waveType="sine" },
        { tone="C4", length=6, waveType="square" },
        { tone="C4", length=6, waveType="triangle" },
        { tone="C4", length=6, waveType="sawtooth" },
        { tone="C4", length=6, waveType="pulser" },
        { tone="C4", length=6, waveType="composite" },
        { tone="C4", length=6, waveType="noise" },
    })

    MUSIC_TIMING_TEST = audio.genMusic({
        { tone="C5", length=1 },
        { tone=0, length=1/64 },
        { tone="C5", length=1 },
        { tone=0, length=1/64 },
        { tone="C5", length=1 },
        { tone=0, length=1/32 },

        { tone="G4", length=2 },
        { tone=0, length=1/16 },
        { tone="E4", length=2 },
        { tone=0, length=1/16 },

        { tone="C4", length=8 },
    })

    MUSIC_CHAOS = audio.genMusic({
        { tone="C2", length=4, waveType="noise",     effects=6 },
        { tone="G5", length=2, waveType="square",    effects=7 },
        { tone="E3", length=6, waveType="triangle",  effects=1 },
        { tone=0,    length=1/8 },
        { tone="C6", length=10, waveType="sawtooth", effects=3 },
        { tone="C1", length=12, waveType="sine",     effects=7 },
    })

    MUSIC_LIST = {
        { name = "Base melody",        src = MUSIC },
        { name = "With effects",       src = MUSICWITHEFFECTS },
        { name = "With effects 2",     src = MUSICWITHEFFECTS2 },
        { name = "With effects 3",     src = MUSICWITHEFFECTS3 },
        { name = "Stress stack",       src = MUSIC_STRESS_STACK },
        { name = "Envelope test",      src = MUSIC_ENVELOPE_TEST },
        { name = "Pitch test",         src = MUSIC_PITCH_TEST },
        { name = "Wave compare",       src = MUSIC_WAVE_COMPARE },
        { name = "Timing test",        src = MUSIC_TIMING_TEST },
        { name = "Chaos",              src = MUSIC_CHAOS },
    }

    MUSIC_INDEX = #MUSIC_LIST
    MUSIC = MUSIC_LIST[MUSIC_INDEX].src

    SOUNDS = {
        sine = audio.genSound(4, "C5", "sine");
        square = audio.genSound(4, "C5", "square");
        triangle = audio.genSound(4, "C5", "triangle");
        sawtooth = audio.genSound(4, "C5", "sawtooth");
        pulser = audio.genSound(4, "C5", "pulser");
        composite = audio.genSound(4, "C5", "composite");
        noise = audio.genSound(4, "C5", "noise");
    }

    BW, BH = 192, 92

    BTN_MUSIC = {
        (GW-BW)*.5, (GH-BH)*.03125, {1,1,1}
    }

    BUTTONS = {
        {(GW-BW)*.25, (GH-BH)*.25, {1,0,0}},
        {(GW-BW)*.75, (GH-BH)*.25, {0,1,0}},
        {(GW-BW)*.25, (GH-BH)*.5, {0,0,1}},
        {(GW-BW)*.75, (GH-BH)*.5, {1,1,0}},
        {(GW-BW)*.25, (GH-BH)*.75, {1,0,1}},
        {(GW-BW)*.75, (GH-BH)*.75, {0,1,1}},
        {(GW-BW)*.75, (GH-BH), {0,0.5,1}}
    }

    FONT = love.graphics.getFont()

end

local pressed;
function love.update(dt)

    if love.mouse.isDown(1) or love.mouse.isDown(2) then
        local mx, my = love.mouse.getPosition()

        if not pressed then
            pressed = true
            local x, y = BTN_MUSIC[1], BTN_MUSIC[2]

            if mx > x and mx < x+BW and my > y and my < y+BH then

                -- LEFT CLICK → play / stop
                if love.mouse.isDown(1) then
                    if MUSIC:isPlaying() then
                        MUSIC:stop()
                    else
                        MUSIC:play()
                    end
                end

                -- RIGHT CLICK → next music
                if love.mouse.isDown(2) then
                    if MUSIC:isPlaying() then MUSIC:stop() end

                    MUSIC_INDEX = MUSIC_INDEX % #MUSIC_LIST + 1
                    MUSIC = MUSIC_LIST[MUSIC_INDEX].src
                end
            end
        end
    end
end

function love.mousereleased()
    pressed = false
end

function love.draw()
    local i = 1;
    for k, sound in pairs(SOUNDS) do

        local x, y = BUTTONS[i][1], BUTTONS[i][2]

        local fw, fh = FONT:getWidth(k), FONT:getHeight()

        love.graphics.setColor(BUTTONS[i][3])
        love.graphics.rectangle("fill", x, y, BW, BH, BW/4, BH/4)

        love.graphics.setColor(0,0,0)
        love.graphics.print(k, (x+BW/2)-fw/2, (y+BH/2)-fh/2)

        i = i + 1

    end
    local current = MUSIC_LIST[MUSIC_INDEX].name
    local str = (MUSIC:isPlaying() and "Stop: " or "Play: ") .. current

    local x, y = BTN_MUSIC[1], BTN_MUSIC[2]
    local fw, fh = FONT:getWidth(str), FONT:getHeight()

    love.graphics.setColor(BTN_MUSIC[3])
    love.graphics.rectangle("fill", x, y, BW, BH, BW/4, BH/4)

    love.graphics.setColor(0,0,0)
    love.graphics.print(str, (x+BW/2)-fw/2, (y+BH/2)-fh/2)

end

