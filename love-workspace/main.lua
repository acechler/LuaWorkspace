-- How to Run
-- 1. Make sure terminal has love-workspace folder open
-- 2. Type "love ." into the terminal

function love.load()
    x, y = 100, 100
    speed = 200
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        x = x + speed * dt
    elseif love.keyboard.isDown("left") then
        x = x - speed * dt
    end

    if love.keyboard.isDown("down") then
        y = y + speed * dt
    elseif love.keyboard.isDown("up") then
        y = y - speed * dt
    end
end

function love.draw()
    love.graphics.circle("fill", x, y, 20)
end
