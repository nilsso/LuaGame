Class = require "class"
Vector = require "vector"

EntityBase= Class{
    init = function(self, pos)
        self.pos = pos
    end,
    speed = 0
}

function EntityBase:update(dt)
    local delta = Vector(0,0)
end

function EntityBase:draw()
    love.graphics.line(pos.x-5, pos.y, pos.x+5, pos.y)
    love.graphics.line(pos.x, pos.y-5, pos.x, pos.y+5)
end

