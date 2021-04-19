menuuu = {}
local selected = love.mouse.getSystemCursor("hand")
local selectedButton = "Play"

function menuuu.draw()
	local a = -50

	if love.mouse.getX() > love.graphics.getWidth()/2-85 and love.mouse.getX() < love.graphics.getWidth()/2+85 
	and love.mouse.getY() > love.graphics.getHeight()/2+70-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+30+a
	then
		love.graphics.setColour(1,1,1)
		love.mouse.setCursor(selected)
		if love.mouse.isDown(1)  then
			--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
			love.graphics.rectangle("fill", love.graphics.getWidth()/2-85, love.graphics.getHeight()/2+70-30+a, 170, 60, 30)
			--play.state = "menuTransition"
			menu.transitionHint = 1
			menu.timer = 0
			menu.time = 0
			--menu.transitionHint = "1"
			--sound.shoot:stop() sound.shoot:play()
			sound.shootD:play()
			love.mouse.setCursor()
		end
	end
	love.graphics.setLineWidth(5)
	love.graphics.rectangle("line", love.graphics.getWidth()/2-85, love.graphics.getHeight()/2+70-30+a, 170, 60, 30)
	love.graphics.print("Play", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("Play")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2+a, nil, 0.5)

	love.graphics.setColour(0.35*0.7, 0.6*0.7, 0.99*0.7)
	if love.mouse.getX() > love.graphics.getWidth()/2-160 and love.mouse.getX() < love.graphics.getWidth()/2+160 
	and love.mouse.getY() > love.graphics.getHeight()/2+70+80-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+80+30+a
	-- 
	then
		love.graphics.setColour(1,1,1)
		love.mouse.setCursor(selected)
		if love.mouse.isDown(1) then-- then
			--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
			love.graphics.rectangle("fill", love.graphics.getWidth()/2-160, love.graphics.getHeight()/2+70+80-30+a, 320, 60, 30)
			--play.state = "menuTransition"
			--sound.shoot:stop() sound.shoot:play()
			sound.shootD:play()
			love.mouse.setCursor()
			menu.transitionHint = "levels"
			menu.timer = 0
			menu.time = 0
		end
	end
	love.graphics.rectangle("line", love.graphics.getWidth()/2-160, love.graphics.getHeight()/2+70-30+a + 80, 320, 60, 30)
	love.graphics.print("Level Select", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("Level Select")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2 + 80+a, nil, 0.5)

	love.graphics.setColour(0.35*0.7, 0.6*0.7, 0.99*0.7)
	if love.mouse.getX() > love.graphics.getWidth()/2-110 and love.mouse.getX() < love.graphics.getWidth()/2+110 
	and love.mouse.getY() > love.graphics.getHeight()/2+70+80*2-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+80*2+30+a
	-- 
	then
		love.graphics.setColour(1,1,1)
		love.mouse.setCursor(selected)
		if love.mouse.isDown(1) then-- then
			--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
			love.graphics.rectangle("fill", love.graphics.getWidth()/2-110, love.graphics.getHeight()/2+70+80*2-30+a, 220, 60, 30)
			--play.state = "menuTransition"
			--sound.shoot:stop() sound.shoot:play()
			sound.shootD:play()
			love.mouse.setCursor()
			menu.transitionHint = "about"
			menu.timer = 0
			menu.time = 0
		end
	end
	love.graphics.rectangle("line", love.graphics.getWidth()/2-110, love.graphics.getHeight()/2+70-30 + 160+a, 220, 60, 30)
	love.graphics.print("About", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("About")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2 + 160+a, nil, 0.5)

	love.graphics.setColour(0.35*0.7, 0.6*0.7, 0.99*0.7)
	if love.mouse.getX() > love.graphics.getWidth()/2-85 and love.mouse.getX() < love.graphics.getWidth()/2+85 
	and love.mouse.getY() > love.graphics.getHeight()/2+70+80*3-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+80*3+30+a
	-- 
	then
		love.graphics.setColour(1,1,1)
		love.mouse.setCursor(selected)
		if love.mouse.isDown(1) then-- then
			--love.graphics.draw(menu.play.image2, love.graphics.getWidth()/2, love.graphics.getHeight()/2+50, 0, 0.5, 0.5, menu.play.image:getWidth()/2, menu.play.image:getHeight()/2)
			love.graphics.rectangle("fill", love.graphics.getWidth()/2-85, love.graphics.getHeight()/2+70+80*3-30+a, 170, 60, 30)
			--play.state = "menuTransition"
			--sound.shoot:stop() sound.shoot:play()
			toFile()
			love.event.quit()
			sound.shootD:play()
			love.mouse.setCursor()
		end
	end
	love.graphics.setLineWidth(5)
	love.graphics.rectangle("line", love.graphics.getWidth()/2-85, love.graphics.getHeight()/2+70+80*3-30+a, 170, 60, 30)
	love.graphics.print("Quit", love.graphics.getWidth()/2-0.5*intro.dot32.font:getWidth("Quit")/2, love.graphics.getHeight()/2+70-0.5*intro.dot32.font:getHeight()/2+a +80*3, nil, 0.5)
end

function menuuu.touching() --4
	return (love.mouse.getX() > love.graphics.getWidth()/2-85 and love.mouse.getX() < love.graphics.getWidth()/2+85 
	and love.mouse.getY() > love.graphics.getHeight()/2+70-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+30+a
	and love.mouse.getX() > love.graphics.getWidth()/2-160 and love.mouse.getX() < love.graphics.getWidth()/2+160 
	and love.mouse.getY() > love.graphics.getHeight()/2+70+80-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+80+30+a
	and love.mouse.getX() > love.graphics.getWidth()/2-110 and love.mouse.getX() < love.graphics.getWidth()/2+110 
	and love.mouse.getY() > love.graphics.getHeight()/2+70+80*2-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+80*2+30+a
	and love.mouse.getX() > love.graphics.getWidth()/2-85 and love.mouse.getX() < love.graphics.getWidth()/2+85 
	and love.mouse.getY() > love.graphics.getHeight()/2+70+80*3-30+a and love.mouse.getY() < love.graphics.getHeight()/2+70+80*3+30+a)
end