--[[ class of player ]]

local t = {}
t.image = love.graphics.newImage("resources/player.png")
t.x = 400
t.y = 300
t.width = t.image:getWidth()
t.height = t.image:getHeight()
t.velocity_x = 0
t.velocity_y = 0
t.thrust = 300
t.rotate_speed = 200
t.rotation = 0
t.dead = false

function t:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return t
