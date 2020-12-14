local t = {}

function update_obj(obj, dt)
    obj.x = obj.x + obj.velocity_x * dt
    obj.y = obj.y + obj.velocity_y * dt
    check_bounds(obj)
end

function check_bounds(obj)
    min_x = -obj.width / 2
    min_y = -obj.height / 2
    max_x = 800 + obj.width / 2
    max_y = 600 + obj.height / 2
    if obj.x < min_x then
        obj.x = max_x
    elseif obj.x > max_x then
        obj.x = min_x
    end
    if obj.y < min_y then
        obj.y = max_y
    elseif obj.y > max_y then
        obj.y = min_y
    end
end

function rotasi (dt)

	 for _, v in ipairs(viruss) do
        update_obj(v, dt)
        v.rotation = v.rotation + v.rotate_speed * dt
     end

     for _, v in ipairs(viruss2) do
        update_obj(v, dt)
        v.rotation = v.rotation + v.rotate_speed * dt
     end

     for _, v in ipairs(bullets) do
        update_obj(v, dt)
     end

end

function buatObject (dt)

	objects = {}

    if player_ship then
        table.insert(objects, player_ship)
    end

    for _, v in ipairs(viruss) do
        table.insert(objects, v)
    end

    for _, v in ipairs(bullets) do
        table.insert(objects, v)
    end

    for i = 1, #objects do

        for j = i+1, #objects do

            obj_1 = objects[i]
            obj_2 = objects[j]

            if not obj_1.dead and not obj_2.dead then

                if Collision:collide(obj_1, obj_2) then
                        obj_1.dead = true
                        obj_2.dead = true
                end
            end
        end
    end
end

        


function t:playerShip (dt) 

	if player_ship then
	        	
	    update_obj(player_ship, dt)

	    if love.keyboard.isDown("left") then
	        player_ship.rotation = player_ship.rotation - player_ship.rotate_speed * dt
	    end

	    if love.keyboard.isDown("right") then
	        player_ship.rotation = player_ship.rotation + player_ship.rotate_speed * dt
	    end

	    if love.keyboard.isDown("up") then
	        angle_radians = math.rad(player_ship.rotation)
	        force_x = math.cos(angle_radians) * player_ship.thrust * dt
	        force_y = math.sin(angle_radians) * player_ship.thrust * dt
	        player_ship.velocity_x = player_ship.velocity_x + force_x
	        player_ship.velocity_y = player_ship.velocity_y + force_y
	    end

	    if love.keyboard.isDown("down") then
	        angle_radians = math.rad(player_ship.rotation)
	        force_x = math.cos(angle_radians) * player_ship.thrust * dt
	        force_y = math.sin(angle_radians) * player_ship.thrust * dt
	        player_ship.velocity_x = player_ship.velocity_x - force_x
	        player_ship.velocity_y = player_ship.velocity_y - force_y
	     end
    end

    rotasi (dt)
    buatObject(dt)
        
        if player_ship and player_ship.dead then
            player_ship = nil

        end
        local temp_viruss = {}
        local temp_bullets = {}
        for _, v in ipairs(objects) do
            if v.is_bullet == true then
                v.survival = v.survival + dt
                if v.survival < 0.5 and not v.dead then
                    table.insert(temp_bullets, v)
                end
            end
            if v.is_bullet == false then
                if not v.dead then
                    table.insert(temp_viruss, v)
                else
                    score = score + 1
                end
            end
        end
        viruss = temp_viruss
        bullets = temp_bullets

        -- Cek player Ship
        if player_ship == nil then
            if life > 1  then
                life = life - 1
                player_ship = Player:new(player_ship)
            else
                gamestate = "restart"
                backsound:stop()
                gameoversound:play()
                return
            end
        elseif not player_ship.dead and #viruss == 0 then
                gamestate = "winner"
                stage = stage + 1
                backsound:stop()
                winnersound:play()
                return
        end
end

return t