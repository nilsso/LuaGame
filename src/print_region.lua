-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local PrintRegion = Class{
    lines,

    pos,
    dim,
    w_max = 100,

    flags = {
        background,
        invert
    },

    colors = {
        back = Colors.black,
        geom = Debug.colors.geom,
        text = Debug.colors.text
    },

    anchor = "top-left",
}
local this = PrintRegion

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(x, y, anchor, w_max)
    self.lines = {}

    self.pos = Vector(x or 0, y or 0)
    self.dim = Vector(0,0)
    self.w_max = w_max or this.w_max

    self.flags = {
        background = false,
        invert = false
    }

    self.colors = {
        back = ShallowCopy(this.colors.back),
        geom = ShallowCopy(this.colors.geom),
        text = ShallowCopy(this.colors.text)
    }

    self.anchor = anchor or this.anchor
end

function this:print(s)
    local w, l = G.font:getWrap(tostring(s), self.w_max)

    -- Check to increase width
    table.insert(self.lines, tostring(s))
    if w > self.dim.x then
        self.dim.x = w
    end

    -- Increase height
    self.dim.y = self.dim.y+l*G.font:getHeight()
end

function this:draw()
    local px, py

    -- Anchor
    if (self.anchor == "top-left") then
        px = self.pos.x
        py = self.pos.y
    elseif (self.anchor == "top") then
        px = self.pos.x-self.dim.x/2
        py = self.pos.y
    elseif (self.anchor == "top-right") then
        px = self.pos.x-self.dim.x
        py = self.pos.y
    elseif (self.anchor == "left") then
        px = self.pos.x
        py = self.pos.y-self.dim.y/2
    elseif (self.anchor == "center") then
        px = self.pos.x-self.dim.x/2
        py = self.pos.y-self.dim.y/2
    elseif (self.anchor == "right") then
        px = self.pos.x-self.dim.x
        py = self.pos.y-self.dim.y/2
    elseif (self.anchor == "bottom-left") then
        px = self.pos.x
        py = self.pos.y-self.dim.y
    elseif (self.anchor == "bottom-center") then
        px = self.pos.x-self.dim.x/2
        py = self.pos.y-self.dim.y
    elseif (self.anchor == "bottom-right") then
        px = self.pos.x-self.dim.x
        py = self.pos.y-self.dim.y
    else
        assert(false, "Unknown anchor position")
    end

    -- Background
    if self.flags.background then
        G.setColor(self.colors.back)
        G.rectangle("fill", px, py, self.dim.x, self.dim.y)
    end

    -- Print lines
    G.setColor(self.colors.text)
    local i = 0
    for _, line in ipairs(self.lines) do
        G.printf(line, px, py+(i*G.font:getHeight()), self.dim.x, "left")
        i = i+select(2, G.font:getWrap(line, self.dim.x))
    end

    if Debug.enabled and Debug.draw_geom then
        G.setColor(self.colors.geom)
        G.rectangle("line", px, py, self.dim.x, i*G.font:getHeight())
    end

    -- Reset
    self.lines = {}
    self.dim = Vector(0,0)
end

return this

