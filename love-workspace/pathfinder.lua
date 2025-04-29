-- pathfinder.lua
local Pathfinder = {}
Pathfinder.__index = Pathfinder

function Pathfinder.new(owner, speed)
    local self = setmetatable({}, Pathfinder)
    self.owner = owner -- Owner object (like Square)
    self.speed = speed or 100
    self.queue = {} -- Queue of targets
    return self
end

function Pathfinder:addTarget(x, y)
    table.insert(self.queue, {x = x, y = y})
end

function Pathfinder:addTargets(targets)
    for _, pos in ipairs(targets) do
        self:addTarget(pos.x, pos.y)
    end
end


function Pathfinder:update(dt)
    if #self.queue == 0 then
        return
    end

    local target = self.queue[1]
    local dx = target.x - self.owner.x
    local dy = target.y - self.owner.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance < 5 then
        table.remove(self.queue, 1) -- Remove the reached target
    else
        local dirX = dx / distance
        local dirY = dy / distance
        self.owner.x = self.owner.x + dirX * self.speed * dt
        self.owner.y = self.owner.y + dirY * self.speed * dt
    end
end

function Pathfinder:drawDebug()
    -- Optional: Draw the remaining path
    for _, point in ipairs(self.queue) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", point.x, point.y, 4)
    end
end

return Pathfinder
