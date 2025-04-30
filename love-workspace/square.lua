local Entity = require("Entity")
local Pathfinder = require("pathfinder")

-- Define Square first as a subclass of Entity
local Square = setmetatable({}, { __index = Entity })
Square.__index = Square

-- Define constructor using colon syntax (preferred for inheritance)
function Square:new(x, y)
    local self = Entity.new(self, x, y)
    setmetatable(self, Square) -- important: set metatable after Entity.new
    self.size = 20
    self.pathfinder = Pathfinder.new(self, 100)
    self.color = {0, 1, 0, 1}
    return self
end

function Square:update(dt)
    self.pathfinder:update(dt)
end

function Square:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x - self.size/2, self.y - self.size/2, self.size, self.size)
    self.pathfinder:drawDebug()
end

return Square
