-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local BaseState = Class{
    entities,

    keybinds = {},

    colors = {
        dbg_geom = ShallowCopy(Colors.blue),
        dbg_text = ShallowCopy(Colors.white)
    },

    entitire_pr,
    info_pr
}
local this = BaseState

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init()
    -- Entity list
    self.entities = self.entities or setmetatable({}, {__mode = "k"})

    -- Print regions
    self.info_pr = PrintRegion(5, 5, "top-left")
    self.entities_pr = PrintRegion(W.w-5, 5, "top-right")
end

function this:entityCount(e)
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

function this:keypressed(key)
    if self.keybinds[key] then
        local bool = true
        bool = K.isDown("lshift")

        if #self.keybinds[key][1] > 0 then
            -- Modifier requirement
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

function this:mousepressed(x, y, key)
    for k, v in pairs(self.entities) do
        if v.mousepressed and v:capturing() then
            v:mousepressed(key)
        end
    end
end

function this:update(dt)
    for k, v in pairs(self.entities) do
        if v.update then
            v:update(dt)
        end
    end
end

function this:draw()
    -- Call entity draw functions
    for k, v in pairs(self.entities) do
        -- Entity normal drawing
        if v.draw then
            v:draw()
        end

        -- Entity debug drawing
        if Debug.enabled then
            -- Debug geometry
            if Debug.draw_geom and v.drawDebugGeom then
                v:drawDebugGeom()
            end

            -- Debug text
            if Debug.draw_text and v.drawDebugText then
                v:drawDebugText()
            end
        end
    end

    -- Debug drawing
    if Debug.enabled then
        if Debug.draw_geom then
            self:drawDebugGeom()
        end

        if Debug.draw_text then
            self:drawDebugText()
        end
    end
end

function this:drawDebugGeom()
    -- Set draw modes
    G.setColor(self.colors.dbg_geom)
    G.setLineWidth(1)

    -- Window dividers
    G.line(0, W.getHeight()/2, W.getWidth(), W.getHeight()/2)
    G.line(W.getWidth()/2, 0, W.getWidth()/2, W.getHeight())
end

function this:drawDebugText()
    -- Set color
    G.setColor(self.colors.dbg_text)

    -- Info print region
    self.info_pr:print(string.format("State: %s", self.name))
    self.info_pr:print(string.format("mouse.pos(%i,%i)", M.getPosition()))
    self.info_pr:draw()

    -- Set color
    G.setColor(self.colors.dbg_text)

    -- Entity print region
    self.entities_pr.pos.x = W.w-5
    self.entities_pr:print(string.format("ENTITIES (count=%d)", self:entityCount()))
    for k, v in pairs(self.entities) do
        self.entities_pr:print(v)
    end
    self.entities_pr:draw()
end

-- Module
return BaseState

