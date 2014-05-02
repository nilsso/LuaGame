local BaseEntity = Class{}

function BaseEntity:init(t, x, y)
    table.insert(t, self)

    self.pos = Vector(x, y)

    self.vel = Vector(0, 0)
    self.vel_max = 100
    self.accel = 60

    self.dir = Vector(1, 0)
    self.phi = 1

    self.flags = {
        mvF = false,
        mvB = false,
        rL = false,
        rR = false,
    }

    self.draw_rad = 8
    self.draw_col = Colors.gray

    self.info_pr = PrintRegion()
end

function BaseEntity:destroy()
    -- table.remove(self.table, self.index)
end

function BaseEntity:update(dt)
    -- Input
    --self.flags.mvF = K.isDown('w')
    --self.flags.rL = K.isDown('a')
    --self.flags.rR = K.isDown('d')

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

function BaseEntity:draw()

    -- Draw modes
    G.setColor(self.draw_col)

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
            self.info_pr.x = self.x
            self.info_pr.y = self.y
            if (self.x < W.w/2) then
                self.info_pr.anchor = "top-right"
            else
                self.info_pr.anchor = "top-left"
            end
            self.info_pr:print(string.format("(%g,%g)", self.pos.x, self.pos.y))
            self.info_pr:print("vel=%g", self.vel:len())
            self.info_pr:print("mvF=%s", self.flags.mvF)
            self.info_pr:print("rL=%s", self.flags.rL)
            self.info_pr:print("rR=%s", self.flags.rR)
        end
    end
end

return BaseEntity

