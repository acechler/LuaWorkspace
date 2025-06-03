-- in terminal -> lua hello.lua


-- create
local colors = { "red", "green", "blue" }

table.insert(colors, "yellow")   


for i, c in ipairs(colors) do
    print(i, c)
end
