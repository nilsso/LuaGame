-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local Keybinds = Class{
    __include = nil,

    -- Variable/table declarations
    keys,

    -- Function declarations
    add,
    has,
    __call
}
local this = Keybinds

-- -----------------------------------------------
-- Function Definitions
-- -----------------------------------------------
function this:init()
    self.keys = {}
end

-- Add a single key bindings
function this:add(key, pressed, down, released, mods, cat)
    self.keys[key] = {
        funcs = {
            pressed = pressed,
            down = down,
            released = released
        },
        mods = mods
    }
end

-- Check an entry by string (key)
function this:has(key)
    return self.keys[key] ~= nil
end

function this:keypressed(key)
    if self.keys[key] then
        print(string.format("%s PRESSED", key))
        if self.keys[key].mods == nil then
            self.keys[key].pressed = true
            if self.keys[key].funcs.pressed then
                self.keys[key].funcs.pressed()
            end
        else
            for i, v in ipairs(self.keys[key].mods) do
                self.keys[key].pressed = lk.isDown(v)
                break
            end
            if self.keys[key].pressed then
                if self.keys[key].funcs.pressed then
                    self.keys[key].funcs.pressed()
                end
            end
        end
    end
end

function this:keyreleased(key)
    if self.keys[key] then
        print(string.format("%s RELEASED", key))
        if self.keys[key].released then
            self.keys[key].released()
        end
    end
end

function this:update(dt)
    for k, v in pairs(self.keys) do
        if lk.isDown(k) and self.keys[k].pressed then
            print(string.format("%s DOWN", k))
            if v.funcs.down then
                v.funcs.down()
            end
        else
            self.keys[k].pressed = false
        end
    end
end

-- Call function associated to table key
function this:__call(key)
    if self.keys[key] then
        local k = self.keys[key]
        if k.mods then
            local press = false
            for _, key in ipairs(k.mods) do
                if lk.isDown(key) then
                    press = true
                end
            end
            if press then
                k.func()
            end
        else
            k.func()
        end
    end
end

-- Return this module
return this
