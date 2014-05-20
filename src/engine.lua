lg, lk, lm, lw = love.graphics, love.keyboard, love.mouse, love.window
lg.font = lg.getFont()
lw.w, lw.h = lw.getWidth(), lw.getHeight()

-- -----------------------------------------------
-- 1. External Modules
-- -----------------------------------------------
package.path = "./lib/?.lua;"..package.path
package.path = "../lib/?.lua;"..package.path

-- HUMP
package.path = "./lib/hump/?.lua;"..package.path
package.path = "../lib/hump/?.lua;"..package.path
Class = require "class"
Gamestate = require "gamestate"
Vector = require "vector"

-- Flux
package.path = "./lib/flux/?.lua;"..package.path
package.path = "../lib/flux/?.lua;"..package.path

-- JSON
JSON = require "JSON"

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

function tablePrinter(table)
    for k, v in pairs(table) do
        if type(v) == "table" then
            print(string.format("(table) %s:", k))
            tablePrinter(v)
        else
            print(string.format("%s: %s", k, v))
        end
    end
end

-- -----------------------------------------------
-- 3. Colors
-- -----------------------------------------------
Colors = {
    white =     {255, 255, 255, 255},
    ltgray =    {191, 191, 191, 255},
    gray =      {127, 127, 127, 255},
    dkgray =    {64, 64, 64, 255},
    black =     {0, 0, 0, 255},
    red =       {255, 0, 0, 255},
    green =     {0, 255, 0, 255},
    yellow =    {255, 255, 0, 255},
    blue =      {0, 0, 255, 255}
}

-- -----------------------------------------------
-- 4. Debugging Configuration
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
-- 5. Local (My) Modules
-- -----------------------------------------------
BaseState = require "state"
Map = require "map"
Keybinds = require "keybinds"
PrintRegion = require "print_region"
BaseEntityStatic = require "base_entity_static"
BaseButton = require "base_button"
BaseEntity = require "base_entity"
BaseParticle = require "base_particle"

-- -----------------------------------------------
-- 6. System key-bindings
-- -----------------------------------------------
SystemKeybinds = Keybinds()

-- Quit the game
SystemKeybinds:add(
    "escape",
    love.event.quit,
    nil,
    nil,
    nil,
    "System")

-- Toggle debug enabled
SystemKeybinds:add(
    "g",
    function()
        Debug.flags.enabled = not Debug.flags.enabled
    end,
    nil,
    nil,
    {"lshift", "rshift"},
    "System")

-- Toggle debug draw geometry
SystemKeybinds:add(
    "z",
    function()
        if Debug.flags.enabled then
            Debug.flags.geom = not Debug.flags.geom
        end
    end,
    nil,
    nil,
    nil,
    "System")

-- Toggle debug draw text
SystemKeybinds:add(
    "x",
    function()
        if Debug.flags.enabled then
            Debug.flags.text = not Debug.flags.text
        end
    end,
    nil,
    nil,
    nil,
    "System")

SystemKeybinds:add(
    "c",
    collectgarbage,
    nil,
    nil,
    nil,
    "System")

-- -----------------------------------------------
-- 7. LÖVE Callbacks
-- -----------------------------------------------
function love.load()
    math.randomseed(os.time())
    Gamestate.registerEvents()
end

function love.keypressed(key)
    SystemKeybinds:keypressed(key)
    Gamestate.current().keybinds:keypressed(key)
end

function love.keyreleased(key)
    SystemKeybinds:keyreleased(key)
    Gamestate.current().keybinds:keyreleased(key)
end

function love.update(dt)
    SystemKeybinds:update(dt)
    Gamestate.current().keybinds:update(dt)

    -- Move to a resize event
    --lw.w, lw.h = lw.getWidth(), lw.getHeight()
    --lg.font = lg.getFont()
end

