--[[ the class of bullet ]]

local t = {}
t.image = love.graphics.newImage("resources/bullet.png")
t.width = t.image:getWidth()
t.height = t.image:getHeight()
t.dead = false
t.survival = 0
t.is_bullet = true

function t:new(player)
    obj = {}
    angle_radians = math.rad(player.rotation)
    ship_radius = player.width / 2
    obj.x = player.x + math.cos(angle_radians) * ship_radius
    obj.y = player.y + math.sin(angle_radians) * ship_radius
    obj.velocity_x = player.velocity_x + math.cos(angle_radians) * 150
    obj.velocity_y = player.velocity_y + math.sin(angle_radians) * 150
    setmetatable(obj, self)
    self.__index = self
    return obj
end



return t
