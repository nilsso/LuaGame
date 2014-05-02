local PrintRegion = Class{}
function PrintRegion:init(x, y, anchor, w, h)
    self.x = x or 0
    self.y = y or 0
    self.anchor = anchor or "top-left"
    self.w = w or 200
    self.h = h or 100
    self.lines = {}
end

function PrintRegion:print(s)
    local _type = type(s)

    -- Add item(s) to print to lines
    if _type == "table" then
        for _, line in ipairs(s) do
            table.insert(self.lines, tostring(line))
        end else
        table.insert(self.lines, tostring(s))
    end
end

function PrintRegion:draw()
    local px, py = 0, 0

    -- Anchor
    if (self.anchor == "top-left") then
        px = self.x
        py = self.y
    elseif (self.anchor == "top") then
        px = self.x - self.w/2
        py = self.y
    elseif (self.anchor == "top-right") then
        px = self.x - self.w
        py = self.y
    elseif (self.anchor == "left") then
        px = self.x
        py = self.y - self.h/2
    elseif (self.anchor == "center") then
        px = self.x - self.w/2
        py = self.y - self.h/2
    elseif (self.anchor == "right") then
        px = self.x - self.w
        py = self.y - self.h/2
    elseif (self.anchor == "bottom-left") then
        px = self.x
        py = self.y - self.h
    elseif (self.anchor == "bottom-center") then
        px = self.x - self.w/2
        py = self.y - self.h
    elseif (self.anchor == "bottom-right") then
        px = self.x - self.w
        py = self.y - self.h
    else
        assert(false, "Unknown anchor position")
    end

    -- Set draw modes
    G.setColor(Colors.white)

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
            G.setColor(Colors.blue)
            G.setLineWidth(1)

            G.rectangle("line", px, py, self.w, self.h)
        end
    end
end

return PrintRegion

