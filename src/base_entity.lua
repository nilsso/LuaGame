-- Other modules
local Class = require "class"

-- This module
local BaseEntity = Class{
    table,

    pos,
    vel = Vector(0, 0),
    vel_max = 100,
    accel = 60,

    dir = Vector(1, 0),
    phi = 1,

    mvFlags = {
        mvL = false,
        mvR = false,
        mvU = false,
        mvD = false
    },

    info_pr
}
local this = BaseEntity

function BaseEntity:init(x, y)
    self.pos = Vector(x, y)
    self.info_pr = PrintRegion()
end

function BaseEntity:register(t)
    assert(not self.table, string.format("Instance already registered to %s", self.table)))

    self.table = t
    self.table[self] = self
end

function BaseEntity:deregister()
    assert(self.table, "Instance not registered.")

    self.table[self] = nil
end

function BaseEntity:destroy()
    self.deregister()
end

function BaseEntity:update(dt)
    -- Input
    -- self.mvFlags.mvF = K.isDown('w')
    -- self.mvFlags.rL = K.isDown('a')
    -- self.mvFlags.rR = K.isDown('d')

    if (self.mvFlags.mvL or self.mvFlags.mvR) and not (self.mvFlags.mvL and self.mvFlags.mvR) then
        if self.mvFlags.mvL then
            self.x = x-10*dt
        else
            self.x = x+10*dt
        end
    end

    if (self.mvFlags.mvU or self.mvFlags.mvD) and not (self.mvFlags.mvU and self.mvFlags.mvD) then
        if self.mvFlags.mvFlags.mvU then
            self.y = y-10*dt
        else
            self.y = y+10*dt
        end
    end

end

function BaseEntity:draw()
    -- Draw modes
    G.setColor(Colors.gray)

    -- Draw self (primitive circle)
    G.circle("fill", self.pos.x, self.pos.y, self.draw_rad, 32)

    if (Debug.enabled) then
        -- Geometry
        if (Debug.drawGeom) then
            G.setColor(Colors.blue)
            G.circle("line", self.pos.x, self.pos.y, self.draw_rad, 32)
        end

        -- Text
        if (Debug.drawText) then
            -- Update print region coordinates
            if (self.pos.x < W.w/2) then
                self.info_pr.x = self.pos.x-(self.draw_rad+5)
                self.info_pr.anchor = "top-right"
            else
                self.info_pr.x = self.pos.x+(self.draw_rad+5)
                self.info_pr.anchor = "top-left"
            end
            self.info_pr.y = self.pos.y

            -- Add lines to info print region
            self.info_pr:print({
                string.format("(%g,%g)", self.pos.x, self.pos.y),
                string.format("vel=%g", self.vel:len()),
                string.format("mvF=%s", self.mvFlags.mvF),
                string.format("rL=%s", self.mvFlags.rL),
                string.format("rR=%s", self.mvFlags.rR),
            })

            -- Draw print region if instance is of this class
            if (self.__index == this.__index) then
                self.info_pr:draw()
            end
        end
    end

end

return BaseEntity

