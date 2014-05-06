-- -----------------------------------------------
-- Class definition
-- -----------------------------------------------
local BaseButton = Class{
    __includes = BaseEntityStatic,

    dim = Vector(100, 20),

    colors = {
        back_n = ShallowCopy(Colors.gray),
        back_h = ShallowCopy(Colors.white),
        back_d = ShallowCopy(Colors.blue),
        dbg_geom = ShallowCopy(Colors.blue),
        dbg_text = ShallowCopy(Colors.white)
    },

    func = {
        p,
        r,
        d,
        d_cd = 0.25,
        d_i = 0
    }
}
local this = BaseButton

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(s, x, y, w, h)
    BaseEntityStatic.init(self, x, y)

    self.text = s or ""
    self.dim = Vector(w or 100, h or 20)
    self:updateBounds()

    self.info_pr = PrintRegion()
end

function this:mousepressed(b)
    if (self.func_press and b == 'l') then
        self.func_press()
    end
end

function this:mousereleased(b)
    if (self.func_release and b == 'l') then
        self.func_release()
    end
end

function this:update(dt)
    if self.func.d then
        if self.func.d_i > 0 then
            self.func.d_i = self.func.d_i-1*dt
            if self.func.d_i < 0 then
                self.func.d_i = 0
            end
        elseif M.isDown('l') and self:capturing() then
            self.func.d()
            self.func.d_i = self.func_down_cd
        end
    end
end

function this:draw()
    -- Background
    if (not self:capturing()) then
        G.setColor(self.colors.back_n, 255)
    elseif (not M.isDown('l')) then
        G.setColor(self.colors.back_h, 255)
    else
        G.setColor(self.colors.back_d, 255)
    end

    G.rectangle("fill", self.bounds.l, self.bounds.t, self.dim.x, self.dim.y)

    -- Text
    G.setColor(Colors.black, 255)
    G.print(
        self.text,
        self.pos.x-G.getFont():getWidth(self.text)/2,
        self.pos.y-G.getFont():getHeight(self.text)/2)
end

function this:drawDebugText()
    -- Draw mode
    G.setColor(self.colors.dbg_text)

    -- Update print region coordinates
    if (self.pos.x < W.w/2) then
        self.info_pr.pos.x = self.bounds.r+5
        self.info_pr.anchor = "top-left"
    else
        self.info_pr.pos.x = self.bounds.l-5
        self.info_pr.anchor = "top-right"
    end
    self.info_pr.pos.y = self.pos.y

    -- Add lines to print region
    self.info_pr:print(string.format("pos=(%g,%g)", self.pos.x, self.pos.y))
    self.info_pr:print(string.format("func_down_i=%g", self.func.d_i))

    -- Draw print region if instance is of this class
    if (self.__index == this.__index) then
        self.info_pr:draw()
    end
end

return this

