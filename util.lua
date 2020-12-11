--[[
--util functions
]]

local M = {}

function M.distance(point1_x, point1_y, point2_x, point2_y)
    -- get distance of two points
    point1_x = point1_x or 0
    point1_y = point1_y or 0
    point2_x = point2_x or 0
    point2_y = point2_y or 0
    return math.sqrt((point1_x - point2_x) ^ 2 + (point1_y - point2_y) ^ 2)
end

return M