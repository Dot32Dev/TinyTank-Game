Play = {}

local play = {}
local menu = {}
local zoom = 1
local evil = {}
local player = {}
local sound = {}
local camera = {}
local debugy = ""

local selected = love.mouse.getSystemCursor("hand")

player.bullets = {}
evil.bullets = {}

function Play.load()
	love.graphics.setBackgroundColour(0.35, 0.6, 0.99)
	play.state = "menu"

	menu.tiny = {}
	menu.tiny.x = 0
	menu.tiny.y = 0
	menu.tiny.xV = 0
	menu.tiny.yV = 0

	menu.tank = {}
	menu.tank.x = love.graphics.getWidth()
	menu.tank.y = love.graphics.getHeight()
	menu.tank.xV = 0
	menu.tank.yV = 0

	menu.play = {}
	-- menu.play.image = love.graphics.newImage("Play.png")
	-- menu.play.image2 = love.graphics.newImage("Play2.png")
	menu.play.transitionX = love.graphics.getWidth()

	menu.timer = false
	menu.time = 0.5
	menu.levelTimer = 0
	menu.pause = false

	require("maps")
	love.math.setRandomSeed(os.time())

	player.x = 150
	player.y = 450
	player.xV = 0
	player.yV = 0
	player.attackTimer = 0.5
	player.hitTimer = 0
	player.turretLength = 30
	player.turretWidth = 16
	player.health = 100

	sound.shoot = love.audio.newSource("Shots Fired.wav", "static")
	sound.shootD = love.audio.newSource("Shots Fired Deep.wav", "static")
	sound.shootD:setVolume(0.5)
	sound.wall = love.audio.newSource("wall.wav", "static")
	sound.wallD = love.audio.newSource("wall deep.wav", "static")
	sound.wallD:setVolume(0.5)
	sound.player = love.audio.newSource("player hit.wav", "static")
	sound.player:setVolume(0.5)
	sound.playerD = love.audio.newSource("player hit deep.wav", "static")
	sound.playerD:setVolume(0.25)

	camera.x = 0
	camera.y = 0
	camera.xV = 0
	camera.yV = 0

	particles = {}
	particles.age = 0
	particles.x = 1000
	particles.y = 1000
	particles.debris = {
		{dir = love.math.random(0,math.pi*2), 0, 0},
		{dir = love.math.random(0,math.pi*2), 0, 0},
		{dir = love.math.random(0,math.pi*2), 0, 0},
		{dir = love.math.random(0,math.pi*2), 0, 0},
		{dir = love.math.random(0,math.pi*2), 0, 0}
	}
	particles.burnt = {}
end




























