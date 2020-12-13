local t = {}
local Util = require("util")
function t:collide(obj1, obj2)
    -- only (bullet, asteroid) (player, asteroid) could collide
    if obj1.is_bullet == false and obj2.is_bullet == false then
        return false -- (asteroid, asteroid)
    end
    if obj1.is_bullet == true and obj2.is_bullet == true then
        return false -- (bullet, bullet)
    end
    if obj1.is_bullet == true and obj2.is_bullet == nil then
        return false -- (bullet, player)
    end
    if obj1.is_bullet == nil and obj2.is_bullet == true then
        return false -- (player, bullet)
    end
    collision_dist = obj1.width / 2 + obj2.width / 2
    actual_dist = Util.distance(obj1.x, obj1.y, obj2.x, obj2.y)
    return actual_dist <= collision_dist
end
return t