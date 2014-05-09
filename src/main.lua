--[[
-- TABLE OF CODE CONTENTS (am I autistic?)
-- 1. External modules
-- 2. Utility functions
-- 3. Color definitions
-- 4. Local (My) Modules
-- 5. Debugging Configuration
-- 6. State Definitions
-- 7. LÖVE Callbacks
--]]

package.path = "./lib/hump/?.lua;../lib/hump/?.lua;"..package.path
--package.path = "./lib/middleclass/?.lua;../lib/middleclass/?.lua" .. package.path
G, K, M, W = love.graphics, love.keyboard, love.mouse, love.window
W.w = W.getWidth()
W.h = W.getHeight()

-- -----------------------------------------------
-- 1. External Modules
-- -----------------------------------------------
-- HUMP
Class = require "class"
Gamestate = require "gamestate"
Vector = require "vector"

-- -----------------------------------------------
-- 2. Utility Functions
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

-- -----------------------------------------------
-- 3. Colors
-- -----------------------------------------------
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

-- -----------------------------------------------
-- 4. Local (My) Modules
-- -----------------------------------------------
Keybindings = require("keybindings")
PrintRegion = require "print_region"
BaseState = require "base_state"
BaseEntityStatic = require "base_entity_static"
BaseButton = require "base_button"
BaseEntity = require "base_entity"
BaseParticle = require "base_particle"

-- -----------------------------------------------
-- 5. Debugging Configuration
-- -----------------------------------------------
Debug = {
    flags = {
        enabled = false,
        geom = true,
        text = true
    },

    colors = {
        geom = Colors.blue,
        text = Colors.white
    }
}

-- -----------------------------------------------
-- 6. State Definitions
-- -----------------------------------------------
local menu = BaseState()
menu.name = "Menu"

local game = BaseState()
game.name = "Game"

-- Test game state entities
if false then
    -- BUTTONS
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
    buttonUp.buttons.keys = {"up"}
    buttonUp.func.d = up
    buttonUp.func.d_cd = 0
    buttonUp:register(game.entities)

    local buttonRightUp = BaseButton("Right-Up", W.w/2+105, W.h-65)
    buttonRightUp.func.d = {right, up}
    buttonRightUp.func.d_cd = 0
    buttonRightUp:register(game.entities)

    local buttonLeft = BaseButton("Left", W.w/2-105, W.h-40)
    buttonLeft.buttons.keys = {"left"}
    buttonLeft.func.d = left
    buttonLeft.func.d_cd = 0
    buttonLeft:register(game.entities)

    local buttonRight = BaseButton("Right", W.w/2+105, W.h-40)
    buttonRight.buttons.keys = {"right"}
    buttonRight.func.d = right
    buttonRight.func.d_cd = 0
    buttonRight:register(game.entities)

    local buttonLeftDown = BaseButton("Left-Down", W.w/2-105, W.h-15)
    buttonLeftDown.func.d = {left, down}
    buttonLeftDown.func.d_cd = 0
    buttonLeftDown:register(game.entities)

    local buttonDown = BaseButton("Down", W.w/2, W.h-15)
    buttonDown.buttons.keys = {"down"}
    buttonDown.func.d = down
    buttonDown.func.d_cd = 0
    buttonDown:register(game.entities)

    local buttonRightDown = BaseButton("Right-Down",W.w/2+105, W.h-15)
    buttonRightDown.func.d = {right, down}
    buttonRightDown.func.d_cd = 0
    buttonRightDown:register(game.entities)

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

    -- BINDINGS
    -- Binding functions
    local function quit()
        love.event.quit()
    end
    local function toggleDebug()
        Debug.flags.enabled = not Debug.flags.enabled
    end
    local function toggleDebugGeom()
        Debug.flags.geom = not Debug.flags.geom
    end
    local function toggleDebugText()
        Debug.flags.text = not Debug.flags.text
    end

    game:registerKey("escape", quit)
    game:registerKey("g", toggleDebug, {"lshift", "rshift"})
    game:registerKey("z", toggleDebugGeom)
    game:registerKey("x", toggleDebugText)
end

if true then
    keybindings = Keybindings()
    keybindings:addFromTable{
        {"escape", love.event.quit, nil, "System"},
        {"g", function()
            Debug.flags.enabled = not Debug.flags.enabled
        end, {"lshift", "rshift"}, "System"},
        {"z", function()
            if Debug.flags.enabled then
                Debug.flags.geom = not Debug.flags.geom
            end
        end, nil, "System"},
        {"x", function()
            if Debug.flags.enabled then
                Debug.flags.text = not Debug.flags.text
            end
        end, nil, "System"}
    }
end

-- -----------------------------------------------
-- 7. LÖVE Callbacks
-- -----------------------------------------------
function love.load()
    math.randomseed(os.time())
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function love.keypressed(key)
    if keybindings.keys[key] then
        keybindings:call(key)
    end
end

function love.update(dt)
    W.w = W.getWidth()
    W.h = W.getHeight()
    G.font = G.getFont()
end

