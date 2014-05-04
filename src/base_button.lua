-- Other modules
local Class = require "class"

-- This module
local BaseButton = Class{
    bounds = {
        left,
        top,
        right,
        bottom
    },
    colors = {
        back_normal = Colors.gray,
        back_highlight = Colors.white,
        back_press = Colors.blue,
        back
    },
    func_press,
    func_down,
    func_release
}
local this = BaseButton

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

function BaseButton:init(s, x, y, w, h)
    -- Assert arguments
    assert(s)
    assert(x)
    assert(y)

    self.text, self.x, self.y = s, x, y
    self.w = 100 or w
    self.h = 20 or h
    self:calcBounds()
end

function BaseButton:mousepressed(b)
    if (self.func_press and b == 'l') then
        self.func_press()
    end
end

function BaseButton:mousereleased(b)
    if (self.func_release and b == 'l') then
        self.func_releas()
    end
end

function BaseButton:update(dt)
    if (self.func_down and self:capturing() and M.isDown("l")) then
        self.func_down()
    end
end

function BaseButton:draw()
    if (not self:capturing()) then
        self.colors.back = self.colors.back_normal
    elseif (not M.isDown('l')) then
        self.colors.back = self.colors.back_highlight
    else
        self.colors.back = self.colors.back_press
    end

    -- Geometry
    G.setColor(self.colors.back)
    G.rectangle("fill", self.bounds.left, self.bounds.top, self.w, self.h)

    -- Text
    G.setColor(Colors.black)
    G.print(
        self.text,
        self.x-G.getFont():getWidth(self.text)/2,
        self.y-G.getFont():getHeight(self.text)/2)
end

-- Module
return BaseButton