function Play.update(dt)
	particles.age = particles.age + (30-particles.age)/4

	for i=1, #particles.debris do
		particles.debris[i][1] = particles.debris[i][1] + (50-particles.debris[i][1])/6
		particles.debris[i][2] = particles.debris[i][2] + (50-particles.debris[i][2])/3
	end

	player.attackTimer = player.attackTimer + dt

	if menu.timer ~= false and menu.timer <= menu.time then
		menu.timer = menu.timer + dt
		menu.play.transitionX = love.graphics.getWidth()
	end

	menu.levelTimer = menu.levelTimer + dt

	if menu.timer ~= false and menu.timer > menu.time then
		menu.play.transitionX = menu.play.transitionX + (0-menu.play.transitionX)*0.3
		if menu.play.transitionX < 10 then
			if #evil > 0 then 
				setLevel(play.state)
				menu.time = 0.5
			else
				setLevel(play.state+1)
			end
			menu.time = 0.5
			menu.timer = false
		end
	end

	camera.xV = camera.xV + (0-camera.x) * 0.1
	camera.xV = camera.xV * 0.8
	camera.x = camera.x + camera.xV
	camera.yV = camera.yV + (0-camera.y) * 0.1
	camera.yV = camera.yV * 0.8
	camera.y = camera.y + camera.yV

	if math.abs(camera.xV) < 0.01 then 
		camera.xV = 0
	end
	if math.abs(camera.yV) < 0.01 then 
		camera.yV = 0
	end

	if play.state == "menuTransition" then
		menu.play.transitionX = menu.play.transitionX + (0-menu.play.transitionX)*0.3
		if menu.play.transitionX < 10 then
			setLevel(1)
		end
	elseif play.state ~= "menuTransition" and menu.timer == false then
		menu.play.transitionX = menu.play.transitionX + (love.graphics.getWidth()-menu.play.transitionX)*0.3
	elseif menu.timer == false then
		menu.play.transitionX = love.graphics.getWidth()
	end
	menu.tiny.xV = menu.tiny.xV + (love.graphics.getWidth()/2-menu.tiny.x)*0.1
	menu.tiny.yV = menu.tiny.yV + (love.graphics.getHeight()/2-200-menu.tiny.y)*0.1
	menu.tiny.xV = menu.tiny.xV*0.8
	menu.tiny.yV = menu.tiny.yV*0.8
	menu.tiny.x = menu.tiny.x + menu.tiny.xV
	menu.tiny.y = menu.tiny.y + menu.tiny.yV

	menu.tank.xV = menu.tank.xV + (love.graphics.getWidth()/2-menu.tank.x)*0.1
	menu.tank.yV = menu.tank.yV + (love.graphics.getHeight()/2-100-menu.tank.y)*0.1
	menu.tank.xV = menu.tank.xV*0.8
	menu.tank.yV = menu.tank.yV*0.8
	menu.tank.x = menu.tank.x + menu.tank.xV
	menu.tank.y = menu.tank.y + menu.tank.yV

	--[[THe actual gAmeplay]]
	if not (play.state == "menu" or play.state == "menuTransition") and menu.pause == false then
		player.turretLength = player.turretLength + (30-player.turretLength)*0.25

		if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and player.health > 0 then
			player.xV = player.xV +1*2/3*60*dt
		end
		if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) and player.health > 0 then
			player.xV = player.xV -1*2/3*60*dt
		end
		if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and player.health > 0 then
			player.yV = player.yV -1*2/3*60*dt
		end
		if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and player.health > 0 then
			player.yV = player.yV +1*2/3*60*dt
		end
		player.x = player.x + player.xV
		player.y = player.y + player.yV

		do--[[player collision]]
			if player.x > 800-20 then
				player.x = 800-20
				player.xV = 0
			end
			if player.x < 0+20 then
				player.x = 0+20
				player.xV = 0
			end
			if player.y > 600-20 then
				player.y = 600-20
				player.yV = 0
			end
			if player.y < 0+20 then
				player.y = 0+20
				player.yV = 0
			end

			for i=1, #map[play.state] do
				--[[This is Circle VS Rectangle collision!]]
				if map[play.state][i].o == "wall" then
					local bool, point = circle_Rectangle({x=player.x, y=player.y, r=20}, {x=map[play.state][i].x, y=map[play.state][i].y, w=map[play.state][i].w, h=map[play.state][i].h})
					if bool then
						local dir = {} -- offset from wall to circle 
						dir.x = player.x-point.x
						dir.y = player.y-point.y 
						local len = math.sqrt(dir.x^2+dir.y^2) --length of dir vector
						local dir_norm = {} -- the normalised "dir" (gives direction vector)
						dir_norm.x = dir.x/len
						dir_norm.y = dir.y/len 
						local move_dist = 20-len -- how far to move (the raduis - distance from circle to wall)
						local move = {} -- how far to move, multiplied with a direction vector
						move.x = move_dist*dir_norm.x
						move.y = move_dist*dir_norm.y
						
						player.x = player.x + move.x 
						player.y = player.y + move.y
					end
				end
			end

			--[[THE ENEMY ARTIFICIAL INTELIGENCE]]
			for j=#evil, 1, -1 do
				local v = evil[j]
				if v.health < 1 then
					explosion(v.x, v.y)
					table.remove(evil, j)
					manDown()
				end
				v.hitTimer = v.hitTimer - 1
				v.attackTimer = v.attackTimer - dt
				if v.attackTimer < 0 and player.health > 0 then
					v.attackTimer = love.math.random()*0.9 + 0.5
					v.turretLength = 10
					evilShoot(v.x,v.y)
				end
				v.turretLength = v.turretLength + (30-v.turretLength)*0.25
				v.steps = v.steps - dt
				if v.steps < 0 then
					v.steps = love.math.random()*1.1
					v.direction = love.math.random(1,4)
				end

				v.x = v.x + v.xV
				v.y = v.y + v.yV
				v.xV = v.xV*0.9
				v.yV = v.yV*0.9

				if v.direction==1 and player.health > 0 then
					v.xV = v.xV +1*2/3*60*dt
				end
				if v.direction==2 and player.health > 0 then
					v.xV = v.xV -1*2/3*60*dt
				end
				if v.direction==3 and player.health > 0 then
					v.yV = v.yV +1*2/3*60*dt
				end
				if v.direction==4 and player.health > 0 then
					v.yV = v.yV -1*2/3*60*dt
				end

				if v.x > 800-20 then
					v.x = 800-20
					v.xV = 0
					v.direction = 2
				end
				if v.x < 0+20 then
					v.x = 0+20
					v.xV = 0
					v.direction = 1
				end
				if v.y > 600-20 then
					v.y = 600-20
					v.yV = 0
					v.direction = 4
				end
				if v.y < 0+20 then
					v.y = 0+20
					v.yV = 0
					v.direction = 3
				end

				for i=1, #map[play.state] do
				--[[This is Circle VS Rectangle collision!]]
				if map[play.state][i].o == "wall" then
					local bool, point = circle_Rectangle({x=v.x, y=v.y, r=20}, {x=map[play.state][i].x, y=map[play.state][i].y, w=map[play.state][i].w, h=map[play.state][i].h})
					if bool then
						local dir = {} -- offset from wall to circle 
						dir.x = v.x-point.x
						dir.y = v.y-point.y 
						local len = math.sqrt(dir.x^2+dir.y^2) --length of dir vector
						local dir_norm = {} -- the normalised "dir" (gives direction vector)
						dir_norm.x = dir.x/len
						dir_norm.y = dir.y/len 
						local move_dist = 20-len -- how far to move (the raduis - distance from circle to wall)
						local move = {} -- how far to move, multiplied with a direction vector
						move.x = move_dist*dir_norm.x
						move.y = move_dist*dir_norm.y
						
						v.x = v.x + move.x 
						v.y = v.y + move.y
					end
				end
			end
			end
		end

		player.xV = player.xV*(0.9^60)^dt--/(1 + 5*dt)
		player.yV = player.yV*(0.9^60)^dt--/(1 + 5*dt)
		player.hitTimer = player.hitTimer - 1

		if love.mouse.isDown(1) and player.attackTimer > 0.4 and player.health > 0 then
			shoot()
		end
		
		for j=#player.bullets, 1, -1 do
			local v = player.bullets[j]
			v.x = v.x + math.sin(v.dir)*10*60*dt
			v.y = v.y + math.cos(v.dir)*10*60*dt

			for i=1, #map[play.state] do
				if  map[play.state][i].o == "wall" 
				and (aabb(v.x-6, v.y-6, 6, 6,--[[--]]map[play.state][i].x, map[play.state][i].y, map[play.state][i].w, map[play.state][i].h)) then
					table.remove(player.bullets, j )
					sound.wall:stop() sound.wall:play()
					sound.wallD:stop() sound.wallD:play()
				end
			end
			if (v.x > 800 or v.x < 0 or v.y > 600 or v.y < 0) then
				table.remove(player.bullets, j )
				sound.wall:stop() sound.wall:play()
				sound.wallD:stop() sound.wallD:play()
			end

			for i=1, #evil do
				if distanceBetween(evil[i].x, evil[i].y, v.x, v.y) < 6+20 then
					table.remove(player.bullets, j )
					evil[i].health = evil[i].health - 25
					evil[i].hitTimer = 4
					sound.player:stop() sound.player:play()
					sound.playerD:stop() sound.playerD:play()

					evil[i].xV = evil[i].xV + math.sin(math.atan2(evil[i].x-v.x, evil[i].y-v.y))*5
					evil[i].yV = evil[i].yV + math.cos(math.atan2(evil[i].x-v.x, evil[i].y-v.y))*5 
				end
			end
		end
		for j=#evil.bullets, 1, -1 do
			local v = evil.bullets[j]
			v.x = v.x + math.sin(v.dir)*10*60*dt
			v.y = v.y + math.cos(v.dir)*10*60*dt

			for i=1, #map[play.state] do
				if  map[play.state][i].o == "wall" 
				and (aabb(v.x-6, v.y-6, 6, 6,--[[--]]map[play.state][i].x, map[play.state][i].y, map[play.state][i].w, map[play.state][i].h) 
				or (v.x > 800 or v.x < 0 or v.y > 600 or v.y < 0))then
					table.remove(evil.bullets, j )
					sound.wall:stop() sound.wall:play()
					sound.wallD:stop() sound.wallD:play()
				end
			end
			if distanceBetween(player.x, player.y, v.x, v.y) < 6+20 then
				table.remove(evil.bullets, j )
				player.health = player.health - 25
				player.hitTimer = 4
				sound.player:stop() sound.player:play()
				sound.playerD:stop() sound.playerD:play()

				player.xV = player.xV + math.sin(math.atan2(player.x-v.x, player.y-v.y))*5
				player.yV = player.yV + math.cos(math.atan2(player.x-v.x, player.y-v.y))*5

				if player.health <= 0 then
					explosion(player.x, player.y)
				end
			end
		end  
	end
