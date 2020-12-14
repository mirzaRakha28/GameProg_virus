-- main lua

local menutryagain = love.graphics.newImage('resources/menutryagain.jpg')
local menuquit = love.graphics.newImage('resources/menuquit.jpg')
local awesometryagain = love.graphics.newImage('resources/awesometryagain.jpg')
local awesomequit = love.graphics.newImage('resources/awesomequit.jpg')
local gameovertryagain = love.graphics.newImage('resources/gameovertryagain.jpg')
local gameoverquit = love.graphics.newImage('resources/gameoverquit.jpg')
local background = love.graphics.newImage('resources/background.jpg')
local Player = require("class_player")
local virus = require("class_virus")
local virus2 = require("class_virus2")
local Bubble = require("class_bubble")
local Collision = require("Collide")

-- varieble"
total_viruss = 10
total_viruss2 = 120
life = 3
score = 0
stage = 1
timer = 60


-- love.load function
function love.load()
    gamestate = "title"
    main_font = love.graphics.newFont(15)
    game_over_font = love.graphics.newFont(48)
    love.graphics.setFont(main_font)
    backsound = love.audio.newSource("resources/backsound.mp3", "stream")
    backsound:setLooping(true)
    backsound:play()
    winnersound = love.audio.newSource("resources/winnersound.mp3", "stream")
    gameoversound = love.audio.newSource("resources/gameoversound.mp3", "stream")
    bubble_sound = love.audio.newSource("resources/bubble.wav", "static")
    player_image = love.graphics.newImage("resources/player.png")
    player_soap = Player:new(nil)
    viruss = virus:load_viruss(total_viruss, player_soap.x, player_soap.y)
    viruss2 = virus2:load_viruss(total_viruss2, player_soap.x, player_soap.y)
    bubbles = {}
end

-- love.draw function
function love.draw()

    if gamestate == "title" 
        then
        love.graphics.draw(menutryagain, 0, 0)
    elseif gamestate == "titlequit" 
        then
        love.graphics.draw(menuquit, 0, 0)
    elseif gamestate == "restart" 
        then
        love.graphics.draw(gameovertryagain, 0, 0)
    elseif gamestate == "restartquit" 
        then
        love.graphics.draw(gameoverquit, 0, 0)
    elseif gamestate == "winner" 
        then
        love.graphics.draw(awesometryagain, 0, 0)
    elseif gamestate == "winnerquit" 
        then
        love.graphics.draw(awesomequit, 0, 0)
    elseif gamestate == "play" 
        then
        love.graphics.draw(background, 0, 0)
        love.graphics.print("LIFE : " .. life.."", 10, 25)
        love.graphics.print("SCORE  : " .. score, 10, 50)
        love.graphics.print("REMAINING TIME  : " .. math.floor(timer), 10, 75)
        love.graphics.print("STAGE " .. stage, 350, 25)
        love.graphics.print("PRESS M TO MUTE", 630, 25)
        love.graphics.print("PRESS N TO UNMUTE", 630, 50)

        if player_soap then
            love.graphics.draw(player_soap.image, player_soap.x, player_soap.y, math.rad(player_soap.rotation), 
                1, 1, player_soap.width / 2, player_soap.height / 2)
        end

        for _, v in ipairs(viruss) do
            love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation),
                v.scale, v.scale, v.width / 2, v.height / 2)
        end

        for _, v in ipairs(viruss2) do
            love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation),
                v.scale, v.scale, v.width / 2, v.height / 2)
        end

        for _, v in ipairs(bubbles) do
            love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
        end
    end
end

function love.keypressed(key)
    if love.keyboard.isDown("m") then 
        backsound:stop()
    elseif love.keyboard.isDown("n") then
        backsound:play()
    end
    
    if key == "space" and player_soap and not player_soap.dead then
        local bubble = Bubble:new(player_soap)
        -- local bubble = bubble:new(player_soap)
        table.insert(bubbles, bubble)
        -- love.audio.play(bubble_sound)
    end
end

function love.update(dt)

    if gamestate == "title" 
        then
        if love.keyboard.isDown("return") 
            then
            gamestate = "play"
            viruss = virus:load_viruss(total_viruss)
            life = 3
            score = 0
        elseif love.keyboard.isDown("down") 
            then
            gamestate = "titlequit"
        end

    elseif gamestate == "titlequit" then
        if love.keyboard.isDown("return") 
            then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "title"
        end
    end
