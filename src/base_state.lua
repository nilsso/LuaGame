local BaseState = Class{}

function BaseState:init()
    -- Entity list and print region
    self.entities = self.entities or {}
    self.entities_pr = PrintRegion(W.w - 5, 5, "top-right")

    self.dt = 1
end

function BaseState:keypressed(key)
    if self.keybinds[key] then
        local bool = false
        if #self.keybinds[key][1] > 0 then
            for _, i in ipairs(self.keybinds[key][1]) do
                if K.isDown(i) then
                    bool = true
                    break
                end
            end
        else
            bool = true
        end
        if bool then
            self.keybinds[key][2]()
        end
    end
end

function BaseState:mousepressed(x, y, key)
    for _, e in ipairs(self.entities) do
        if e.capturing ~= nil and e:capturing() then
            e:mousepressed(key)
        end
    end
end

function BaseState:update(dt)
    self.dt = self.dt + dt
    if (self.dt >= 0.5) then
        BaseParticle(self.entities,
            W.w/2,
            W.h/2)
        self.dt = 0
    end

    for _, e in ipairs(self.entities) do
        e:update(dt)
    end
end

function BaseState:draw()
    for _, e in ipairs(self.entities) do
        e:draw()
    end

    -- Debug draw
    if Debug.enabled then
        -- Geometry
        if Debug.drawGeom then
            -- Set draw modes
            G.setColor(Colors.blue)
            G.setLineWidth(1)

            -- Window dividers
            G.line(0, W.getHeight()/2, W.getWidth(), W.getHeight()/2)
            G.line(W.getWidth()/2, 0, W.getWidth()/2, W.getHeight())
        end

        -- Text
        if Debug.drawText then
            G.setColor(Colors.white)

            -- State name
            G.print(
                string.format("State: %s",
                    self.name), 5, 5)

            -- Mouse position
            G.print(
                string.format(
                    "mouse.pos=(%i,%i)",
                    M.getPosition()), 5, 17)

            -- Entities
            self.entities_pr:print("ENTITIES:")
            self.entities_pr:print(self.entities)
            self.entities_pr:draw()
        end
    end
end

-- Module
return BaseState