end






















function Play.draw()
	love.graphics.translate(math.floor(camera.x), math.floor(camera.y))

	if play.state == "menu" or play.state == "menuTransition" then
		love.mouse.setCursor()

		love.graphics.setColour(0.35*0.7, 0.6*0.7, 0.99*0.7)
		love.graphics.setFont(intro.dot32.font)
		love.graphics.print("Tiny", menu.tiny.x-intro.dot32.font:getWidth("Tiny")/2, menu.tiny.y)
		love.graphics.print("Tank", menu.tank.x-intro.dot32.font:getWidth("Tank")/2, menu.tank.y)

		if math.floor(menu.tank.xV*100)/100 == 0 or DotLib.timer > 1 then
			menu.tank.xV = 0
			if love.mouse.getX() > love.graphics.getWidth()/2-85 and love.mouse.getX() < love.graphics.getWidth()/2+85 
			and love.mouse.getY() > love.graphics.getHeight()/2+70-30 and love.mouse.getY() < love.graphics.getHeight()/2+70+30
			or play.state == "menuTransition" 
			then
				love.graphics.setColour(1,1,1)
				love.mouse.setCursor(selected)
				if love.mouse.isDown(1) or play.state == "menuTransition" then
					--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
					love.graphics.rectangle("fill", love.graphics.getWidth()/2-85, love.graphics.getHeight()/2+70-30, 170, 60, 30)
					play.state = "menuTransition"
					--sound.shoot:stop() sound.shoot:play()
					sound.shootD:play()
					love.mouse.setCursor()
				end
			end
			love.graphics.setLineWidth(5)
			love.graphics.rectangle("line", love.graphics.getWidth()/2-85, love.graphics.getHeight()/2+70-30, 170, 60, 30)
			love.graphics.print("Play", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("Play")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2, nil, 0.5)

			love.graphics.setColour(0.35*0.7, 0.6*0.7, 0.99*0.7)
			if love.mouse.getX() > love.graphics.getWidth()/2-160 and love.mouse.getX() < love.graphics.getWidth()/2+160 
			and love.mouse.getY() > love.graphics.getHeight()/2+70+80-30 and love.mouse.getY() < love.graphics.getHeight()/2+70+80+30
			or play.state == "menuTransition" 
			then
				love.graphics.setColour(1,1,1)
				love.mouse.setCursor(selected)
				if love.mouse.isDown(1) or play.state == "menuTransition" then
					--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
					love.graphics.rectangle("fill", love.graphics.getWidth()/2-160, love.graphics.getHeight()/2+70+80-30, 320, 60, 30)
					play.state = "menuTransition"
					--sound.shoot:stop() sound.shoot:play()
					sound.shootD:play()
					love.mouse.setCursor()
				end
			end
			love.graphics.rectangle("line", love.graphics.getWidth()/2-160, love.graphics.getHeight()/2+70-30 + 80, 320, 60, 30)
			love.graphics.print("Level Select", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("Level Select")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2 + 80, nil, 0.5)

			love.graphics.setColour(0.35*0.7, 0.6*0.7, 0.99*0.7)
			if love.mouse.getX() > love.graphics.getWidth()/2-110 and love.mouse.getX() < love.graphics.getWidth()/2+110 
			and love.mouse.getY() > love.graphics.getHeight()/2+70+80*2-30 and love.mouse.getY() < love.graphics.getHeight()/2+70+80*2+30
			or play.state == "menuTransition" 
			then
				love.graphics.setColour(1,1,1)
				love.mouse.setCursor(selected)
				if love.mouse.isDown(1) or play.state == "menuTransition" then
					--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
					love.graphics.rectangle("fill", love.graphics.getWidth()/2-110, love.graphics.getHeight()/2+70+80*2-30, 220, 60, 30)
					play.state = "menuTransition"
					--sound.shoot:stop() sound.shoot:play()
					sound.shootD:play()
					love.mouse.setCursor()
				end
			end
			love.graphics.rectangle("line", love.graphics.getWidth()/2-110, love.graphics.getHeight()/2+70-30 + 160, 220, 60, 30)
			love.graphics.print("About", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("About")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2 + 160, nil, 0.5)

			--love.graphics.draw(menu.play.image, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
		end
	end








	if not (play.state == "menu" or play.state == "menuTransition") then
		love.graphics.setColour(0.7, 0.55, 0.41)
		love.graphics.rectangle("fill", coordinate("x", 0), coordinate("y", 0), 800*zoom, 600*zoom)

		for i=1, #particles.burnt do
			love.graphics.setColor(0.7*0.9, 0.55*0.9, 0.41*0.9)
			love.graphics.circle("fill", coordinate("x", particles.burnt[i][1]), coordinate("y", particles.burnt[i][2]), 20*zoom)
		end

		love.graphics.setColour(0.49, 0.31, 0.25)
		for i=1, #map[play.state] do
			if map[play.state][i].o == "wall" then
				love.graphics.rectangle("fill", coordinate("x", map[play.state][i].x), coordinate("y", map[play.state][i].y), map[play.state][i].w*zoom, map[play.state][i].h*zoom)
			end
		end

		love.graphics.setColour(0,0,0)--(0.2,0.2,0.2)

		for i=1, #player.bullets do
			love.graphics.circle("fill", coordinate("x", player.bullets[i].x), coordinate("y", player.bullets[i].y), 6*zoom)
		end
		for i=1, #evil.bullets do
			love.graphics.circle("fill", coordinate("x", evil.bullets[i].x), coordinate("y", evil.bullets[i].y), 6*zoom)
		end

		--love.graphics.print(varToString(evil), 10, 10, 0, 0.2)
		love.graphics.print(player.xV, 10, 10, 0, 0.2)
		
		if player.hitTimer > 0 then
			love.graphics.setColour(1,1,0)
		end
		if player.health > 0 then
			love.graphics.circle("fill", coordinate("x", player.x), coordinate("y", player.y), 20*zoom, 30*zoom)
			love.graphics.setLineWidth(player.turretWidth*zoom)
			love.graphics.line(coordinate("x", player.x), coordinate("y", player.y), coordinate("x", player.x)+math.sin(math.atan2(coordinate("x", player.x) - love.mouse.getX(), coordinate("y", player.y) - love.mouse.getY())+math.pi)*player.turretLength*zoom, coordinate("y", player.y)+math.cos(math.atan2(coordinate("x", player.x) - love.mouse.getX(), coordinate("y", player.y) - love.mouse.getY())+math.pi)*player.turretLength*zoom)
			love.graphics.setColour(0.35, 0.6, 0.99)
			if player.hitTimer > 0 then
				love.graphics.setColour(1,1,0)
			end
			love.graphics.circle("fill", coordinate("x", player.x), coordinate("y", player.y), 16*zoom, 30*zoom)
		end
	
		if player.health > 0 then 
			HealthBar(60, 100, player.health, player.x, player.y -40, 15)
		end

		--[[DRAW ALL ENEMIES]]
		for i=1, #evil do
			love.graphics.setColour(0,0,0)
			if evil[i].hitTimer > 0 then
				love.graphics.setColour(1,1,0)
			end
			love.graphics.circle("fill", coordinate("x", evil[i].x), coordinate("y", evil[i].y), 20*zoom, 30*zoom)
			love.graphics.setLineWidth(player.turretWidth*zoom)
			love.graphics.line(coordinate("x", evil[i].x), coordinate("y", evil[i].y), --[[]] coordinate("x", evil[i].x)+math.sin(math.atan2(evil[i].x - player.x, evil[i].y - player.y)+math.pi)*evil[i].turretLength*zoom, coordinate("y", evil[i].y)+math.cos(math.atan2(evil[i].x - player.x, evil[i].y - player.y)+math.pi)*evil[i].turretLength*zoom)
			love.graphics.setColour(0.89, 0.56, 0.26)
			if evil[i].hitTimer > 0 then
				love.graphics.setColour(1,1,0)
			end
			love.graphics.circle("fill", coordinate("x", evil[i].x), coordinate("y", evil[i].y), 16*zoom, 30*zoom)
		
			HealthBar(60, 100, evil[i].health, evil[i].x, evil[i].y -40, 15)
		end

		--[[DRAW PARTICLES]]
		love.graphics.setColour(1,1,1)
		love.graphics.setLineWidth(5*zoom)
		if particles.age < 29.93 then 
			love.graphics.circle("line", coordinate("x", particles.x), coordinate("y", particles.y), particles.age)
			for i=1, #particles.debris do
				love.graphics.line(coordinate("x", math.sin(particles.debris[i].dir)*particles.debris[i][1]+particles.x), coordinate("y", math.cos(particles.debris[i].dir)*particles.debris[i][1]+particles.y), coordinate("x", math.sin(particles.debris[i].dir)*particles.debris[i][2]+particles.x), coordinate("y", math.cos(particles.debris[i].dir)*particles.debris[i][2]+particles.y))
			end
		end

		if menu.levelTimer < 3 then
			love.graphics.setColour(0,0,0, 0.5-(math.max(menu.levelTimer, 2.5)-2.5))
			love.graphics.rectangle("fill", 0, 550, intro.dot32.font:getWidth("Level "..play.state)*0.3+45, 50)
			love.graphics.setColour(1,1,1)
			love.graphics.print("Level "..play.state, 20, 555, nil, 0.3)
		end

		if player.health <= 0 then
			local a = 550
			if menu.levelTimer < 3 then
				a = a - 50
			end
			love.graphics.setColour(1,0,0, 0.5)
			love.graphics.rectangle("fill", 0, a-50, intro.dot32.font:getWidth('You died, press "R" to restart')*0.3+45, 50)
			love.graphics.setColour(1,1,1)
			love.graphics.print('You died, press "R" to restart', 20, a-45, nil, 0.3)
			love.graphics.setColour(0.5,0,1, 0.5)
			love.graphics.rectangle("fill", 0, a, intro.dot32.font:getWidth('Press "ESC" to quit')*0.3+45, 50)
			love.graphics.setColour(1,1,1)
			love.graphics.print('Press "ESC" to quit', 20, a+5, nil, 0.3)
		end

		if menu.pause == true then
			local a = 550
			if menu.levelTimer < 3 then
				a = a - 50
			end
			if player.health <= 0 then
				a = a - 100
			end
			love.graphics.setColour(1,0.7,0, 0.5)
			love.graphics.rectangle("fill", 0, a, intro.dot32.font:getWidth('The game has been paused. Press "P" to unpause')*0.3+45, 50)
			love.graphics.setColour(1,1,1)
			love.graphics.print('The game has been paused. Press "P" to unpause', 20, a+5, nil, 0.3)
		end
	end

	love.graphics.setColour(0.2,0.2,0.2)
	love.graphics.rectangle("fill", menu.play.transitionX*faenBoolean(play.state == "menu" or play.state == "menuTransition"or menu.timer ~= false), 0, love.graphics.getWidth()-menu.play.transitionX, love.graphics.getHeight())
end
























function coordinate(d, c)
	if d == "x" then
		return love.graphics.getWidth()/2-400 + (c-400)*zoom + 400
	end
	if d == "y" then
		return love.graphics.getHeight()/2-300 + (c-300)*zoom + 300
	end
end

function love.resize(w, h)
  zoom = love.graphics.getHeight()/600
end

function newEvil(xx, yy)
	return {
		x = xx,
		y = yy,
		xV = 0,
		yV = 0,
		direction = love.math.random(1,4),
		steps = love.math.random()*1.1,
		attackTimer = love.math.random()*0.9 + 0.5,
		health = 100,
		turretLength = 30,
		hitTimer = 0
	}
end

function shoot()
	table.insert(player.bullets, {x = player.x, y = player.y, dir = math.atan2(coordinate("x", player.x) - love.mouse.getX(), coordinate("y", player.y) - love.mouse.getY())+math.pi})

	player.attackTimer = 0
	player.turretLength = 10
	--player.xV = player.xV + math.sin(math.atan2(player.x - love.mouse.getX(), player.y - love.mouse.getY()))*1*2/3*10
	--player.yV = player.yV + math.cos(math.atan2(player.x - love.mouse.getX(), player.y - love.mouse.getY()))*1*2/3*10
	sound.shoot:stop() sound.shoot:play()
	sound.shootD:stop() sound.shootD:play()
	camera.x = camera.x + math.sin(math.atan2(coordinate("x", player.x) - love.mouse.getX(), coordinate("y", player.y) - love.mouse.getY()))*5
	camera.y = camera.y + math.cos(math.atan2(coordinate("x", player.x) - love.mouse.getX(), coordinate("y", player.y) - love.mouse.getY()))*5
end

function aabb(x1, y1, w1, h1,--[[--]] x2, y2, w2, h2)
return 
	x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

function HealthBar(length, maxHealth, currentHealth, x, y, girth, hue)
	hue = hue or (currentHealth > 0 and 150/maxHealth * currentHealth) or 0
	x = coordinate("x", x)
	y = coordinate("y", y)
	love.graphics.setColour(unpack(HSL(hue/360, 0.73, 0.48, 1)))
	love.graphics.rectangle("fill", x-length/2, y-girth/2, length, girth)
	love.graphics.circle("fill", x-length/2, y, girth/2)
	love.graphics.circle("fill", x+length/2, y, girth/2)
	if currentHealth > 0 then
		love.graphics.setColour(unpack(HSL(hue/360, 0.98, 0.58, (player.health < 0 and 0) or 1)))
		love.graphics.rectangle("fill", x-length/2, y-girth/4, length/maxHealth*currentHealth, girth/2)
		love.graphics.circle("fill", x-length/2, y, girth/4)
		love.graphics.circle("fill", x-length/2+length/maxHealth*currentHealth, y, girth/4)
	end
end

function setLevel(level)
	menu.levelTimer = 0
	if map[level] ~= nil then
		play.state = level
		love.graphics.setBackgroundColour(0.49, 0.31, 0.25)
		particles.burnt = {}
		player.bullets = {}
		evil = {}
		evil.bullets = {}

		player.health = 100
		player.x = 150
		player.y = 450

		for i=1, #map[level] do
			if map[play.state][i].o == "evil" then
				table.insert(evil, newEvil(map[level][i].x, map[level][i].y))
			end
		end
	else
		love.graphics.setBackgroundColour(0.35, 0.6, 0.99)
		play.state = "menu"
	end
end

function explosion(x, y)
	particles.age = 0
	particles.x = x
	particles.y = y
	particles.debris = {
	{dir = love.math.random(0,math.pi*2), 0, 0},
	{dir = love.math.random(0,math.pi*2), 0, 0},
	{dir = love.math.random(0,math.pi*2), 0, 0},
	{dir = love.math.random(0,math.pi*2), 0, 0},
	{dir = love.math.random(0,math.pi*2), 0, 0}
	}
	table.insert(particles.burnt, {x,y})
end

function evilShoot(xx,yy)
	table.insert(evil.bullets, {x = xx, y = yy, dir = math.atan2(xx - player.x, yy - player.y)+math.pi})
	--player.xV = player.xV + math.sin(math.atan2(player.x - love.mouse.getX(), player.y - love.mouse.getY()))*1*2/3*10
	--player.yV = player.yV + math.cos(math.atan2(player.x - love.mouse.getX(), player.y - love.mouse.getY()))*1*2/3*10
	sound.shoot:stop() sound.shoot:play()
	sound.shootD:stop() sound.shootD:play()
end

function manDown()
	if #evil == 0 then 
		menu.timer = 0
	end
end

function circle_Rectangle(circle, rectangle) --circle is in the format of {x=, y=, r=}, rectangle is in {x=,y=,w=,h=}
	local px = circle.x
	local py= circle.y
	px = math.max(px, rectangle.x)
  px = math.min(px, rectangle.x + rectangle.w)
  py = math.max(py, rectangle.y)
  py = math.min(py, rectangle.y + rectangle.h)

	return ( (circle.y-py)^2 + (circle.x-px)^2 ) < circle.r^2, {x=px, y=py}
end

function love.keypressed(key)
  if key == "f" and love.keyboard.isDown("lgui") and love.keyboard.isDown("lctrl") and operatingSystem == "OS X" then
      love.window.setFullscreen(true)
  end
  if key == "f11" and operatingSystem == "Windows" then
      love.window.setFullscreen(true)
  end
  if key == "r" and play.state ~= "menu" and play.state ~= "menuTransition" then
    --setLevel(play.state)
    menu.timer = 0
    menu.time = 0
  end
  if key == "escape" and play.state ~= "menu" and play.state ~= "menuTransition" then
    setLevel(-1)
  end
  if key == "p" and play.state ~= "menu" and play.state ~= "menuTransition" then
    if menu.pause then
    	menu.pause = false
    else
    	menu.pause = true
    end
  end
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end