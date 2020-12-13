--[[ the virus class ]]
local util = require("util")

math.randomseed(os.time())

local t = {}
t.image = love.graphics.newImage("resources/virus.png")
t.width = t.image:getWidth()
t.height = t.image:getHeight()
t.x = 0
t.y = 0
t.dead = false
t.scale = 1
t.is_bullet = false

function t:new(obj)
    obj = obj or {}
    obj.rotation = math.random(360)
    obj.rotate_speed = math.random() * 100 - 50
    obj.velocity_x = love.math.random() * 40
    obj.velocity_y = love.math.random() * 40
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function t:load_viruss(num_viruss2, player_x, player_y)
    -- load virus info, keep away from the player
    local viruss2 = {}
    for i = 1, num_viruss2 do
        local virus2 = t:new{ x = player_x, y = player_y }
        while util.distance(virus2.x, virus2.y, player_x, player_y) < 100 do
            virus2.x = math.random(800)
            virus2.y = math.random(600)
        end
        table.insert(viruss2, virus2)
    end
    return viruss2
end

return t
