local menutryagain = love.graphics.newImage('resources/menutryagain.jpg')
local menuquit = love.graphics.newImage('resources/menuquit.jpg')
local awesometryagain = love.graphics.newImage('resources/awesometryagain.jpg')
local awesomequit = love.graphics.newImage('resources/awesomequit.jpg')
local gameovertryagain = love.graphics.newImage('resources/gameovertryagain.jpg')
local gameoverquit = love.graphics.newImage('resources/gameoverquit.jpg')
local backgroundbanget = love.graphics.newImage('resources/backgroundbanget.jpg')
local Player = require("class_player")
local Asteroid = require("class_asteroid")
local Asteroid2 = require("class_asteroid2")
local Bullet = require("class_bullet")
local Collision = require("Collide")
total_asteroids = 10
total_asteroids2 = 120
life = 3
score = 0
stage = 1
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
    bullet_sound = love.audio.newSource("resources/bullet.wav", "static")
    player_image = love.graphics.newImage("resources/player.png")
    player_ship = Player:new(nil)
    asteroids = Asteroid:load_asteroids(total_asteroids, player_ship.x, player_ship.y)
    asteroids2 = Asteroid2:load_asteroids(total_asteroids2, player_ship.x, player_ship.y)
    bullets = {}
end

function love.draw()
    if gamestate == "title" then
        love.graphics.draw(menutryagain, 0, 0)
    elseif gamestate == "titlequit" then
        love.graphics.draw(menuquit, 0, 0)
    elseif gamestate == "restart" then
        love.graphics.draw(gameovertryagain, 0, 0)
    elseif gamestate == "restartquit" then
        love.graphics.draw(gameoverquit, 0, 0)
    elseif gamestate == "winner" then
        love.graphics.draw(awesometryagain, 0, 0)
    elseif gamestate == "winnerquit" then
        love.graphics.draw(awesomequit, 0, 0)
    elseif gamestate == "play" then
        love.graphics.draw(backgroundbanget, 0, 0)
        love.graphics.print("LIFE : " .. life.."", 10, 25)
        love.graphics.print("SCORE  : " .. score, 10, 50)
        love.graphics.print("STAGE " .. stage, 350, 25)
        love.graphics.print("PRESS M TO MUTE", 630, 25)
        love.graphics.print("PRESS N TO UNMUTE", 630, 50)
        if player_ship then
            love.graphics.draw(player_ship.image, player_ship.x, player_ship.y, math.rad(player_ship.rotation), 
            1, 1, player_ship.width / 2, player_ship.height / 2)
        end

        for _, v in ipairs(asteroids) do
            love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation),
            v.scale, v.scale, v.width / 2, v.height / 2)
        end

        for _, v in ipairs(asteroids2) do
            love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation),
            v.scale, v.scale, v.width / 2, v.height / 2)
        end

        for _, v in ipairs(bullets) do
            love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
        end
    end
    end
function love.update(dt)
    if gamestate == "title" then
        if love.keyboard.isDown("return") then
            gamestate = "play"
            asteroids = Asteroid:load_asteroids(total_asteroids)
            life = 3
            score = 0
        elseif love.keyboard.isDown("down") then
            gamestate = "titlequit"
        end
    elseif gamestate == "titlequit" then
        if 
            love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "title"
        end
    end

    if gamestate == "restart" then
        if love.keyboard.isDown("return") then
            gamestate = "play"
            player_ship = Player:new(nil)
            total_asteroids = 10
            asteroids = Asteroid:load_asteroids(total_asteroids)
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
        if 
            love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "restart"
        end

    elseif gamestate == "winner" then
        if love.keyboard.isDown("return") then
            gamestate = "play"
            player_ship = Player:new(nil)
            total_asteroids = total_asteroids + 2
            asteroids = Asteroid:load_asteroids(total_asteroids)
            winnersound:stop()
            backsound:setLooping(true)
            backsound:play()
        elseif love.keyboard.isDown("down") then
            gamestate = "winnerquit"
        end
    elseif gamestate == "winnerquit" then
        if 
            love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "winner"
        end
    elseif gamestate == "play" then
        function love.keypressed(key)
        if love.keyboard.isDown("m") then 
            backsound:stop()
        elseif love.keyboard.isDown("n") then
            backsound:play()
        end
        if key == "space" and player_ship and not player_ship.dead then
            local bullet = Bullet:new(player_ship)
            table.insert(bullets, bullet)
            love.audio.play(bullet_sound)
            end
        end
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
        for _, v in ipairs(asteroids) do
            update_obj(v, dt)
            v.rotation = v.rotation + v.rotate_speed * dt
        end
        for _, v in ipairs(asteroids2) do
            update_obj(v, dt)
            v.rotation = v.rotation + v.rotate_speed * dt
        end
        for _, v in ipairs(bullets) do
            update_obj(v, dt)
        end

        objects = {}
        if player_ship then
            table.insert(objects, player_ship)
        end
        for _, v in ipairs(asteroids) do
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
        
        if player_ship and player_ship.dead then
            player_ship = nil

        end
        local temp_asteroids = {}
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
                    table.insert(temp_asteroids, v)
                else
                    score = score + 1
                end
            end
        end
        asteroids = temp_asteroids
        bullets = temp_bullets

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
        elseif not player_ship.dead and #asteroids == 0 then
                gamestate = "winner"
                stage = stage + 1
                backsound:stop()
                winnersound:play()
                return
        end
    end
      end
    
function update_player(dt)
    local player = player_ship
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

