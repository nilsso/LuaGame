-- -----------------------------------------------
-- Class definition
-- -----------------------------------------------
local BaseButton = Class{
    table,

    pos,
    dim,
    bounds = {
        left,
        top,
        right,
        bottom
    },
    colors = {
        back_normal = Colors.gray,
        back_highlight = Colors.white,
        back_press = Colors.blue,
        back
    },
    func_press,
    func_release,
    func_down,
    func_down_cd = 0.25,
    func_down_i = 0,

    info_pr
}
local this = BaseButton

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(s, x, y, w, h)
    -- Assert arguments
    assert(s)
    assert(x)
    assert(y)

    self.text = s
    self.pos = Vector(x, y)
    self.dim = Vector(w or 100, h or 20)
    self:calcBounds()

    self.info_pr = PrintRegion()
end

function this:register(t)
    assert

function this:calcBounds()
    self.bounds.left = self.pos.x-self.dim.x/2
    self.bounds.top = self.pos.y-self.dim.y/2
    self.bounds.right = self.pos.x+self.dim.x/2
    self.bounds.bottom = self.pos.y+self.dim.y/2
end

function this:capturing()
    local mx, my = love.mouse.getPosition()
    return (
        mx >= self.bounds.left and
        mx <= self.bounds.right and
        my >= self.bounds.top and
        my <= self.bounds.bottom)
end

function this:mousepressed(b)
    if (self.func_press and b == 'l') then
        self.func_press()
    end
end

function this:mousereleased(b)
    if (self.func_release and b == 'l') then
        self.func_releas()
    end
end

function this:update(dt)
    if self.func_down_i <= 0 then
        if self.func_down and self:capturing() and M.isDown("l") then
            self.func_down()
            self.func_down_i = self.func_down_cd
        end
    else
        self.func_down_i = self.func_down_i-1*dt
        if self.func_down_i < 0 then
            self.func_down_i = 0
        end
    end
end

function this:draw()
    if (not self:capturing()) then
        self.colors.back = self.colors.back_normal
    elseif (not M.isDown('l')) then
        self.colors.back = self.colors.back_highlight
    else
        self.colors.back = self.colors.back_press
    end

    -- Geometry
    G.setColor(self.colors.back, 255)
    G.rectangle("fill", self.bounds.left, self.bounds.top, self.dim.x, self.dim.y)

    -- Text
    G.setColor(Colors.black, 255)
    G.print(
        self.text,
        self.pos.x-G.getFont():getWidth(self.text)/2,
        self.pos.y-G.getFont():getHeight(self.text)/2)

    -- Debug draw
    if Debug.enabled then
        -- Text
        if Debug.draw_text then
            -- Update print region coordinates
            if (self.pos.x < W.w/2) then
                self.info_pr.pos.x = self.pos.x+(self.dim.x/2+5)
                self.info_pr.anchor = "top-left"
            else
                self.info_pr.pos.x = self.pos.x-(self.dim.x/2+5)
                self.info_pr.anchor = "top-right"
            end
            self.info_pr.pos.y = self.pos.y-self.dim.y/2

            -- Add lines to print region
            self.info_pr:print({
                string.format("pos=(%g,%g)", self.pos.x, self.pos.y),
                string.format("func_down_i=%g", self.func_down_i)
            })

            -- Draw print region if instance is of this class
            if (self.__index == this.__index) then
                self.info_pr:draw()
            end
        end
    end
end

return this

