local EntityBase= Class{
    -- Properties
    speed = 1,
    vector = Vector(0, 0),

    flags = {
        mvF = false,
        mvB = false,
        rR = false,
        rL = false
    },

    radius = 8,
}

function EntityBase:init(x, y, facing)
    assert(x, y)
    self.x = x
    self.y = y
    self.facing = facing or Vector(0,0)
end

function EntityBase:update(dt)
    if (self.flags.mvF or self.flags.mvB) and not (self.flags.mvF or self.flags.mvB) then
        if self.flags.mvF then

        else
            -- Move backward
        end
    else
    end
end

function EntityBase:draw()
    g.setColor(Colors.gray)
    g.circle("fill", self.x, self.y, self.radius, 32)
end

return EntityBase

