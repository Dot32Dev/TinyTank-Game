local corner = love.graphics.newImage("DotLib/Menu/Panel/corner.png")
local girth = love.graphics.newImage("DotLib/Menu/Panel/girth.png")

function newPanel(x, y, width, height, colour)
	return {
		x = x,
		y = y,
		w = width,
		h = height,
		c = colour or {0.9, 0.9, 0.9},
		draw = function(self)
			love.graphics.setColour(1, 1, 1, 1)
			--[[top left]]love.graphics.draw(corner, self.x - self.w/2 + 25, self.y - self.h/2 + 25, nil, 0.5, 0.5, 140, 140)
			--[[top right]]love.graphics.draw(corner, self.x + self.w/2 -25, self.y - self.h/2 + 25, math.pi/2, 0.5, 0.5, 140, 140)
			--[[bottom left]]love.graphics.draw(corner, self.x - self.w/2 + 25, self.y + self.h/2 - 25, -math.pi/2, 0.5, 0.5, 140, 140)
			--[[bottom right]]love.graphics.draw(corner, self.x + self.w/2 -25, self.y + self.h/2 - 25, math.pi, 0.5, 0.5, 140, 140)
			love.graphics.setColour(1, 1, 1, 0.8)
			--[[top]]love.graphics.draw(girth, self.x - self.w/2 + 25, self.y - self.h/2-45, nil, (self.w-50)/100, 0.5)
			--[[bottom]]love.graphics.draw(girth, self.x - self.w/2 + 25, self.y + self.h/2+45, nil, (self.w-50)/100, -0.5)
			--[[left]]love.graphics.draw(girth, self.x - self.w/2 - 45, self.y - self.h/2+25, math.pi/2, (self.h-50)/100, -0.5)
			--[[right]]love.graphics.draw(girth, self.x + self.w/2 + 45, self.y - self.h/2+25, math.pi/2, (self.h-50)/100, 0.5)
	

			love.graphics.setColour(unpack(self.c))
			love.graphics.rectangle("fill", self.x - self.w/2, self.y - self.h/2, self.w, self.h, 25)
		end,
		setParameters = function(self, x, y, width, height, colour)
			self.x = x or self.x
			self.y = y or self.y
			self.w = width or self.w
			self.h = height or self.h
			self.c = colour or self.c
		end
	}
end