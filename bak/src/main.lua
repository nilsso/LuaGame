package.path = "./lib/hump/?.lua;../lib/hump/?.lua;"..package.path
--package.path = "./lib/middleclass/?.lua;../lib/middleclass/?.lua" .. package.path
G, K, M, W = love.graphics, love.keyboard, love.mouse, love.window
W.w = W.getWidth()
W.h = W.getHeight()

-- -----------------------------------------------
-- Utilities
-- -----------------------------------------------

Colors = {
    white =     {255,   255,    255},
    ltgray =    {191,   191,    191},
    gray =      {127,   127,    127},
    dkgray =    {64,    64,     64},
    black =     {0,     0,      0},
    red =       {255,   0,      0},
    green =     {0,     255,    0},
    blue =      {0,     0,      255}
}

Debug = {
    enabled = false,
    draw_text = true,
    draw_geom = true
}

-- -----------------------------------------------
-- Required Modules
-- -----------------------------------------------
-- HUMP
Class = require "class"
Gamestate = require "gamestate"
Vector = require "vector"

-- Prototypes
PrintRegion = require "print_region"
BaseState = require "base_state"
BaseButton = require "base_button"
BaseVectorEntity = require "base_vector_entity"
BaseParticle = require "base_particle"

-- -----------------------------------------------
-- States
-- -----------------------------------------------
local menu = BaseState()
menu.name = "Menu"

local game = BaseState()
game.name = "Game"
game.keybinds = {
    ["escape"] = {{},
        function()
            love.event.quit()
        end},
    ["g"] = {{"lshift", "rshift"},
        function()
            Debug.enabled = not Debug.enabled
        end},
    ["z"] = {{},
        function()
            if Debug.enabled then
                Debug.draw_geom = not Debug.draw_geom
            end
        end},
    ["x"] = {{},
        function()
            if Debug.enabled then
                Debug.draw_text = not Debug.draw_text
            end
        end},
    ["c"] = {{},
        function()
            collectgarbage()
        end}
}

do
    local button = BaseButton("Particles", 55, W.h/2)

    button.func_down = function()
        for i=1, 5-math.random()*4 do
            local particle = BaseParticle()
            particle.pos.x = W.w/2
            particle.pos.y = W.h/2
            particle:register(game.entities)
        end
    end
    button.func_down_cd = 0.25

    table.insert(game.entities, button)
end

-- -----------------------------------------------
-- Callbacks
-- -----------------------------------------------
function love.load()
    math.randomseed(os.time())
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function love.update(dt)
    W.w = W.getWidth()
    W.h = W.getHeight()
end

