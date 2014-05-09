-- -----------------------------------------------
-- Class declaration
-- -----------------------------------------------
local Keybindings = Class{
    -- Function declarations
    add,
    addFromTable,

    -- Variable/table declarations
    keys,
    functions
}
local this = Keybindings

-- -----------------------------------------------
-- Function Definitions
-- -----------------------------------------------
function this:init()
    self.keys = {}
    self.functions = {}
end

-- Add keybindings for single key
function this:add(key, func, mods, cat)
    -- Assert parameter requirements
    assert(key)
    assert(func)
    assert(not self.keys[key])
    assert(not self.functions[func])

    self.keys[key] = {
        func = func,
        mods = mods
    }
    self.functions[func] = {
        key = key,
        func = func,
        category = category
    }
end

-- Add keybindings for several keys
function this:addFromTable(keys)
    -- Assert parameter requirements
    assert(keys)
    assert(type(keys) == "table")

    for _, i in ipairs(keys) do
        if #i == 2 then
            self:add(i[1], i[2])
        elseif #i == 3 then
            self:add(i[1], i[2], i[3])
        elseif #i == 4 then
            self:add(i[1], i[2], i[3], i[4])
        else
            assert(string.format(false, "2, 3 or 4 arguments expected, got %d", #i))
        end
    end
end

function this:call(key)
    local k = self.keys[key]
    if k.mods then
        local press = false
        for _, i in ipairs(k.mods) do
            if K.isDown(i) then
                press = true
            end
        end
        if press then
            k.func()
        else
        end
    else
        k.func()
    end
end

-- Return this module
return this
