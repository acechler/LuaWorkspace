# Old Love Code

## entity
```lua
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
```

## graph
```lua
-- graph.lua

local Graph = {}
Graph.__index = Graph

function Graph:new(directed)
    local g = {
        directed = directed or false,
        adjacency = {}  -- key: node, value: table of neighbors
    }
    setmetatable(g, self)
    return g
end

function Graph:addNode(node)
    if not self.adjacency[node] then
        self.adjacency[node] = {}
    end
end

function Graph:addEdge(from, to)
    self:addNode(from)
    self:addNode(to)

    table.insert(self.adjacency[from], to)

    if not self.directed then
        table.insert(self.adjacency[to], from)
    end
end

function Graph:getNeighbors(node)
    return self.adjacency[node] or {}
end

function Graph:removeNode(node)
    self.adjacency[node] = nil

    for from, neighbors in pairs(self.adjacency) do
        for i = #neighbors, 1, -1 do
            if neighbors[i] == node then
                table.remove(neighbors, i)
            end
        end
    end
end

function Graph:removeEdge(from, to)
    local function removeEdgeFrom(source, target)
        local neighbors = self.adjacency[source]
        if not neighbors then return end
        for i = #neighbors, 1, -1 do
            if neighbors[i] == target then
                table.remove(neighbors, i)
            end
        end
    end

    removeEdgeFrom(from, to)
    if not self.directed then
        removeEdgeFrom(to, from)
    end
end

function Graph:forEachNode(callback)
    for node, _ in pairs(self.adjacency) do
        callback(node)
    end
end

function Graph:forEachEdge(callback)
    for from, neighbors in pairs(self.adjacency) do
        for _, to in ipairs(neighbors) do
            callback(from, to)
        end
    end
end

return Graph

```

## Linked List
```lua
-- linked_list.lua

local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList:new()
    local list = {
        head = nil,
        tail = nil,
        size = 0
    }
    setmetatable(list, self)
    return list
end

function LinkedList:push(value)
    local node = { value = value, next = nil }

    if not self.head then
        self.head = node
        self.tail = node
    else
        self.tail.next = node
        self.tail = node
    end

    self.size = self.size + 1
end

function LinkedList:pop()
    if not self.head then return nil end

    local value = self.head.value
    self.head = self.head.next
    if not self.head then self.tail = nil end
    self.size = self.size - 1

    return value
end

function LinkedList:remove(predicate)
    local prev = nil
    local current = self.head

    while current do
        if predicate(current.value) then
            if prev then
                prev.next = current.next
            else
                self.head = current.next
            end

            if current == self.tail then
                self.tail = prev
            end

            self.size = self.size - 1
            return current.value
        end

        prev = current
        current = current.next
    end

    return nil
end

function LinkedList:forEach(callback)
    local current = self.head
    while current do
        callback(current.value)
        current = current.next
    end
end

function LinkedList:getSize()
    return self.size
end

return LinkedList

```

## main

```lua
-- How to Run
-- 1. Make sure terminal has love-workspace folder open
-- 2. Type "love ." into the terminal

local Graph = require("graph")
local Square = require("square")

local squareGraph
local squareRefs = {} -- optional: to keep track of squares by ID

function love.load()
    squareGraph = Graph:new(false) -- false = undirected

    -- Create Squares and add to graph
    for i = 1, 5 do
        local sq = Square:new(100 + i * 60, 200)
        local id = "Square" .. i
        squareRefs[id] = sq
        squareGraph:addNode(id)
    end

    -- Connect squares in a line: Square1 <-> Square2 <-> ... <-> Square5
    for i = 1, 4 do
        local from = "Square" .. i
        local to = "Square" .. (i + 1)
        squareGraph:addEdge(from, to)
    end
end

function love.update(dt)
    for id, square in pairs(squareRefs) do
        square:update(dt)
    end
end

function love.draw()
    -- Draw squares
    for id, square in pairs(squareRefs) do
        square:draw()
    end

    -- Draw connections
    love.graphics.setColor(1, 1, 0)
    squareGraph:forEachEdge(function(from, to)
        local a = squareRefs[from]
        local b = squareRefs[to]
        if a and b then
            love.graphics.line(a.x, a.y, b.x, b.y)
        end
    end)
end

-- Click to assign a new target to all Squares
function love.mousepressed(x, y, button)
    if button == 1 then
        for _, square in pairs(squareRefs) do
            square.pathfinder:addTarget(x, y)
        end
    end
end

```

## Pathfinder

```lua
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

```

## Square

```lua
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


```