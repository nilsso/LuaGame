package.path = "./lib/?.lua;" .. package.path

-- Love macros
G, K, M, W = love.graphics, love.keyboard, love.mouse, love.window
W.w, W.h = W.getWidth(), W.getHeight()

-- Modules
ButtonBase = require("button_base")
Class = require("class")
Colors = require("colors")
Gamestate = require("gamestate")
Vector = require("vector")

Debug = {
    enabled = false
}

-- Entity table
local Entities = {
    ButtonBase("Test", 5+100/2, W.h/2, 100, 20),
}

-- -----------------------------------------------
-- Game States
-- -----------------------------------------------
local menu = {name="menu"}
local game = {name="game"}

-- Menu State
function menu:draw()
end

function menu:keypressed(key)
    if key == "return" then
        Gamestate.switch(game)
    end
end

-- Game State
function game:draw()
    -- Draw entities
    for _, e in pairs(Entities) do
        e:draw()
    end
end

function game:keypressed(key)
    if key == "return" then
        Gamestate.switch(menu)
    end
end

-- -----------------------------------------------
-- Love Callbacks
-- -----------------------------------------------
function love.draw()
    -- Debug draw
    if Debug.enabled then
        -- Text
        local i = 0
        G.setColor(Colors.white)
        G.print(string.format("State: %s", Gamestate.current().name), 5, 12*i+5)
        i = i + 1
        G.print(string.format("mouses = (%i,%i)", M.getPosition()), 5, 12*i+5)

        -- Geometry
        G.setColor(Colors.blue)
        G.setLineWidth(1)
        G.line(0, W.h/2, W.w, W.h/2)
        G.line(W.w/2, 0, W.w/2, W.h)
    end
end

function love.keypressed(key)
    if key == 'g' and (K.isDown("lshift") or K.isDown("rshift")) then
        Debug.enabled = not Debug.enabled
    end
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

