function love.load()
  require("DotLib")
  DotLib.load(
  	"Menu",																		--name of the menu screen
  	{0.41, 0.73, 0.89}, {0.74, 0.88, 0.95}, {	--ui colours
  	"Play",																		
  	"Quit"
	})
end

function love.update(dt)
	DotLib.update(dt)
end

function love.draw()
	DotLib.draw()           
end
