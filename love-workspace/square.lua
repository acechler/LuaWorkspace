-- square.lua
local Pathfinder = require("pathfinder")

local Square = {}
Square.__index = Square

function Square.new(x, y)
    local self = setmetatable({}, Square)
    self.x = x
    self.y = y
    self.size = 20
    self.pathfinder = Pathfinder.new(self, 100) -- Attach a Pathfinder component
    return self
end

function Square:update(dt)
    self.pathfinder:update(dt)
end

function Square:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x - self.size/2, self.y - self.size/2, self.size, self.size)
    self.pathfinder:drawDebug()
end

return Square
