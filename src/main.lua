package.path = "./lib/hump/?.lua;../lib/hump/?.lua;"..package.path
--package.path = "./lib/middleclass/?.lua;../lib/middleclass/?.lua" .. package.path
G, K, M, W = love.graphics, love.keyboard, love.mouse, love.window
W.w = W.getWidth()
W.h = W.getHeight()

-- -----------------------------------------------
-- Libraries & Utilities
-- -----------------------------------------------
-- Libraries
Gamestate = require "gamestate"

-- Utilities
Colors = {
    white =     {255,   255,    255,    255},
    ltgray =    {191,   191,    191,    255},
    gray =      {127,   127,    127,    255},
    dkgray =    {64,    64,     64,     255},
    black =     {0,     0,      0,      255},
    red =       {255,   0,      0,      255},
    green =     {0,     255,    0,      255},
    blue =      {0,     0,      255,    255}
    --[[
    white =     {255,   255,    255},
    ltgray =    {191,   191,    191},
    gray =      {127,   127,    127},
    dkgray =    {64,    64,     64},
    black =     {0,     0,      0},
    red =       {255,   0,      0},
    green =     {0,     255,    0},
    blue =      {0,     0,      255}
    --]]
}

Debug = {
    enabled = false,
    drawText = true,
    drawGeom = true
}

-- -----------------------------------------------
-- Prototypes
-- -----------------------------------------------
PrintRegion = require "print_region"
BaseState = require "base_state"
BaseButton = require "base_button"
BaseEntity = require "base_entity"
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
                Debug.drawGeom = not Debug.drawGeom
            end
        end},
    ["x"] = {{},
        function()
            if Debug.enabled then
                Debug.drawText = not Debug.drawText
            end
        end},
    ["c"] = {{},
        function()
            collectgarbage()
        end}
}

if false then
    local button = BaseButton("Particles", 55, W.h/2)
    button.func_down = function()
        --BaseParticle(game.entities, W.w/2, W.h/2)
    end
    table.insert(game.entities, button)
else
    local entity = BaseEntity(W.h/2, W.h/2)
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

