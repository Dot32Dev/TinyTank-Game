DotLib = {version = 357}
local config = { --Dissables/Enables certain features
  intro = true,
  menu = false
}

intro = {}
if config.intro == true then
  intro.dot32 = {}
  intro.dot32.font = love.graphics.newFont("DotLib/PT_Sans/PTSans-Bold.ttf", 100)
  intro.dot32.x = love.graphics.getWidth()/2
  intro.dot32.y = 0
  intro.dot32.yV = 0

  intro.sub = {}
  intro.sub.font = love.graphics.newFont("DotLib/PT_Sans/PTSans-Regular.ttf", 45)
  intro.sub.text = "Games" -- The text that appears under the "Dot32"
  intro.sub.x = 0
  intro.sub.y = love.graphics.getHeight()/1.65
  intro.sub.xV = 0

  intro.length = 0.5 --fun to change
  intro.fadingMultiply = 0.2
  intro.state = 1
  intro.alpha = 1
end

local menu = {}
if config.menu == true then 
  
end

collision = {}
collision.dictionary = {} --a lookup for every single line in the collision system (set to empty)
collision.objectList = {} --a lookup for every object in the collision system (set to empty)


local timer = {}
timer.timer = 0
timer.alpha = 0
timer.update = 0
timer.frame = 0

function DotLib.load(menuText, mainc, highc, menuButtons)
  --[[Creates Australian-English translations of the colour functions]]
  love.graphics.getBackgroundColour = love.graphics.getBackgroundColor
  love.graphics.getColour           = love.graphics.getColor
  love.graphics.getColourMask       = love.graphics.getColorMask
  love.graphics.getColourMode       = love.graphics.getColorMode
  love.graphics.setBackgroundColour = love.graphics.setBackgroundColor
  love.graphics.setColour           = love.graphics.setColor
  love.graphics.setColourMask       = love.graphics.setColorMask
  love.graphics.setColourMode       = love.graphics.setColorMode

  --[[Saves colours in config so that it can be read from DotLib.update()]]
  config.mainc = mainc
  config.highc = highc

  --[[Screen is a global variable]]
  screen = {}
  screen.font = {}
  screen.font.main = love.graphics.newFont("DotLib/Heebo/static/Heebo-SemiBold.ttf", 20)
  screen.font.large = love.graphics.newFont("DotLib/Heebo/static/Heebo-SemiBold.ttf", 60)
  screen.state = "intro"
  screen.menuX = love.graphics.getWidth()/2
  screen.transition = false --do not set to true
  screen.slide = false      --do not set to true

  --[[Creates a new menu with my menu library]]
  if config.menu == true then 
    require("DotLib.Menu")
    menu.text = menuText
    menu.hash = #menuButtons
    mainMenu = newMenu({mainc[1], mainc[2], mainc[3]},{highc[1], highc[2], highc[3]},menuButtons)
    
    love.graphics.setBackgroundColour(unpack(mainc)) --unpack is so cool
  end
end

function DotLib.update(dt)
  --[[Updating timer]]
  timer.timer = timer.timer + dt
  DotLib.timer = timer.timer      --setting as a global variable
  timer.frame = timer.frame + dt

  --[[Only run if the intro is enabled]]
  if config.intro == true then 
    timer.update = timer.update + dt -- measures time between the last intro frame; the intro runs at a fixed fps
    if timer.update > 1/65 then      -- if it has been more than the desired fps, it updates
      timer.update = 0               -- resseting the time

      --[[Move "Dot32"]]
      intro.dot32.yV = intro.dot32.yV + ((love.graphics.getHeight()/2 - intro.dot32.y)*0.5)*faenBoolean(intro.state == 1)
      intro.dot32.y = intro.dot32.y + intro.dot32.yV/2
      intro.dot32.yV = intro.dot32.yV * 0.6

      --[[Move subtext ("Games")]]
      intro.sub.xV = intro.sub.xV + (love.graphics.getWidth()/2 - intro.sub.x)*0.5
      intro.sub.x = intro.sub.x + intro.sub.xV/2
      intro.sub.xV = intro.sub.xV * 0.6
    end

    --[[At end of the intro, either run the menu or default to Play.lua]]
    if timer.timer > intro.length and intro.state == 1 then
      intro.state = 2
      if config.menu == true then -- if the menu is enabled, run the menu
        love.graphics.setFont(screen.font.large)
        screen.state = "menu"
      else
        love.graphics.setFont(screen.font.main)
        screen.transition = "Play" -- default to Play.lua if config.menu == false
      end
    end
    if intro.state == 2 then --After the intro is complete, slowly fade it out
      intro.alpha = intro.alpha +(-intro.alpha)*intro.fadingMultiply *60*dt
    end
    --[[Updates the menu]]
    if timer.timer > intro.length + intro.fadingMultiply then
      intro.state = 3
      if config.menu == true and (screen.state == "menu" or screen.state == "intro" or screen.transition ~= false) then
        mainMenu:update()
      end
    end
  else -- Run if the intro is *dissabled*
    if config.menu == true and (screen.state == "menu" or screen.state == "intro" or screen.transition ~= false) then
      mainMenu:update()
    end
  end

  --[[Positions the menu]]
  if screen.state == "menu" or screen.state == "intro" or screen.transition ~= false then
    screen.menuX = screen.menuX + (love.graphics.getWidth()/2 - screen.menuX)*0.3 *60*dt  --slides the menu's x position to the centre of the screen.
  else
    screen.menuX = screen.menuX + (-love.graphics.getWidth()/2 - screen.menuX)*0.3 *60*dt --slides the menu's x position off the screen.
  end

  --[[If screen.transition is set to a state then:]]
  if screen.transition ~= false then
    timer.alpha = timer.alpha + (1 - timer.alpha)*0.4 *60*dt    --make screen darker
    if timer.alpha > 0.999 then                                     --once fully dark, require and run the file
      screen.state = screen.transition                                --the screen.state is set to whatever the transition was trying to transition to
      screen.transition = false
      timer.timer = 0
      love.mouse.setCursor()
      love.graphics.setBackgroundColour(0, 0, 0)                      --this is so the screen isn't the colour of the menu by default
      require(screen.state)                                           --requiring the screen state
      _G[screen.state].load()                                         --loads the screen state

      timer.alpha = timer.alpha + (0 - timer.alpha)*0.4 *60*dt  --make screen a bit lighter
    end
  else
    timer.alpha = timer.alpha + (0 - timer.alpha)*0.4 *60*dt    --make screen lighter
  end

  --[[When not on the menu/intro, run the update function for the screen.state]]
  if not (screen.state == "menu" or screen.state == "intro" or screen.transition ~= false) then
    _G[screen.state].update(dt) --if screen.state is "Play", then it will run Play.update(dt), etc etc
    timer.frame = 0
  end
