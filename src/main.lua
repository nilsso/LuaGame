package.path = "./lib/hump/?.lua;../lib/hump/?.lua;"..package.path
--package.path = "./lib/middleclass/?.lua;../lib/middleclass/?.lua" .. package.path
G, K, M, W = love.graphics, love.keyboard, love.mouse, love.window
W.w = W.getWidth()
W.h = W.getHeight()

-- -----------------------------------------------
-- Utilities
-- -----------------------------------------------

function xor(a, b)
    return (a or b) and not (a and b)
end

function ShallowCopy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end

Colors = {
    white =     {255, 255, 255},
    ltgray =    {191, 191, 191},
    gray =      {127, 127, 127},
    dkgray =    {64, 64, 64},
    black =     {0, 0, 0},
    red =       {255, 0, 0},
    green =     {0, 255, 0},
    yellow =    {255, 255, 0},
    blue =      {0, 0, 255}
}

Debug = {
    enabled = false,
    draw_geom = true,
    draw_text = true,
    draw_text_verbose = false
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
BaseEntityStatic = require "base_entity_static"
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

-- button.func_down = function()
--     for i=1, 5-math.random()*4 do
--         local particle = BaseParticle()
--         particle.pos.x = W.w/2
--         particle.pos.y = W.h/2
--         particle:register(game.entities)
--     end
-- end

do
    local entity1 = BaseEntityStatic()
    entity1.pos = Vector(W.w/2,W.h/2)
    entity1:register(game.entities)

    local d = 200

    local left = function(dt) entity1.pos.x = entity1.pos.x-d*dt end
    local right = function(dt) entity1.pos.x = entity1.pos.x+d*dt end
    local up = function(dt) entity1.pos.y = entity1.pos.y-d*dt end
    local down = function(dt) entity1.pos.y = entity1.pos.y+d*dt end

    local buttonLeftUp = BaseButton("Left-Up", W.w/2-105, W.h-65)
    buttonLeftUp.func.d = {left, up}
    buttonLeftUp.func.d_cd = 0
    buttonLeftUp:register(game.entities)

    local buttonUp = BaseButton("Up", W.w/2, W.h-65)
    buttonUp.func.d = up
    buttonUp.func.d_cd = 0
    buttonUp.buttons.keys = {"up"}
    buttonUp:register(game.entities)

    local buttonRightUp = BaseButton("Right-Up", W.w/2+105, W.h-65)
    buttonRightUp.func.d = {right, up}
    buttonRightUp.func.d_cd = 0
    buttonRightUp:register(game.entities)

    local buttonLeft = BaseButton("Left", W.w/2-105, W.h-40)
    buttonLeft.func.d = left
    buttonLeft.func.d_cd = 0
    buttonLeft.buttons.keys = {"left"}
    buttonLeft:register(game.entities)

    local buttonRight = BaseButton("Right", W.w/2+105, W.h-40)
    buttonRight.func.d = right
    buttonRight.func.d_cd = 0
    buttonRight.buttons.keys = {"right"}
    buttonRight:register(game.entities)

    local buttonLeftDown = BaseButton("Left-Down", W.w/2-105, W.h-15)
    buttonLeftDown.func.d = {left, down}
    buttonLeftDown.func.d_cd = 0
    buttonLeftDown:register(game.entities)

    local buttonDown = BaseButton("Down", W.w/2, W.h-15)
    buttonDown.func.d = down
    buttonDown.func.d_cd = 0
    buttonDown.buttons.keys = {"down"}
    buttonDown:register(game.entities)

    local buttonRightDown = BaseButton("Right-Down",W.w/2+105, W.h-15)
    buttonRightDown.func.d = {right, down}
    buttonRightDown.func.d_cd = 0
    buttonRightDown:register(game.entities)
end

local buttonPrint = BaseButton("Print Button Functions",55,W.h-20,100,30)
buttonPrint.func.p = function() print("PRESSED") end
buttonPrint.func.r = function() print("RELEASED") end
buttonPrint.func.d = function() print("DOWN") end
buttonPrint.buttons.keys = {" "}
buttonPrint:register(game.entities)

local buttonParticles = BaseButton("Particles",55,buttonPrint.bounds.t-15)
buttonParticles:register(game.entities)

local buttonTest1 = BaseButton("Test",W.w/4,W.h/2-15)
buttonTest1:register(game.entities)

local buttonTest2 = BaseButton("Test",W.w/4,W.h/2+15)
buttonTest2:register(game.entities)

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
    G.font = G.getFont()
end

