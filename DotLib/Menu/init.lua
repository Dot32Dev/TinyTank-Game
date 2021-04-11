require("DotLib/Menu/Panel/panel")
local selected = love.mouse.getSystemCursor("hand")
local menuConfig = {
	width = 400,
	y = 250,
	spacing = 100,
	height = 80,
	balloon = 20,
	fontscale = 0.7
}
screen.menuSpacing = menuConfig.spacing

function newMenu(colour, colour2, rdata)
	local justBreath = {}
	local x = love.graphics.getWidth()/2
	for i=1, #rdata do
		justBreath[i] = {newPanel(love.graphics.getWidth()/2, menuConfig.y+menuConfig.spacing*i-menuConfig.spacing, menuConfig.width, menuConfig.height, colour), rdata[i], "not selected", 0}
	end

	return {
		c = colour,
		c2 = colour2,
		selected = false,
		dataRaw = rdata,
		data = justBreath,
		draw = function(self) 
			for i=1, #self.data do
				if self.data[i][3] == "selected" then 
					self.data[i][4] = self.data[i][4] + (menuConfig.balloon-self.data[i][4])*0.4 *60*love.timer.getDelta()
					self.data[i][1]:setParameters(nil, nil, nil, nil, self.c2)
				else 
					self.data[i][4] = self.data[i][4] + (0-self.data[i][4])*0.4 *60*love.timer.getDelta()
					self.data[i][1]:setParameters(nil, nil, nil, nil, self.c)
				end
				local cal = self.data[i][4]/2/menuConfig.height + 1
				self.data[i][1]:setParameters(screen.menuX, menuConfig.y+menuConfig.spacing*i-menuConfig.spacing+(love.graphics.getHeight()-600)/600*(menuConfig.spacing*#self.dataRaw), menuConfig.width+self.data[i][4], menuConfig.height+self.data[i][4]/2)
				self.data[i][1]:draw()
				love.graphics.setColour(unpack(self.c2))
				if self.data[i][3] == "selected" then love.graphics.setColour(unpack(self.c)) end
				love.graphics.printf(self.data[i][2], screen.menuX-love.graphics.getWidth()/2, menuConfig.y+menuConfig.spacing*i-menuConfig.spacing-(screen.font.large:getHeight()/3)*cal+(love.graphics.getHeight()-600)/600*(menuConfig.spacing*#self.dataRaw), love.graphics.getWidth()/(menuConfig.fontscale*cal), "center", nil, menuConfig.fontscale*cal, menuConfig.fontscale*cal)
			end 
		end,
		update = function(self)
			love.mouse.setCursor() 
				for i=1, #self.data do
					self.data[i][3] = "not selected"
					if love.mouse.getY() > menuConfig.y+menuConfig.spacing*i-menuConfig.spacing+(love.graphics.getHeight()-600)/600*(menuConfig.spacing*#self.dataRaw) - menuConfig.height/2 and love.mouse.getY() < menuConfig.y+menuConfig.spacing*i+(love.graphics.getHeight()-600)/600*(menuConfig.spacing*#self.dataRaw)-menuConfig.spacing + menuConfig.height/2 
					and love.mouse.getX() > love.graphics.getWidth()/2 - menuConfig.width/2 + (screen.menuX-love.graphics.getWidth()/2) and love.mouse.getX() < love.graphics.getWidth()/2 + menuConfig.width/2 + (screen.menuX-love.graphics.getWidth()/2) then 
						love.mouse.setCursor(selected)
						self.data[i][3] = "selected"
						if love.mouse.isDown(1) then 
							screen.transition = self.dataRaw[i]
						end
					end
				end
		end
	}
end