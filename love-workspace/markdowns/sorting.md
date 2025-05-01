# Sorting


## Bubble Sort

```lua
-- How to Run
-- 1. Make sure terminal has love-workspace folder open
-- type "love ." into the terminal

local values = {}
local numValues = 200
local i = 1
local j = 1
local sorted = false
local width = 800
local height = 600

function love.load()
    love.window.setMode(width, height)
    for n = 1, numValues do
        table.insert(values, math.random(10, height - 50))
    end
end

function love.update(dt)
    if not sorted then
        if values[j] > values[j + 1] then
            values[j], values[j + 1] = values[j + 1], values[j]
        end
        j = j + 1
        if j >= numValues - i then
            j = 1
            i = i + 1
        end
        if i >= numValues then
            sorted = true
        end
    end
end

function love.draw()
    local barWidth = width / numValues
    for n = 1, #values do
        if not sorted and (n == j or n == j + 1) then
            love.graphics.setColor(1, 0, 0) -- red for current comparisons
        else
            love.graphics.setColor(1, 1, 1) -- white bars
        end
        love.graphics.rectangle("fill", (n - 1) * barWidth, height - values[n], barWidth - 1, values[n])
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Bubble Sort Visualizer", 10, 10)
    if sorted then
        love.graphics.print("Sorting Complete!", 10, 30)
    end
end



```


## Selection Sort

```lua

local values = {}
local numValues = 100
local i = 1
local j = 2
local minIndex = 1
local sorted = false
local width = 800
local height = 600

function love.load()
    love.window.setMode(width, height)
    for n = 1, numValues do
        table.insert(values, math.random(10, height - 50))
    end
end

function love.update(dt)
    if not sorted then
        if j <= numValues then
            if values[j] < values[minIndex] then
                minIndex = j
            end
            j = j + 1
        else
            values[i], values[minIndex] = values[minIndex], values[i]
            i = i + 1
            if i >= numValues then
                sorted = true
            else
                minIndex = i
                j = i + 1
            end
        end
    end
end

function love.draw()
    local barWidth = width / numValues
    for n = 1, #values do
        if not sorted and (n == i or n == minIndex) then
            love.graphics.setColor(0, 1, 0) -- green for selected
        elseif not sorted and n == j then
            love.graphics.setColor(1, 0, 0) -- red for current comparison
        else
            love.graphics.setColor(1, 1, 1) -- white for default
        end
        love.graphics.rectangle("fill", (n - 1) * barWidth, height - values[n], barWidth - 1, values[n])
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Selection Sort Visualizer", 10, 10)
    if sorted then
        love.graphics.print("Sorting Complete!", 10, 30)
    end
end

```

## Quick Sort

```lua
local values = {}
local numValues = 200
local width = 800
local height = 600

local tasks = {}
local pivotIndex = nil
local leftIndex = nil
local rightIndex = nil
local currentLow = nil
local currentHigh = nil

function love.load()
    love.window.setMode(width, height)
    for i = 1, numValues do
        values[i] = math.random(10, height - 50)
    end
    table.insert(tasks, {low = 1, high = numValues})
end

function love.update(dt)
    if #tasks > 0 then
        local task = tasks[#tasks]
        local low = task.low
        local high = task.high

        if low < high then
            pivotIndex = high
            local pivot = values[pivotIndex]
            local i = low

            for j = low, high - 1 do
                if values[j] < pivot then
                    values[i], values[j] = values[j], values[i]
                    i = i + 1
                end
            end

            values[i], values[high] = values[high], values[i]

            table.remove(tasks) -- done with this one
            table.insert(tasks, {low = low, high = i - 1})   -- left partition
            table.insert(tasks, {low = i + 1, high = high})  -- right partition
        else
            table.remove(tasks)
        end
    end
end

function love.draw()
    local barWidth = width / numValues
    for i = 1, #values do
        if pivotIndex and i == pivotIndex then
            love.graphics.setColor(1, 0, 0) -- red for pivot
        else
            love.graphics.setColor(1, 1, 1) -- white bars
        end
        love.graphics.rectangle("fill", (i - 1) * barWidth, height - values[i], barWidth - 1, values[i])
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Quick Sort Visualizer", 10, 10)
    if #tasks == 0 then
        love.graphics.print("Sorting Complete!", 10, 30)
    end
end


```

## Radix

```lua
local values = {}
local numValues = 100
local width = 800
local height = 600
local maxDigits = 0
local currentDigit = 1
local buckets = {}
local sortingDone = false

function getDigit(number, digitIndex)
    return math.floor(number / 10^(digitIndex - 1)) % 10
end

function countDigits(number)
    return math.max(1, math.floor(math.log10(number)) + 1)
end

function love.load()
    love.window.setMode(width, height)

    for i = 1, numValues do
        values[i] = math.random(1, 999)
        maxDigits = math.max(maxDigits, countDigits(values[i]))
    end

    for i = 0, 9 do
        buckets[i] = {}
    end
end

function love.update(dt)
    if sortingDone then return end

    -- Clear buckets
    for i = 0, 9 do
        buckets[i] = {}
    end

    -- Place values into buckets
    for _, value in ipairs(values) do
        local digit = getDigit(value, currentDigit)
        table.insert(buckets[digit], value)
    end

    -- Flatten back into values
    local index = 1
    for i = 0, 9 do
        for _, value in ipairs(buckets[i]) do
            values[index] = value
            index = index + 1
        end
    end

    currentDigit = currentDigit + 1
    if currentDigit > maxDigits then
        sortingDone = true
    end
end

function love.draw()
    local barWidth = width / numValues
    for i = 1, #values do
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", (i - 1) * barWidth, height - values[i], barWidth - 1, values[i])
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Radix Sort Visualizer", 10, 10)
    if sortingDone then
        love.graphics.print("Sorting Complete!", 10, 30)
    else
        love.graphics.print("Sorting by Digit: " .. (currentDigit - 1), 10, 30)
    end
end


```