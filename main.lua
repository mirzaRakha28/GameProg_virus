local menutryagain = love.graphics.newImage('resources/menutryagain.jpg')
local menuquit = love.graphics.newImage('resources/menuquit.jpg')
local awesometryagain = love.graphics.newImage('resources/awesometryagain.jpg')
local awesomequit = love.graphics.newImage('resources/awesomequit.jpg')
local gameovertryagain = love.graphics.newImage('resources/gameovertryagain.jpg')
local gameoverquit = love.graphics.newImage('resources/gameoverquit.jpg')
local background = love.graphics.newImage('resources/background.jpg')

Player = require("class_player")
virus = require("class_virus")
virus2 = require("class_virus2")
Bullet = require("class_bullet")
Collision = require("Collide")
state = require ("game_state")
ship = require ("ship")


total_viruss = 10
total_viruss2 = 12
life = 3
score = 0
stage = 1
timer = 60

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
    viruss = virus:load_viruss(total_viruss, player_ship.x, player_ship.y)
    viruss2 = virus2:load_viruss(total_viruss2, player_ship.x, player_ship.y)
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
        love.graphics.draw(background, 0, 0)
        love.graphics.print("LIFE  : " .. life.."", 10, 25)
        love.graphics.print("SCORE : " .. score, 10, 50)
        love.graphics.print("TIME REMAINING  : " .. math.floor(timer), 10, 75)
        love.graphics.print("STAGE " .. stage, 350, 25)
        love.graphics.print("PRESS M TO MUTE", 630, 25)
        love.graphics.print("PRESS N TO UNMUTE", 630, 50)
        if player_ship then
            love.graphics.draw(player_ship.image, player_ship.x, player_ship.y, math.rad(player_ship.rotation), 
            1, 1, player_ship.width / 2, player_ship.height / 2)
        end

        for _, v in ipairs(viruss) do
            love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation),
            v.scale, v.scale, v.width / 2, v.height / 2)
        end

        for _, v in ipairs(viruss2) do
            love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation),
            v.scale, v.scale, v.width / 2, v.height / 2)
        end

        for _, v in ipairs(bullets) do
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

            if key == "space" and player_ship and not player_ship.dead then
                local bullet = Bullet:new(player_ship)
                table.insert(bullets, bullet)
                -- love.audio.play(bullet_sound)
            end
    end

function love.update(dt)

    if gamestate == "title" then
        state:titleState()

    elseif gamestate == "titlequit" then
        state:titleQuitState()
    end

    if gamestate == "restart" then
        state:restartState()

    elseif gamestate == "restartquit" then
    	state:restartQuitState()
    end

    if gamestate == "winner" then
        state:winnerState()

    elseif gamestate == "winnerquit" then
        state:winnerQuitState()
    end

    if gamestate == "play" then
    	state:playState(dt)
    	ship:playerShip(dt)   
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

