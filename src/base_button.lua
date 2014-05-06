-- -----------------------------------------------
-- Class definition
-- -----------------------------------------------
local BaseButton = Class{
    __includes = BaseEntityStatic,

    dim = Vector(100,20),

    --func,

    colors = {
        back_n = Colors.gray,
        back_h = Colors.white,
        back_d = Colors.blue,
        text = Colors.black,
        dbg_geom = Colors.blue,
        dbg_text = Colors.white
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
    self.dim = Vector(100,20)
    self.text = s or ""

    self.func = {
        p,
        r,
        d,
        d_cd = 0.25,
        d_i = 0
    }

    self.colors = {
        back_n = ShallowCopy(BaseButton.colors.back_n),
        back_h = ShallowCopy(BaseButton.colors.back_h),
        back_d = ShallowCopy(BaseButton.colors.back_d),
        text = ShallowCopy(BaseButton.colors.text),
        dbg_geom = ShallowCopy(BaseButton.colors.dbg_geom),
        dbg_text = ShallowCopy(BaseButton.colors.dbg_text)
    }

    self.info_pr = PrintRegion()
end

function this:mousepressed(b)
    if (self.func.p and b == 'l') then
        self.func.p()
    end
end

function BaseButton:mousereleased(b)
    if (self.func.r and b == 'l') then
        self.func.r()
    end
end

function BaseButton:update(dt)
    -- Parent update
    BaseEntityStatic.update(self,dt)

    if self.func.d then
        if self.func.d_i > 0 then
            self.func.d_i = self.func.d_i-1*dt
            if self.func.d_i < 0 then
                self.func.d_i = 0
            end
        elseif M.isDown('l') and self:capturing() then
            self.func.d()
            self.func.d_i = self.func.d_cd
        end
    end
end

function BaseButton:draw()
    -- Set color
    if (not self:capturing()) then
        G.setColor(self.colors.back_n)
    elseif (not M.isDown('l')) then
        G.setColor(self.colors.back_h)
    else
        G.setColor(self.colors.back_d)
    end

    -- Draw primative
    G.rectangle("fill",
        self.bounds.l, self.bounds.t,
        self.dim.x, self.dim.y)

    -- Text
    G.setColor(self.colors.text)
    G.print(
        self.text,
        self.pos.x-G.getFont():getWidth(self.text)/2,
        self.pos.y-G.getFont():getHeight(self.text)/2)
end

function BaseButton:drawDebugText()
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
    self.info_pr.pos.y = self.bounds.t

    -- Add lines to print region
    self.info_pr:print(string.format("pos=(%g,%g)", self.pos.x, self.pos.y))
    self.info_pr:print(string.format("func_down_i=%g", self.func.d_i))

    -- Draw print region if instance is of BaseButton class
    if (self.__index == BaseButton.__index) then
        self.info_pr:draw()
    end
end

return BaseButton

