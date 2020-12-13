--[[ the asteroid class ]]
local util = require("util")

math.randomseed(os.time())

local t = {}
t.image = love.graphics.newImage("resources/asteroid2.png")
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

function t:load_asteroids(num_asteroids2, player_x, player_y)
    -- load asteroid info, keep away from the player
    local asteroids2 = {}
    for i = 1, num_asteroids2 do
        local asteroid2 = t:new{ x = player_x, y = player_y }
        while util.distance(asteroid2.x, asteroid2.y, player_x, player_y) < 100 do
            asteroid2.x = math.random(800)
            asteroid2.y = math.random(600)
        end
        table.insert(asteroids2, asteroid2)
    end
    return asteroids2
end

return t
