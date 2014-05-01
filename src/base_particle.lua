local Class = require "class"
local BaseEntity = require "base_entity"
-- Vector = require "vector"

local BaseParticle = Class{}

function BaseParticle:init(t, x, y)
    BaseEntity.init(self, t, x, y)
    self.life_init = 1
    self.life = self.life_init

    self.vel = Vector(1, 0):rotated(math.random()*math.pi*2)*math.random(60, 200)

    local i = math.random()
    if (i > 2/3) then
        self.flags.rL = true
    elseif (i > 1/3) then
        self.flags.rR = true
    end
end

function BaseParticle:update(dt)
    -- Parent function
    BaseEntity.update(self, dt)

    -- Particle life
    self.life = self.life - 1 * dt
    if self.life <= 0 then
    end
end

function BaseParticle:draw()
	-- Draw modes
    self.draw_col.a = 255 * self.life / self.life_init
    BaseEntity.draw(self)

	-- Debug draw
    if (Debug.enabled) then
        if (Debug.drawText) then
			--self.info_pr:print("life=%s", self.life)
        end
    end
end

BaseParticle:include(BaseEntity)

return BaseParticle