-- 
    if gamestate == "restart" then

        if love.keyboard.isDown("return") then
            gamestate = "play"
            player_soap = Player:new(nil)
            total_viruss = 10
            viruss = virus:load_viruss(total_viruss)
            life = 3
            score = 0
            stage = 1
            gameoversound:stop()
            backsound:setLooping(true)
            backsound:play()
        elseif love.keyboard.isDown("down") then
            gamestate = "restartquit"
        end

    elseif gamestate == "restartquit" then

        if love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "restart"
        end

    elseif gamestate == "winner" then

        if love.keyboard.isDown("return") then
            gamestate = "play"
            player_soap = Player:new(nil)
            total_viruss = total_viruss + 2
            viruss = virus:load_viruss(total_viruss)
            winnersound:stop()
            backsound:setLooping(true)
            backsound:play()
        elseif love.keyboard.isDown("down") then
            gamestate = "winnerquit"
        end
    
    elseif gamestate == "winnerquit" then
        if love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "winner"
        end
    end
    -- 
    if gamestate == "play" then

        -- love.keypressed(key);
        if timer <= 0 or #viruss == 0 then
            gamestate = "restart"
            backsound:stop()
            gameoversound:play()
            timer =60
        end
        
        timer = timer - dt

        if player_soap then
        update_obj(player_soap, dt)
            if love.keyboard.isDown("space") then
                love.audio.play(bubble_sound)
            end

            if love.keyboard.isDown("left") then
                player_soap.rotation = player_soap.rotation - player_soap.rotate_speed * dt
            end
            if love.keyboard.isDown("right") then
                player_soap.rotation = player_soap.rotation + player_soap.rotate_speed * dt
            end

            if love.keyboard.isDown("up") then
                angle_radians = math.rad(player_soap.rotation)
                force_x = math.cos(angle_radians) * player_soap.thrust * dt
                force_y = math.sin(angle_radians) * player_soap.thrust * dt
                player_soap.velocity_x = player_soap.velocity_x + force_x
                player_soap.velocity_y = player_soap.velocity_y + force_y
            end

            if love.keyboard.isDown("down") then
                angle_radians = math.rad(player_soap.rotation)
                force_x = math.cos(angle_radians) * player_soap.thrust * dt
                force_y = math.sin(angle_radians) * player_soap.thrust * dt
                player_soap.velocity_x = player_soap.velocity_x - force_x
                player_soap.velocity_y = player_soap.velocity_y - force_y
            end

        end
        
        for _, v in ipairs(viruss) do
            update_obj(v, dt)
            v.rotation = v.rotation + v.rotate_speed * dt
        end
        
        for _, v in ipairs(viruss2) do
            update_obj(v, dt)
            v.rotation = v.rotation + v.rotate_speed * dt
        end
        
        for _, v in ipairs(bubbles) do
            update_obj(v, dt)
        end

        objects = {}
        
        if player_soap then
            table.insert(objects, player_soap)
        end
        
        for _, v in ipairs(viruss) do
            table.insert(objects, v)
        end
        
        for _, v in ipairs(bubbles) do
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

        if player_soap and player_soap.dead then
            player_soap = nil
        end
        
        local temp_viruss = {}
        local temp_bubbles = {}
        
        for _, v in ipairs(objects) do
            if v.is_bubble == true then
                v.survival = v.survival + dt
                if v.survival < 0.5 and not v.dead then
                    table.insert(temp_bubbles, v)
                end
            end
            
            if v.is_bubble == false then
                if not v.dead then
                    table.insert(temp_viruss, v)
                else
                    score = score + 1
                end
            end
        end
        
        viruss = temp_viruss
        bubbles = temp_bubbles

        if player_soap == nil then
            if life > 1  then
                life = life - 1
                player_soap = Player:new(player_soap)
            else
                gamestate = "restart"
                backsound:stop()
                gameoversound:play()
                timer =60
                return
            end

        elseif not player_soap.dead and #viruss == 0 then
            gamestate = "winner"
            stage = stage + 1
            backsound:stop()
            winnersound:play()
            timer =60
            return
        end

    end

end


function update_player(dt)
    local player = player_soap
    update_obj(player, dt)

    if love.keyboard.isDown("left") then
        player.rotation = player.rotation - player.rotate_speed * dt
    end

    if love.keyboard.isDown("right") then
        player.rotation = player.rotation + player.rotate_speed * dt
    end

    if love.keyboard.isDown("up") then
        angle_radians = math.rad(player.rotation)
        force_x = math.cos(angle_radians) * player.thrust * dt
        force_y = math.sin(angle_radians) * player.thrust * dt
        player.velocity_x = player.velocity_x + force_x
        player.velocity_y = player.velocity_y + force_y
    end
end

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