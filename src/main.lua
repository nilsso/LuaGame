-- Load the engine
local engine = require("engine")

-- -----------------------------------------------
-- States
-- -----------------------------------------------
local Menu = BaseState()
Menu.name = "Menu"

local Game = BaseState()
Game.name = "Game"

-- Initialize game state mechanism
Gamestate.switch(Game)

-- -----------------------------------------------
-- Map
-- -----------------------------------------------
do
    local map = Map(io.open("map/map.json", "r"))

    print(map)
    map:print()
end

-- -----------------------------------------------
-- Entities
-- -----------------------------------------------
if false then
    local entity1 = BaseEntityStatic()
    entity1.pos = Vector(lw.w / 2, lw.h / 2)
    entity1:register(Game.entities)

    local d = 200

    local left = function(dt) entity1.pos.x = entity1.pos.x - d * dt end
    local right = function(dt) entity1.pos.x = entity1.pos.x + d * dt end
    local up = function(dt) entity1.pos.y = entity1.pos.y - d * dt end
    local down = function(dt) entity1.pos.y = entity1.pos.y + d * dt end

    -- Buttons
    local buttonUp = BaseButton(lw.w / 2, lw.h - 65)
    buttonUp.text = "UP"
    buttonUp.func.down = up
    buttonUp.i1 = 0
    buttonUp:register(Game.entities)

    local buttonLeft = BaseButton(lw.w / 2 - 105, lw.h - 40)
    buttonLeft.text = "LEFT"
    buttonLeft.func.down = left
    buttonLeft.i1 = 0
    buttonLeft:register(Game.entities)

    local buttonRight = BaseButton(lw.w / 2 + 105, lw.h - 40)
    buttonRight.text = "RIGHT"
    buttonRight.func.down = right
    buttonRight.i1 = 0
    buttonRight:register(Game.entities)

    local buttonDown = BaseButton(lw.w / 2, lw.h - 15)
    buttonDown.text = "DOWN"
    buttonDown.func.down = down
    buttonDown.i1 = 0
    buttonDown:register(Game.entities)
end

-- -----------------------------------------------
-- Key binds
-- -----------------------------------------------
if false then
Game.keybinds:add(
    "left",
    nil,
    function()
        buttonLeft:press()
    end,
    nil,
    nil,
    "Entity")

Game.keybinds:add(
    "right",
    nil,
    function()
        buttonRight:press()
    end,
    nil,
    nil,
    "Entity")

Game.keybinds:add(
    "up",
    nil,
    function()
        buttonUp:press()
    end,
    nil,
    nil,
    "Entity")

Game.keybinds:add(
    "down",
    nil,
    function()
        buttonDown:press()
    end,
    nil,
    nil,
    "Entity")
end

