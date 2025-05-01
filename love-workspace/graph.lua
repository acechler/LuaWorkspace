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
