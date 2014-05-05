-- Other modules
local Class = require "class"

-- This module
local PrintRegion = Class{}
function PrintRegion:init(x, y, anchor, w, h)
    self.pos = Vector(x,y)
    self.anchor = anchor or "top-left"
    self.w = w or 200
    self.h = h or 100
    self.lines = {}
end

function PrintRegion:print(s)
    local _type = type(s)

    -- Add item(s) to print to lines
    if _type == "table" then
        for k, v in pairs(s) do
            table.insert(self.lines, tostring(v))
        end else
        table.insert(self.lines, tostring(s))
    end
end

function PrintRegion:draw()
    local px, py = 0, 0

    -- Anchor
    if (self.anchor == "top-left") then
        px = self.pos.x
        py = self.pos.y
    elseif (self.anchor == "top") then
        px = self.pos.x - self.w/2
        py = self.pos.y
    elseif (self.anchor == "top-right") then
        px = self.pos.x - self.w
        py = self.pos.y
    elseif (self.anchor == "left") then
        px = self.pos.x
        py = self.pos.y - self.h/2
    elseif (self.anchor == "center") then
        px = self.pos.x - self.w/2
        py = self.pos.y - self.h/2
    elseif (self.anchor == "right") then
        px = self.pos.x - self.w
        py = self.pos.y - self.h/2
    elseif (self.anchor == "bottom-left") then
        px = self.pos.x
        py = self.pos.y - self.h
    elseif (self.anchor == "bottom-center") then
        px = self.pos.x - self.w/2
        py = self.pos.y - self.h
    elseif (self.anchor == "bottom-right") then
        px = self.pos.x - self.w
        py = self.pos.y - self.h
    else
        assert(false, "Unknown anchor position")
    end

    -- Set draw modes
    G.setColor(Colors.white, 255)

    local i = 0
    for _, line in ipairs(self.lines) do
        -- Print wrapped line
        G.printf(
            line,
            px,
            py + (i * G.getFont():getHeight()),
            self.w,
            "left")

        i = i + select(2, G.getFont():getWrap(line, self.w))
    end

    -- Clear lines
    self.lines = {}

    -- Debug draw
    if Debug.enabled then
        if Debug.drawGeom then
            -- Set draw modes
            G.setColor(Colors.blue, 255)
            G.setLineWidth(1)

            G.rectangle("line", px, py, self.w, self.h)
        end
    end
end

-- Return this module
return PrintRegion

