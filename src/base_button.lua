local Class = require "class"

local BaseButton = Class{
    bounds = {
        left,
        top,
        right,
        bottom
    },
    colors = {
        default = {
            normal = Colors.gray,
            highlight = Colors.white,
            press = Colors.blue
        },
        normal = nil,
        highlight = nil,
        press = nil
    },
    color
}

function BaseButton:keypressed(key)
end

function BaseButton:mousepressed(button)
    if self.func and button == 'l' then
        self.func()
    end
end

function BaseButton:update(dt)
    if not self:capturing() then
        self.color = self.colors.normal
    elseif not m.isDown('l') then
        self.color = self.colors.highlight
    else
        self.color = self.colors.press
    end
end

function BaseButton:init(text, x, y, func, w, h, colN, colH, colP)
    assert(text, x, y, func)
    self.text, self.x, self.y, self.func = text, x, y, func
    self.w, self.h = 100, 20
    self.colors = {
        normal = colN or self.colors.default.normal,
        highlight = colH or self.colors.default.highlight,
        press = colP or self.colors.default.press
    }
    self:calcBounds()
end

function BaseButton:draw()
    -- Geometry
    g.setColor(self.color)
    g.rectangle("fill", self.bounds.left, self.bounds.top, self.w, self.h)

    -- Text
    g.setColor(Colors.black)
    g.print(
        self.text,
        self.x-g.getFont():getWidth(self.text)/2,
        self.y-g.getFont():getHeight(self.text)/2)
end

function BaseButton:calcBounds()
    self.bounds.left = self.x-self.w/2
    self.bounds.top = self.y-self.h/2
    self.bounds.right = self.x+self.w/2
    self.bounds.bottom = self.y+self.h/2
end

function BaseButton:capturing()
    local mx, my = love.mouse.getPosition()
    return (
        mx >= self.bounds.left and
        mx <= self.bounds.right and
        my >= self.bounds.top and
        my <= self.bounds.bottom)
end

-- Module
return BaseButton

