-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local BaseEntityStatic = Class{
    __includes = nil,
    table,

    pos,
    dim = Vector(16, 16),

    draw_col = Colors.gray,

    info_pr
}
local this = BaseEntityStatic

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(x, y)
    self.pos = Vector(x,y)

    self.info_pr = PrintRegion()
end

function this:register(t)
    assert(not self.table, "Cannot register, already registered.")

    self.table = t
    self.table[self] = self
end

function this:deregister()
    assert(self.table, "Cannot deregister, not registered yet.")
    self.table[self] = nil
end

function this:destroy()
    self:deregister()
end

function this:draw()
    -- Draw mode
    G.setColor(self.draw_col)

    -- Draw primative
    G.rectangle("fill",
        self.x-self.dim.x/2, self.y-self.dim.y/2,
        self.x+self.dim.x/2, self.y+self.dim.y/2)
end

function this:drawDebugGeom()
    -- Draw mode
    G.setColor(Colors.blue)

    -- Bounding rectangle
    G.rectangle("line",
        self.x-self.dim.x/2, self.y-self.dim.y/2,
        self.x+self.dim.x/2, self.y+self.dim.y/2)
end

function this:drawDebugText()
    -- Update print region coordinates
    if (self.pos.x < W.w/2) then
        self.info_pr.pos.x = self.pos.x+(self.draw_rad+5)
        self.info_pr.anchor = "top-left"
    else
        self.info_pr.pos.x = self.pos.x-(self.draw_rad+5)
        self.info_pr.anchor = "top-right"
    end
    self.info_pr.pos.y = self.pos.y

    -- Add lines to print region
    self.info_pr:print({
        string.format("pos=(%g,%g)", self.pos.x, self.pos.y),
        string.format("dim=(%i,%i)", self.dim.x, self.dim.y)
    })

    -- Draw print region if instance is of this class
    if (self.__index == this.__index) then
        self.info_pr:draw()
    end
end

return this

