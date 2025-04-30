-- How to Run
-- 1. Make sure terminal has love-workspace folder open
-- type "love ." into the terminal

-- main.lua
local Square = require("square")

local square

function love.load()
    square = Square.new(50, 50)
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
