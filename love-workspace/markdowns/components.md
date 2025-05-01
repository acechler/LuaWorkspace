# Components

## How to use Square and Pathfinder in main
```lua
-- How to Run
-- 1. Make sure terminal has love-workspace folder open
-- 2. Type "love ." into the terminal

local Square = require("square")

local square

function love.load()
    square = Square:new(50, 50) -- use colon syntax for class method
    square.pathfinder:addTarget(200, 100)
    square.pathfinder:addTarget(300, 300)
    square.pathfinder:addTarget(100, 300)
end

function love.update(dt)
    square:update(dt)

    -- Click to dynamically add new waypoints
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        square.pathfinder:addTarget(mx, my)
    end
end

function love.draw()
    square:draw()
end
```

# Examples with components

## Linked List & Square

```lua
local LinkedList = require("linked_list")
local Square = require("square")

local squareList

function love.load()
    squareList = LinkedList:new()

    -- Create some Squares and add them to the list
    for i = 1, 5 do
        local sq = Square:new(100 + i * 50, 100)
        squareList:push(sq)
    end
end

function love.update(dt)
    squareList:forEach(function(square)
        square:update(dt)
    end)
end

function love.draw()
    squareList:forEach(function(square)
        square:draw()
    end)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        squareList:forEach(function(square)
            square.pathfinder:addTarget(x, y)
        end)
    end
end
```

## Graph & Square

```lua


```