Class = require("class")
Colors = require("colors")

ButtonBase = Class{
    init = function(self, text, x, y, w, h, func, colN, colH, colP)
        self.text, self.x, self.y, self.w, self.h = text, x, y, w, h
        self.func = func or nil
        self.colors = {
            normal = colN or Colors.gray,
            highlight = colH or Colors.white,
            press = colP or Colors.blue
        }
        self.color = self.colors.normal
        self.bounds = {
            left = x-w/2,
            top = y-h/2,
            right = x+w/2,
            bottom = y+h/2
        }
    end
}

function ButtonBase:capturing()
    local mx, my = M.getPosition()
    return (
        mx >= self.bounds.left and
        mx <= self.bounds.right and
        my >= self.bounds.top and
        my <= self.bounds.bottom)
end

function ButtonBase:draw()
    -- Geometry
    if not self:capturing() then
        self.color = self.colors.normal
    elseif not M.isDown('l') then
        self.color = self.colors.highlight
    else
        self.color = self.colors.press
    end

    G.setColor(self.color)
    G.rectangle("fill", self.bounds.left, self.bounds.top, self.w, self.h)

    -- Text
    G.setColor(Colors.black)
    G.print(self.text,
        self.x-G.getFont():getWidth(self.text)/2,
        self.y-G.getFont():getHeight(self.text)/2)

    -- Debug draw
    G.setColor(Colors.white)
    if Debug.enabled then
        local i = 0
        for k, v in pairs(self.bounds) do
            G.print(string.format("%s = %i", k, v), 5+self.x+self.w/2, 12*i+self.y-self.h/2)
            i = i + 1
        end
    end
end

function ButtonBase:update(dt)
end

-- Module
return ButtonBase

