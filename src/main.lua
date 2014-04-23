package.path = "./lib/*/?.lua;../lib/*/?.lua;"..package.path
g, k, m, w = love.graphics, love.keyboard, love.mouse, love.window

-- -----------------------------------------------
-- Game Setup
-- -----------------------------------------------
-- Libraries
Class = require "class"
Gamestate = require "gamestate"
Vector = require "vector"

-- Utilities
Colors = require "colors"

Debug = {
    enabled = true,
    drawText = true,
    drawGeom = false
}

-- Prototypes
local BaseButton = require "base_button"
local BaseEntity = require "base_entity"
local BaseState = require "base_state"

local Particle = Class.new(BaseEntity)

-- States
local game = BaseState()
game.name = "Game"

game.entities = {
    BaseButton("Test", 55, w.getHeight()/2, nil),
    Particle(w.getWidth()/2, w.getHeight()/2)
}

-- -----------------------------------------------
-- Love Callbacks
-- -----------------------------------------------
function love.keypressed(key)
    KEY = key
    if key == 'g' and (k.isDown("lshift") or k.isDown("rshift")) then
        Debug.enabled = not Debug.enabled
    end
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

