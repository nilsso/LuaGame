-- -----------------------------------------------
-- Base map class
-- -----------------------------------------------
-- Create map objects by calling the Map constructor with one of two sets of parameters:
--
-- Map(file)
-- Map([name, [dim_map.x, [dim_map.y, [dim_cell.x, [dim_cell.y]]]]])
--
-- The first decodes the lines from a JSON formated map file and assigns the decoded table values to the new Map instance.
--
-- The second creates a new Map instances with the given arguments.
--
-- e.g.
-- Map()
-- Map("Tiny Map", 5, 5)
-- Map("Tinier Map", 5, 5, 8, 8)
-- Map("./map/my_map.json")

local BaseMap = Class{
    __includes = nil,

    name = "Unnamed Map",
    dim_map = Vector(50, 50),
    dim_cell = Vector(16, 16),

    layers
}
local this = BaseMap

-- -----------------------------------------------
-- Function definitions
-- -----------------------------------------------
function this:init(a, b, c, d, e)
    if type(a) == "userdata" then

        local map = JSON:decode(a:read("*a"))

        self.name = map.name
        self.dim_map = Vector(
            map.dim_map.x or this.dim_map.x,
            map.dim_map.y or this.dim_map.y)
        self.dim_cell = Vector(
            map.dim_cell.x or this.dim_cell.y,
            map.dim_cell.x or this.dim_cell.y)

        self.layers = map.layers

    elseif type(a) == "string" then

        self.name = a
        self.dim_map = Vector(
            b or this.dim_map.x,
            c or this.dim_map.y)
        self.dim_cell = Vector(
            d or this.dim_map.x,
            c or this.dim_map.y)
        self.layers = {}

    else

        self.name = this.name
        self.dim_map = Vector(
            a or this.dim_map.x,
            b or this.dim_map.y)
        self.dim_cell = Vector(
            c or this.dim_cell.x,
            d or this.dim_cell.y)

        self.layers = {}

    end
end

function this:print()
    print(string.format("name = %s", self.name))
    print(string.format("dim_map = %s", self.dim_map))
    print(string.format("dim_cell = %s", self.dim_cell))
    for layer, rows in pairs(self.layers) do
        for y, collumns in pairs(rows) do
            for x, v in pairs(collumns) do
                print(string.format("layers[%s][%s][%s] = %s", layer, y, x, v))
            end
        end
    end
end

function this:__tostring()
    return self.name
end

-- Return this module
return this

