local JSON = require "lib/JSON"

local function tablePrinter(table)
    for k, v in pairs(table) do
        if type(v) == "table" then
            print(string.format("(table) %s:", k))
            tablePrinter(v)
        else
            print(string.format("%s: %s", k, v))
        end
    end
end

local map = {
    layers = {
        [1] = {
            [1] = {
                [1] = "ltgray",
                [3] = "ltgray",
            },
            [2] = {
                [2] = "ltgray"
            }
        },
        [2] = {
            [1] = {
                [2] = "dkgray"
            },
            [2] = {
                [1] = "dkgray",
                [3] = "dkgray"
            }
        },
        [5] = {
            [2] = {
                [1] = "blue",
                [2] = "blue",
                [3] = "blue"
            }
        }
    }
}

local file = io.open("map.json", "w")
file:write(JSON:encode_pretty(map))
file:close()

