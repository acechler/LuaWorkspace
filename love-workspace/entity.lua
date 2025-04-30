
-- Entity.lua
local Entity = {}
Entity.__index = Entity

function Entity:new(x, y)
    local self = setmetatable({}, Entity)
    self.x = x or 0
    self.y = y or 0
    self.width = 32
    self.height = 32
    self.color = {1, 1, 1, 1}
    return self
end

function Entity:load()
    -- Initialization logic, override in child if needed
end

function Entity:update(dt)
    -- Update logic, override in child
end

function Entity:draw()

end

return Entity
