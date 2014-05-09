-- -----------------------------------------------
-- Class definition
-- -----------------------------------------------
local BaseButton = Class{
    __includes = BaseEntityStatic,

    dim = Vector(100,20),

    buttons,

    func,

    states = {
        NORMAL = 1,
        PRESSED = 2,
        DOWN = 3,
        RELEASED = 4
    },
    state,

    colors = {
        back_n = Colors.gray,
        back_h = Colors.white,
        back_d = Colors.blue,
        text = Colors.black
    }
}
local this = BaseButton

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(s,x,y,w,h)
    -- Parent init
    BaseEntityStatic.init(self,x,y)

    self.pos = Vector(x,y)
    self.dim = Vector(w or this.dim.x, h or this.dim.y)
    self.text = s or ""

    self.buttons = {
        mouse = {'l'},
        key = {}
    }

    self.func = {
        p,
        r,
        d,
        d_cd = 0.25,
        d_i = 0
    }

    self.state = this.states.NORMAL

    self.colors = {
        back_n = ShallowCopy(BaseButton.colors.back_n),
        back_h = ShallowCopy(BaseButton.colors.back_h),
        back_d = ShallowCopy(BaseButton.colors.back_d),
        text = ShallowCopy(BaseButton.colors.text)
    }

    self.info_pr = PrintRegion()

    self:updateBounds()
end

function this:press()
end

function this:mousepressed(key)
    if key == "l" then
        isDown = true
    end
end

function BaseButton:update(dt)
    -- Parent update
    BaseEntityStatic.update(self,dt)

    local isDown = false

    -- Mouse buttons
    if self.buttons.mouse and self:capturing() then
        for _, b in ipairs(self.buttons.mouse) do
            if M.isDown(b) then
                isDown = true
            end
        end
    end

    -- Keyboard buttons
    if self.buttons.keys then
        for _, b in ipairs(self.buttons.keys) do
            if K.isDown(b) then
                isDown = true
            end
        end
    end

    -- Update state
    if not isDown then
        if not (self.state == this.states.DOWN or self.state == this.states.PRESSED) then
            self.state = this.states.NORMAL
        else
            self.state = this.states.RELEASED
        end
    else
        if self.state == this.states.NORMAL or self.state == this.states.RELEASED then
            self.state = this.states.PRESSED
        else
            self.state = this.states.DOWN
        end
    end

    -- Call pressed function(s)
    if self.state == this.states.PRESSED and self.func.p then
        if type(self.func.p) == "table" then
            for _, f in ipairs(self.func.p) do
                f(dt)
            end
        else
            self.func.p(dt)
        end
    end

    -- Call down function(s)
    if self.func.d_i > 0 then
        self.func.d_i = self.func.d_i-1*dt
        if self.func.d_i < 0 then
            self.func.d_i = 0
        end
    elseif self.state == this.states.DOWN and self.func.d then
        if type(self.func.d) == "table" then
            for _, f in ipairs(self.func.d) do
                f(dt)
            end
        else
            self.func.d(dt)
        end
        self.func.d_i = self.func.d_cd
    end

    -- Call released function(s)
    if self.state == this.states.RELEASED and self.func.r then
        if type(self.func.r) == "table" then
            for _, f in ipairs(self.func.r) do
                f(dt)
            end
        else
            self.func.r(dt)
        end
    end
end

function BaseButton:draw()
    -- Set color
    if self.state == this.states.PRESSED or self.state == this.states.DOWN then
        G.setColor(self.colors.back_d)
    elseif self:capturing() then
        G.setColor(self.colors.back_h)
    else
        G.setColor(self.colors.back_n)
    end

    -- Draw primative
    G.rectangle("fill",
        self.bounds.l, self.bounds.t,
        self.dim.x, self.dim.y)

    -- Text
    G.setColor(self.colors.text)
    G.printf(self.text,
        self.bounds.l,
        self.pos.y-(select(2,G.font:getWrap(self.text,self.dim.x))*G.font:getHeight())/2,
        self.dim.x, "center")
end

function BaseButton:drawDebugText()
    -- Parent function
    BaseEntityStatic.drawDebugText(self)

    -- Add lines to print region
    self.info_pr:print(string.format("func_down_i=%g", self.func.d_i))

    -- Draw print region if instance is of BaseButton class
    if (self.__index == BaseButton.__index) then
        if self:capturing() then
            self.info_pr.flags.background = self:capturing()
            self.info_pr:draw()
        end
    end
end

return BaseButton

