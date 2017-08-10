local component = require('component')
local shell = require('shell')

args, _ = shell.parse(...)

local methods = component.methods(component.getPrimary(args[1]).address)

for k, v in pairs(methods) do
    print(k, v)
end
