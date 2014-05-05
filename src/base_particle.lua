-- Modules
local Class = require "class"
local BaseEntity = require "base_entity"

-- This module
local BaseParticle = Class{}
local this = BaseParticle

function BaseParticle:init(t, x, y)
    BaseEntity.init(self, t, x, y)
    --[[
    self.life_init = 1
    self.life = self.life_init

    self.vel = Vector(1, 0):rotated(math.random()*math.pi*2)*math.random(60, 200)

    local i = math.random()
    if (i > 2/3) then
        self.flags.rL = true
    elseif (i > 1/3) then
        self.flags.rR = true
    end
    --]]
end

function BaseParticle:update(dt)
    -- Parent function
    BaseEntity.update(self, dt)

    -- Particle life
    --[[
    self.life = self.life - 1 * dt
    if self.life <= 0 then
        BaseEntity.destroy(self)
    end
    --]]
end

function BaseParticle:draw()
    BaseEntity:draw()

    -- Debug draw
    if (Debug.enabled) then
        if (Debug.drawText) then
            -- Add lines to info print region
            self.info_pr:print({
                string.format("life=%s", self.life),
            })

            -- Draw print region if instance is of this class
            if (self.__index == this.__index) then
                self.info_pr:draw()
            end
        end
    end
end

-- Return module
return BaseParticle

