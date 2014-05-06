-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local PrintRegion = Class{
    pos = Vector(0,0),
    anchor = "top-left",
    lines = {},
    w = 0,
    w_max = 100
}
local this = PrintRegion

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(x, y, anchor, w_max)
    self.pos = Vector(x,y)
    self.anchor = anchor or self.anchor
    self.w_max = w_max or self.w_max
end

function this:print(s)
    local w = G.font:getWrap(tostring(s), self.w_max)

    table.insert(self.lines, tostring(s))
    if w > self.w then
        self.w = w
    end
end

function this:draw()
    local px
    local py = self.pos.y

    -- Anchor
    if (self.anchor == "top-left") then
        px = self.pos.x
    elseif (self.anchor == "top") then
        px = self.pos.x-self.w/2
    elseif (self.anchor == "top-right") then
        px = self.pos.x-self.w
    elseif (self.anchor == "left") then
        px = self.pos.x
    elseif (self.anchor == "center") then
        px = self.pos.x-self.w/2
    elseif (self.anchor == "right") then
        px = self.pos.x-self.w
    elseif (self.anchor == "bottom-left") then
        px = self.pos.x
    elseif (self.anchor == "bottom-center") then
        px = self.pos.x-self.w/2
    elseif (self.anchor == "bottom-right") then
        px = self.pos.x-self.w
    else
        assert(false, "Unknown anchor position")
    end

    -- Print lines
    local i = 0
    for _, line in ipairs(self.lines) do
        G.printf(line, px, py+(i*G.font:getHeight()), self.w, "left")
        i = i+select(2, G.font:getWrap(line, self.w))
    end

    if Debug.enabled and Debug.draw_pr_bounds and Debug.draw_geom then
        G.setColor(Colors.blue)
        G.rectangle("line", px, py, self.w, i*G.font:getHeight())
    end

    -- Clear lines
    self.lines = {}
    self.w = 0
end

-- Return this module
return PrintRegion

