-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local BaseState = Class{
    entities,
    keybinds,
    info_pr,
    entities_pr
}
local this = BaseState

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init()
    self.entities = self.entities or setmetatable({}, {__mode = "k"})
    self.keybinds = self.keybinds or Keybinds()
    self.info_pr = self.info_pr or PrintRegion(5, 5, "top-left")
    self.entities_pr = self.entities_pr or PrintRegion(lw.w-5, 5, "top-right")
end

function this:mousepressed(x, y, button)
    for k, v in pairs(self.entities) do
        if v:capturing() then
            v:mousepressed(button)
        end
    end
end

local function printButtonStates()
    local l = {}
end

function this:update(dt)
    -- Mouse down
    if lm.isDown("l") then
        for k, v in pairs(self.entities) do
            if v:capturing() then
                if v.press then
                    v:press("l")
                end
            end
        end
    end

    -- Update all entities
    for k, v in pairs(self.entities) do
        if v.update then
            v:update(dt)
        end
    end
end

function this:draw()
    -- Normal drawing
    for k, v in pairs(self.entities) do
        if v.draw then
            v:draw()
        end
    end

    -- Debug mode drawing
    if Debug.flags.enabled then
        -- Debug mode geometry drawing
        if Debug.flags.geom then
            -- Entities
            for k, v in pairs(self.entities) do
                if Debug.flags.geom and v.drawDebugGeom then
                    v:drawDebugGeom()
                end
            end

            -- State
            self:drawDebugGeom()
        end

        -- Debug mode text drawing
        if Debug.flags.text then
            -- Entities
            for k, v in pairs(self.entities) do
                if Debug.flags.text and v.drawDebugText then
                    v:drawDebugText()
                end
            end

            -- State
            self:drawDebugText()
        end
    end
end

function this:drawDebugGeom()
    -- Graphics draw color
    lg.setColor(Debug.colors.geom)

    -- Graphics line width
    lg.setLineWidth(1)

    -- Draw a horrizontal and a vertical line to divide the window
    lg.line(0, lw.h / 2, lw.w, lw.h / 2)
    lg.line(lw.w / 2, 0, lw.w / 2, lw.w)
end

function this:drawDebugText()
    -- Add lines to the info print region
    self.info_pr:print(string.format("State: %s", self.name))
    self.info_pr:print(string.format("mouse.pos(%i,%i)", lm.getPosition()))
    -- Draw the info print region
    self.info_pr:draw()

    -- Add lines to the entities print region
    self.entities_pr.pos.x = lw.w - 5
    self.entities_pr:print(string.format("ENTITIES (count=%d)", self:entityCount()))
    for k, v in pairs(self.entities) do
        -- Add each entity
        self.entities_pr:print(self)
    end
    -- Draw the entities print region
    self.entities_pr:draw()
end

function this:entityCount(e)
    local i = 0

    -- For each entity
    for k, v in pairs(self.entities) do
        -- If entity type matches current entity or type not specified
        if (not e or v.__index == e.__index) then
            i = i + 1
        end
    end

    -- Return entity count
    return i
end

-- Return this module
return this

