# Abstract Data Types


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
local LinkedList = require("linked_list")

local list

function love.load()
    list = LinkedList:new()

    -- Add some values
    list:push("apple")
    list:push("banana")
    list:push("cherry")
end

function love.update(dt)
    -- Remove an element (e.g., "banana")
    list:remove(function(value) return value == "banana" end)
end

function love.draw()
    local y = 20
    list:forEach(function(value)
        love.graphics.print(value, 20, y)
        y = y + 20
    end)
end

```

## Graphs

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

local LinkedList = require("linked_list")

local list

function love.load()
    list = LinkedList:new()

    -- Add some values
    list:push("apple")
    list:push("banana")
    list:push("cherry")
end

function love.update(dt)
    -- Remove an element (e.g., "banana")
    list:remove(function(value) return value == "banana" end)
end

function love.draw()
    local y = 20
    list:forEach(function(value)
        love.graphics.print(value, 20, y)
        y = y + 20
    end)
end

```