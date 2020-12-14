local t = {}

	function t:titleState (viruss)

		if love.keyboard.isDown("return") then
            gamestate = "play"
            viruss = virus:load_viruss(total_viruss)
            life = 3
            score = 0
        elseif love.keyboard.isDown("down") then
            gamestate = "titlequit"
        end

	end

	function t:titleQuitState ()

		if love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "title"
        end

     end

     function t:restartState ()

     	if love.keyboard.isDown("return") then
            gamestate = "play"
            player_ship = Player:new(nil)
            total_viruss = 10
            viruss = virus:load_viruss(total_viruss)
            life = 3
            score = 0
            timer = 60
            stage = 1
            gameoversound:stop()
            backsound:setLooping(true)
            backsound:play()

        elseif love.keyboard.isDown("down") then
            gamestate = "restartquit"
        end

    end

    function t:restartQuitState ()

    	if love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "restart"
        end

    end

    function t:winnerState ()

    	if love.keyboard.isDown("return") then
            gamestate = "play"
            player_ship = Player:new(nil)
            total_viruss = total_viruss + 2
            viruss = virus:load_viruss(total_viruss)
            winnersound:stop()
            backsound:setLooping(true)
            backsound:play()
            timer = timer + 30 -- Jika menang, waktu ditambah 1 menit
        elseif love.keyboard.isDown("down") then
            gamestate = "winnerquit"
        end
    end

    function t:winnerQuitState ()

    	if love.keyboard.isDown("return") then
            love.event.quit() 
        elseif love.keyboard.isDown("up") then
            gamestate = "winner"
        end

    end	

    -- Bagian Play State
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

    function cekTimer (dt) 
        timer = timer - dt
    end

    function t:playState(dt)

    	love.keypressed(key)
        cekTimer(dt)

        if (timer < 0) then
            gamestate = "restart"
            love.audio.stop(backsound)
            love.audio.play(gameoversound)
        end
        
    end

return t