-- Other modules
local Class = require "class"

-- This module
local BaseState = Class{}

function BaseState:init()
    -- Entity list and print region
    self.entities = self.entities or setmetatable({}, {__mode = "k"})
    self.entities_pr = PrintRegion(W.w - 5, 5, "top-right", 200, W.h - 10)

    -- Info print region
    self.info_pr = PrintRegion(5, 5, "top-left", 200, W.h - 10)

    self.dt = 0
end

function BaseState:entity_count(e)
    local i = 0

    for k, v in pairs(self.entities) do
        if (e and v.__index == e.__index) then
            i = i + 1
        else
            i = i + 1
        end
    end

    return i
end

function BaseState:keypressed(key)
    if self.keybinds[key] then
        local bool = false
        if #self.keybinds[key][1] > 0 then
            for _, i in ipairs(self.keybinds[key][1]) do
                if K.isDown(i) then
                    bool = true
                    break
                end
            end
        else
            bool = true
        end
        if bool then
            self.keybinds[key][2]()
        end
    end
end

function BaseState:mousepressed(x, y, key)
    for k, v in pairs(self.entities) do
        if v.capturing ~= nil and v:capturing() then
            v:mousepressed(key)
        end
    end
end

function BaseState:update(dt)
    for k, v in pairs(self.entities) do
        v:update(dt)
    end
end

function BaseState:draw()
    for k, v in pairs(self.entities) do
        v:draw()
    end

    -- Debug draw
    if Debug.enabled then
        -- Geometry
        if Debug.drawGeom then
            -- Set draw modes
            G.setColor(Colors.blue)
            G.setLineWidth(1)

            -- Window dividers
            G.line(0, W.getHeight()/2, W.getWidth(), W.getHeight()/2)
            G.line(W.getWidth()/2, 0, W.getWidth()/2, W.getHeight())
        end

        -- Text
        if Debug.drawText then
            G.setColor(Colors.white)

            -- Entity print region
            self.entities_pr:print({
                string.format("ENTITIES (count=%s)", self:entity_count()),
            })
            self.entities_pr:print(self.entities)
            self.entities_pr:draw()

            -- Info print region
            self.info_pr:print({
                string.format("State: %s", self.name),
                string.format("mouse.pos(%i,%i)", M.getPosition()),
            })
            self.info_pr:draw()
        end
    end
end

-- Module
return BaseState

