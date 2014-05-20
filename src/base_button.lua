-- -----------------------------------------------
-- Class definition
-- -----------------------------------------------
local BaseButton = Class{
    __includes = BaseEntityStatic,
    pos,
    dim = Vector(100,20),
    text,
    colors = {
        back_n = Colors.gray,
        back_h = Colors.white,
        back_d = Colors.blue,
        text = Colors.black
    },
    states = {
        IDLE = 1,
        PRESSED = 2,
        DOWN = 3,
        RELEASED = 4
    },
    func,
    i,
    i1 = 0.4,
    i2 = 0,

}
local this = BaseButton

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(x, y, w, h)
    -- Parent init
    BaseEntityStatic.init(self, x, y)

    -- Initialize instance variables
    self.dim = Vector(w or this.dim.x, h or this.dim.y)
    self.text = ""
    self.colors = {
        back_n = ShallowCopy(BaseButton.colors.back_n),
        back_h = ShallowCopy(BaseButton.colors.back_h),
        back_d = ShallowCopy(BaseButton.colors.back_d),
        text = ShallowCopy(BaseButton.colors.text)
    }
    self.pressed = false
    self.state = this.states.IDLE
    self.func = {
        pressed,
        released,
        down,
    }
    self.i = 0
    self.i1 = this.i1
    self.i2 = this.i2
    self.info_pr = PrintRegion()

    self:updateBounds()
end

function this:press()
    self.pressed = true
end

function this:mousepressed(button)
    if button == "l" then
        this:press()
    end
end

function this:update(dt)
    -- Parent update
    BaseEntityStatic.update(self, dt)

    -- Update state
    if self.pressed then
        if not (self.state == this.states.DOWN or self.state == this.states.PRESSED) then
            -- Button was pressed
            self.state = this.states.PRESSED
        else
            -- Button was down
            self.state = this.states.DOWN
        end
    else
        if self.state ~= this.states.IDLE then
            if self.state == this.states.PRESSED or self.state == this.states.DOWN then
                -- Button was released
                self.state = this.states.RELEASED
            else
                -- Button was idle
                self.state = this.states.IDLE
            end
        end
    end

    -- Button pressed function
    if self.state == this.states.PRESSED then
        if self.func.pressed then
            self.func.pressed(dt)
        else
            self.func.down(dt)
        end
        self.i = self.i1
    end

    -- Button down function
    if self.i <= 0 then
        if self.func.down and self.state == this.states.DOWN then
            self.func.down(dt)
            self.i = self.i2
        end
    else
        self.i = self.i - dt
        if self.i < 0 then
            self.i = 0
        end
    end

    -- Button released function
    if self.state == this.states.RELEASED then
        if self.func.released then
            self.func.released(dt)
        end
    end

    self.pressed = false
end

function this:draw()
    -- Set color
    if self.state == this.states.PRESSED or self.state == this.states.DOWN then
        lg.setColor(self.colors.back_d)
    elseif self:capturing() then
        lg.setColor(self.colors.back_h)
    else
        lg.setColor(self.colors.back_n)
    end

    -- Draw primative
    lg.rectangle("fill",
    self.bounds.l, self.bounds.t,
    self.dim.x, self.dim.y)

    -- Text
    lg.setColor(self.colors.text)
    lg.printf(self.text,
    self.bounds.l,
    self.pos.y - (select(2, lg.font:getWrap(self.text, self.dim.x)) * lg.font:getHeight()) / 2,
    self.dim.x, "center")
end

function this:drawDebugText()
    -- Parent function
    BaseEntityStatic.drawDebugText(self)

    -- Add lines to print region
    self.info_pr:print(string.format("i=%g", self.i))

    -- Draw print region if instance is of BaseButton class
    if (self.__index == BaseButton.__index) then
        if self:capturing() then
            --self.info_pr.flags.background = self:capturing()
            self.info_pr:draw()
        end
    end
end

return BaseButton