end

function DotLib.draw()
  --[[Stores any colour data that a different file might have set]]
  r, g, b, a = love.graphics.getColour()

  --[[Draws the menu screen]]
  if config.menu == true and (screen.state == "menu" or screen.state == "intro" or screen.transition ~= false) then
    love.graphics.setFont(screen.font.large)
    mainMenu:draw()
    love.graphics.setColour(config.highc[1], config.highc[2], config.highc[3])
    love.graphics.print(menu.text, screen.menuX-screen.font.large:getWidth(menu.text)/2, 50+(love.graphics.getHeight()-600)/600*(screen.menuSpacing*menu.hash))
  end

  --[[Draws the transition screen with the alpha of timer.alpha]]
  love.graphics.setColour(0.2, 0.2, 0.2, timer.alpha)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  --[[Draws the intro with the alpha of intro.alpha]]
  if config.intro == true and intro.state < 3 then
    love.graphics.setColor(0.17, 0.17, 0.17, intro.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, intro.alpha)
    love.graphics.setFont(intro.dot32.font)
    love.graphics.print("Dot32", intro.dot32.x - intro.dot32.font:getWidth("Dot32")/2, intro.dot32.y - intro.dot32.font:getHeight()/2)
    love.graphics.setFont(intro.sub.font)
    love.graphics.print(intro.sub.text, intro.sub.x - intro.sub.font:getWidth(intro.sub.text)/2, intro.sub.y - intro.sub.font:getHeight()/2)

    love.graphics.setColor(0.2, 0.2, 0.2, intro.alpha)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()-5, love.graphics.getWidth()-(love.graphics.getWidth()/intro.length)*timer.timer, 5)
  end

  --[[When not on the menu/intro, draw the current game state]]
  if not (screen.state == "menu" or screen.state == "intro" or screen.transition ~= false) then
    love.graphics.setColour(r,g,b,a)
    _G[screen.state].draw() --if screen.state is "Play", then it will draw Play.draw(), etc etc
  end
end

--[[A utility function, can be useful for multiplying a value by a boolean]]
function faenBoolean(boolean) -- is effectively implementing scratch's method for booleans
  if boolean == true then
    return 1
  else
    return 0
  end
end

--[[A utility function, can be useful for interpolating between two colours, as it looks nicer to travel through the HSL spectrum than the RBG spectrum]]
function HSL(h, s, l, a) -- found on wiki! (https://love2d.org/wiki/HSL_color)
  if s<=0 then return l,l,l,a end
  h, s, l = h*6, s, l
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return {r+m, g+m, b+m, a}--(r+m),(g+m),(b+m),a
end

--[[Will enable fullscreen when the OS specific keyboard shortcuts are pressed]]
-- code has been moved to play.lua

--[[A utility function, can be useful for converting tables into save files]]
function varToString(var) -- thank you so much HugoBDesigner! (https://love2d.org/forums/viewtopic.php?t=82877)
  if type(var) == "string" then
    return "\"" .. var .. "\""
  elseif type(var) ~= "table" then
    return tostring(var)
  else
    local ret = "{ "
    local ts = {}
    local ti = {}
    for i, v in pairs(var) do
      if type(i) == "string" then
        table.insert(ts, i)
      else
        table.insert(ti, i)
      end
    end
    table.sort(ti)
    table.sort(ts)
    
    local comma = ""
    if #ti >= 1 then
      for i, v in ipairs(ti) do
        ret = ret .. comma .. varToString(var[v])
        comma = ", \n"
      end
    end
    
    if #ts >= 1 then
      for i, v in ipairs(ts) do
        ret = ret .. comma .. "" .. v .. " = " .. varToString(var[v])
        comma = ", \n"
      end
    end
    
    return ret .. "}"
  end
end

--[[A utility function, gets distance]]
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2-y1)^2 + (x2-x1)^2)
end

