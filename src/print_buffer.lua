-- -----------------------------------------------
-- Class definition
-- -----------------------------------------------
local PrintBuffer = Class{
    -- Class variables
    __includes = nil,

    -- Instance variables
    pos,
    dim,
    lines,
    num_lines,
    start_line
}

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
-- Constructor
function PrintBuffer:init(x, y, w, h)
    self.pos = Vector(x or 0, y or 0)
    self.dim = Vector(w or 100, h or 500)
    self.lines = {}
    self.start_line = 0
    self.num_lines = 0
    self.max_lines = math.floor(self.dim.y / (lg.getFont():getHeight() + 2))
end

-- Add a line to lines
function PrintBuffer:add(line)
    table.insert(self.lines, line)
    local num_lines = select(2, lg.getFont():getWrap(line, self.dim.x))
    self.num_lines = self.num_lines + lg.getFont():getWrap(line, self.dim.x)
end

-- Scroll up 1 line
function PrintBuffer:scrollUp()
    if self.start_line > 0 then
        self.start_line = self.start_line - 1
    end
end

-- Scroll down 1 line
function PrintBuffer:scrollDown()
    if self.start_line < (#self.lines - self.max_lines) then
        self.start_line = self.start_line + 1
    end
end

-- Scroll to first line
function PrintBuffer:scrollTop()
    self.start_line = 0
end

-- Scroll to last line
function PrintBuffer:scrollBottom()
    self.start_line = #self.lines - self.max_lines
end

function PrintBuffer:draw()
    if #self.lines > 0 then
        local f = lg.getFont()
        local fh = f:getHeight()

        lg.setColor(255, 255, 255)
        local y = 0
        -- Draw lines
        for k, v in next, self.lines, self.start_line do
            lg.printf(v, self.pos.x, self.pos.y + y, self.dim.x, "left")
            y = y + select(2, f:getWrap(v, self.dim.x)) * (fh + 2)
            if y + fh + 2 > self.dim.y then break end
        end

        -- Scroll rectangle
        local bar_height = self.dim.y * (self.max_lines / #self.lines)
        if bar_height > self.dim.y then
            bar_height = self.dim.y
        end
        lg.rectangle(
            "fill",
                self.pos.x + self.dim.x - 8,
                self.pos.y + self.start_line * (self.dim.y / #self.lines),
                8,
                bar_height)

        -- Bounding rectangle
        lg.setColor(0, 0, 255)
        lg.rectangle("line", self.pos.x, self.pos.y, self.dim.x, self.dim.y)
    end
end

-- Return this module
return PrintBuffer

