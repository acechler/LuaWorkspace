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

    -- (Optional) Draw connections
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
