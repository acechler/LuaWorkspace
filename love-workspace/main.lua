-- How to Run
-- 1. Make sure terminal has love-workspace folder open
-- 2. Type "love ." into the terminal

local Graph = require("graph")

local g

function love.load()
    g = Graph:new(false)  -- Set true for directed graph

    g:addEdge("A", "B")
    g:addEdge("A", "C")
    g:addEdge("B", "D")
    g:addEdge("C", "D")
end

function love.draw()
    local y = 20
    g:forEachNode(function(node)
        local neighbors = g:getNeighbors(node)
        local text = node .. " -> " .. table.concat(neighbors, ", ")
        love.graphics.print(text, 20, y)
        y = y + 20
    end)
end
