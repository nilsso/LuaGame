-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local BaseEntityStatic = Class{
    __includes = nil,
    table = nil,

    pos = Vector(W.w/2,W.h/2),
    dim = Vector(16,16),

    bounds,

    colors = {
        back = Colors.gray,
        dbg_geom = Colors.blue,
        dbg_text = Colors.white
    },

    info_pr
}
local this = BaseEntityStatic

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(x, y, w, h)

    self.pos = Vector(
        x or this.pos.x,
        y or this.pos.y)
    self.dim = Vector(
        w or this.dim.x,
        h or this.dim.y)

    self.bounds = {l,t,r,b}

    self.colors = {
        back = ShallowCopy(this.colors.back),
        dbg_geom = ShallowCopy(this.colors.dbg_geom),
        dbg_text = ShallowCopy(this.colors.dbg_text)
    }
    self.info_pr = PrintRegion()
end

function this:register(t)
    -- Assert that instance is not registered
    assert(not self.table, string.format("Cannot register %s because it is already registered.", self))

    self.table = t
    self.table[self] = self
end

function this:deregister()
    -- Assert that instance is registered
    assert(self.table, string.format("Cannot deregister %s because it is not registered.", self))

    self.table[self] = nil
end

function this:destroy()
    self:deregister()
end

function this:updateBounds()
    self.bounds.l = self.pos.x-self.dim.x/2
    self.bounds.t = self.pos.y-self.dim.y/2
    self.bounds.r = self.pos.x+self.dim.x/2
    self.bounds.b = self.pos.y+self.dim.y/2
end

function this:capturing()
    local mx, my = M.getPosition()
    return (
        mx >= self.bounds.l and
        mx <= self.bounds.r and
        my >= self.bounds.t and
        my <= self.bounds.b)
end

function this:update(dt)
    self:updateBounds()
end

function this:draw()
    -- Set color
    G.setColor(self.colors.back)

    -- Draw primative
    G.rectangle("fill",
        self.bounds.l, self.bounds.t,
        self.dim.x, self.dim.y)
end

function this:drawDebugGeom()
    -- Draw mode
    G.setColor(self.colors.dbg_geom)

    -- Bounding rectangle
    G.rectangle("line",
        self.bounds.l, self.bounds.t,
        self.dim.x, self.dim.y)
end

function this:drawDebugText()
    -- Draw mode
    G.setColor(self.colors.dbg_text)

    -- Update print region coordinates
    if (self.pos.x < W.w/2) then
        self.info_pr.pos.x = self.bounds.r+5
        self.info_pr.anchor = "top-left"
    else
        self.info_pr.pos.x = self.bounds.l-5
        self.info_pr.anchor = "top-right"
    end
    self.info_pr.pos.y = self.bounds.t

    -- Add lines to print region
    self.info_pr:print(string.format("pos=(%g,%g)", self.pos.x, self.pos.y))
    self.info_pr:print(string.format("dim=(%i,%i)", self.dim.x, self.dim.y))

    -- Draw print region if instance is of BaseEntityStatic class
    if (self.__index == this.__index) then
        self.info_pr:draw()
    end
end

return this

