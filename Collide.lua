-- For collison (tubrukan)

local t = {}
local Util = require("util")
function t:collide(obj1, obj2)
    -- only (bubble, virus) (player, virus) could collide
    if obj1.is_bubble == false and obj2.is_bubble == false then
        return false -- (virus, virus)
    end
    if obj1.is_bubble == true and obj2.is_bubble == true then
        return false -- (bubble, bubble)
    end
    if obj1.is_bubble == true and obj2.is_bubble == nil then
        return false -- (bubble, player)
    end
    if obj1.is_bubble == nil and obj2.is_bubble == true then
        return false -- (player, bubble)
    end
    collision_dist = obj1.width / 2 + obj2.width / 2
    actual_dist = Util.distance(obj1.x, obj1.y, obj2.x, obj2.y)
    return actual_dist <= collision_dist
end
return t