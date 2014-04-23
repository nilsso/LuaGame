local BaseState = Class{
    name,
    entities = {}
}

function BaseState:draw()
    for _, e in ipairs(self.entities) do
        e:draw()
    end

    if Debug.enabled then
        -- Geometry
        g.setColor(Colors.blue)
        g.setLineWidth(1)
        g.line(0, w.getHeight()/2, w.getWidth(), w.getHeight()/2)
        g.line(w.getWidth()/2, 0, w.getWidth()/2, w.getHeight())

        -- Text
        g.setColor(Colors.white)
        g.print(string.format("State: %s", self.name), 5, 5)
        g.print(string.format("mouse.pos=(%i,%i)", m.getPosition()), 5, 17)
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
    for _, e in ipairs(self.entities) do
        e:update(dt)
    end
end

-- Module
return BaseState

