local EntityBase= Class{
    -- Properties
    key,
    speed = 1,
    radius = 8,

    position,

    vel = Vector(0, 0),
    dir = Vector(1, 0),

    accel = 60,

    phi = 2 * math.pi,

    flags = {
        mvF = false,
        mvB = false,
        rR = false,
        rL = false
    }
}

function EntityBase:init(x, y)
    self.pos = Vector(x, y)
end

function EntityBase:update(dt)
    -- Input
    self.flags.mvF = k.isDown('w')
    self.flags.rL = k.isDown('a')
    self.flags.rR = k.isDown('d')

    if (self.flags.mvF or self.flags.mvB) and not (self.flags.mvF and self.flags.mvB) then
        if self.flags.mvF then
            self.vel = self.vel + self.dir * self.accel * dt
        else
        end
    elseif self.vel:len() ~= 0 then
        if self.vel:len() > 0 then
            local delta = self.dir * self.accel * dt
            if self.vel:len() < delta:len() then
                self.vel = Vector(0, 0)
            else
                self.vel = self.vel - delta
            end
        end
    end

    if (self.flags.rL or self.flags.rR) and not (self.flags.rL and self.flags.rR) then
        if self.flags.rL then
            self.vel = self.vel:rotated(-self.phi * dt)
        else
            self.vel = self.vel:rotated(self.phi * dt)
        end
    end

    if self.vel:len() ~= 0 then
        self.dir = self.vel:normalized()
    end

    self.pos = self.pos + self.vel * dt
end

function EntityBase:draw()
    g.setColor(Colors.gray)
    g.circle("fill", self.pos.x, self.pos.y, self.radius, 32)

    if (Debug.enabled) then
        g.setColor(Colors.white)
        g.print(
            string.format("(%g,%g)", self.pos.x, self.pos.y),
            self.pos.x + self.radius + 5,
            self.pos.y - self.radius)
        g.print(
            string.format("vel=%g", self.vel:len()),
            self.pos.x + self.radius + 5,
            self.pos.y - self.radius+1*14)
        g.print(
            string.format("mvF=%s", self.flags.mvF),
            self.pos.x + self.radius + 5,
            self.pos.y - self.radius+2*14)
        g.print(
            string.format("rL=%s", self.flags.rL),
            self.pos.x + self.radius + 5,
            self.pos.y - self.radius+3*14)
        g.print(
            string.format("rR=%s", self.flags.rR),
            self.pos.x + self.radius + 5,
            self.pos.y - self.radius+4*14)
    end
end

return EntityBase

