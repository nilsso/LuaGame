-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local BaseEntity = Class{
    __includes = BaseEntityStatic,

    dir = Vector(1,0),
    vel = Vector(0,0),
    velMax = 100,
    accel = 200,
    phi = math.pi/2,

    mv_flags = {
        --
        mv_l = false,   -- Left
        mv_r = false,   -- Right
        mv_u = false,   -- Up
        mv_d = false,   -- Down

        --
        r_l = false,    -- Rotate left (counter-clockwise)
        r_r = false,    -- Rotate right (clockwise)
        mv_f = false,   -- Forward
        mv_b = false,   -- Backwards
        mv_p = false,   -- Port
        mv_s = false    -- Starboard
    },
}
local this = BaseEntity

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(x, y)
    BaseEntityStatic.init(self, x, y)
end

function this:update(dt)
    -- Move left/right
    if xor(self.mv_flags.mv_l, self.mv_flags.mv_r) then
        if self.mv_flags.mv_l then
        else
        end
    end

    -- Move up/down
    if xor(self.mv_flags.mv_u, self.mv_flags.mv_d) then
        if self.mv_flags.mv_u then
        else
        end
    end

    -- Rotate
    if xor(self.mv_flags.r_l, self.mv_flags.r_r) then
        if self.mv_flags.r_l then
            -- Left (counter-clockwise)
            self.dir = self.dir:rotated(-self.phi*dt)
        else
            -- Right (clockwise)
            self.dir = self.dir:rotated(self.phi*dt)
        end
    end

    -- Move forward/backwards
    if xor(self.mv_flags.mv_f, self.mv_flags.mv_b) then
        if self.mv_flags.mv_f then
            -- Forward
            self.vel = self.vel+(self.dir*self.accel*dt)
        else
            -- Backwards
        end
    elseif self.vel:len() > 0 then
        local delta = self.dir*self.accel*dt
        if self.vel:len() > delta:len() then
            self.vel = self.vel-delta
        else
            self.vel = Vector(0,0)
        end
    end

    -- Move port/starboard
    if xor(self.mv_flags.mv_p, self.mv_flags.mv_s) then
        if self.mv_flags.mv_p then
        else
        end
    end

    self.vel = self.vel:projectOn(self.dir)
    self.pos = self.pos+self.vel*dt
end

function this:draw()
    -- Draw mode
    if (self.__index == this.__index) then
        G.setColor(self.draw_col)
    end

    -- Draw self (primitive circle)
    G.circle("fill", self.pos.x, self.pos.y, self.draw_rad, 32)

    if (Debug.enabled) then
        -- Geometry
        if (Debug.draw_geom) then
            -- Draw mode
            G.setColor(Colors.blue, 255)

            -- Bounding circle
            G.circle(
                "line",
                self.pos.x,
                self.pos.y,
                self.draw_rad,
                32)

            -- Direction
            G.line(
                self.pos.x+self.dir.x*self.draw_rad,
                self.pos.y+self.dir.y*self.draw_rad,
                self.pos.x+self.dir.x*(self.draw_rad+5),
                self.pos.y+self.dir.y*(self.draw_rad+5))
        end

        -- Text
        if (Debug.draw_text) then
            -- Update print region coordinates
            if (self.pos.x < W.w/2) then
                self.info_pr.pos.x = self.pos.x+(self.draw_rad+5)
                self.info_pr.anchor = "top-left"
            else
                self.info_pr.pos.x = self.pos.x-(self.draw_rad+5)
                self.info_pr.anchor = "top-right"
            end
            self.info_pr.pos.y = self.pos.y

            -- Add lines to print region
            self.info_pr:print({
                string.format("pos=(%g,%g)", self.pos.x, self.pos.y),
                string.format("dir=(%g,%g)", self.dir.x, self.dir.y),
                string.format("vel=%g", self.vel:len()),
                string.format("mv_f=%s", self.mv_flags.mvF),
                string.format("r_l=%s", self.mv_flags.rL),
                string.format("r_r=%s", self.mv_flags.rR),
            })

            -- Draw print region if instance is of this class
            if (self.__index == this.__index) then
                self.info_pr:draw()
            end
        end
    end

end

return this

