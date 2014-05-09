-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local BaseState = Class{
    -- Entities
    entities,

    -- Print regions
    entitire_pr,
    info_pr
}
local this = BaseState

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init()
    -- Initialize entity table if nil
    self.entities = self.entities or setmetatable({}, {__mode = "k"})

    -- Initialize print regions if nil
    self.info_pr = self.info_pr or PrintRegion(5, 5, "top-left")
    self.entities_pr = self.entities_pr or PrintRegion(W.w-5, 5, "top-right")
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

function this:update(dt)
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
    G.setColor(Debug.colors.geom)

    -- Graphics line width
    G.setLineWidth(1)

    -- Draw a horrizontal and a vertical line to divide the window
    G.line(0, W.getHeight()/2, W.getWidth(), W.getHeight()/2)
    G.line(W.getWidth()/2, 0, W.getWidth()/2, W.getHeight())
end

function this:drawDebugText()
    -- Add lines to the info print region
    self.info_pr:print(string.format("State: %s", self.name))
    self.info_pr:print(string.format("mouse.pos(%i,%i)", M.getPosition()))
    -- Draw the info print region
    self.info_pr:draw()

    -- Add lines to the entities print region
    self.entities_pr.pos.x = W.w-5
    self.entities_pr:print(string.format("ENTITIES (count=%d)", self:entityCount()))
    for k, v in pairs(self.entities) do
        -- Add each entity
        self.entities_pr:print(self)
    end
    -- Draw the entities print region
    self.entities_pr:draw()
end

-- Return this module
return this