--[[All functions below here are collision related!]]
--[[~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]

--[[Adds a new line to the table of objects]]
function collision.newLine(pos1, pos2)
  local line = {pos1, pos2}
  table.insert(collision.dictionary, line)
end

--[[Creates a new shape. it has in built functions for detecting other objects in the collision dictionary!]]
function collision.newPolygon(xa, ya, radius, dira, segments)
  for i=1, segments do
    local angle = (math.pi*2/segments)/i
    local pos1 = {math.sin((math.pi*2)/segments*(i-1)+dira)*radius+xa, math.cos((math.pi*2)/segments*(i-1)+dira)*radius+ya}
    local pos2 = {math.sin((math.pi*2)/segments*i+dira)*radius+xa, math.cos((math.pi*2)/segments*i+dira)*radius+ya}
    local line = {pos1, pos2}
    table.insert(collision.dictionary, line)
  end
  rt = {                              --"Return Table" rather than directly returning it i am also saving it to an object table for automatic access in a loop
    --
    segmentHash = segments,           --the amount of sides the shape has
    key = #collision.dictionary,      --it's position in the collision dictionary
    x = xa,
    y = ya,
    r = radius,
    dir = dira,
    owns = function(self, line)       --when given any line from the dictionary, this function returns true if said line is part of this object.
      if line > self.key-self.segmentHash and line <= self.key then
        return true
      else
        return false
      end
    end,
    update = function(self, xa, ya, radius, dira) --regernates the object, but with new parameters 
      for i=self.key-self.segmentHash+1, self.key do
        local angle = (math.pi*2/segments)/i
        local pos1 = {math.sin((math.pi*2)/segments*(i-1)+dira)*radius+xa, math.cos((math.pi*2)/segments*(i-1)+dira)*radius+ya}
        local pos2 = {math.sin((math.pi*2)/segments*i+dira)*radius+xa, math.cos((math.pi*2)/segments*i+dira)*radius+ya}
        local line = {pos1, pos2}
        collision.dictionary[i] = line
      end 
    end,
    

    --[[THE COLLISION FUNCTION: loops through all lines in the dictionary, 
    and if the line is not owned by itself, it loops collision on that line with 
    every line the object contains]]

    --[[A collision is detected if the formulas uA and uB are both within the 1 to 0 range.The formula 
    itself was found online here: http://www.jeffreythompson.org/collision-detection/line-line.php]]
    isTouching = function(self)
      local r = false --assumes no collision by default
      for i=1, #collision.dictionary do
        if not self:owns(i) then
          for ii=self.key-self.segmentHash+1, self.key do
            local x1 = collision.dictionary[i][1][1]
            local y1 = collision.dictionary[i][1][2]
            local x2 = collision.dictionary[i][2][1]
            local y2 = collision.dictionary[i][2][2]

            local x3 = collision.dictionary[ii][1][1]
            local y3 = collision.dictionary[ii][1][2]
            local x4 = collision.dictionary[ii][2][1]
            local y4 = collision.dictionary[ii][2][2]

            local uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1))
            local uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1))

            if uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1 then
              r = true
              return r
            end
          end
        end
      end
      return r
    end,
    --[[Similar to the above equation but instead returns a table of all the collision points!]]
    whereTouching = function(self)
      local r = {} --assumes no collision points by default
      for i=1, #collision.dictionary do
        if not self:owns(i) then
          for ii=self.key-self.segmentHash+1, self.key do
            local x1 = collision.dictionary[i][1][1]
            local y1 = collision.dictionary[i][1][2]
            local x2 = collision.dictionary[i][2][1]
            local y2 = collision.dictionary[i][2][2]

            local x3 = collision.dictionary[ii][1][1]
            local y3 = collision.dictionary[ii][1][2]
            local x4 = collision.dictionary[ii][2][1]
            local y4 = collision.dictionary[ii][2][2]

            local uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1))
            local uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1))

            if uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1 then
              local intersectionX = x1 + (uA * (x2-x1))
              local intersectionY = y1 + (uA * (y2-y1))
              table.insert(r, {intersectionX, intersectionY}) --adds a point to the return table
            end
          end
        end
      end
      return r
    end
  }
  table.insert(collision.objectList, rt)
  return rt
end