push = require "libs/push/push"
bf = require "libs/breezefield"
--wf = require "libs/windfield/windfield"
Lighter = require "libs/lighter"


love.window.setTitle("Fox Fire")

require 'Player'
require 'Pillar'
require 'Moss'
require 'Enemy'

lighter = Lighter()
--Lighter:newWorld(800,600,{0,0,0,0.99})


gameWidth, gameHeight = 960, 540
screenWidth, screenHeight = 1920, 1080


pal = {
  red =     {0.875, 0.027, 0.447},
  pink =    {0.996, 0.329, 0.435},
  orange =  {1.000, 0.620, 0.490},
  yellow =  {1.000, 0.816, 0.502},
  white =   {1.000, 0.992, 1.000},
  bteal =   {0.043, 1.000, 0.902},
  teal =    {0.004, 0.796, 0.812},
  blue =    {0.004, 0.533, 0.647},
  purple =  {0.243, 0.196, 0.392},
  black =   {0.208, 0.165, 0.333}
}

local shader_code = [[

]]

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function getAngle(x1, y1, x2, y2)
  return math.atan2(y1 - y2,x1 - x2) + math.pi
end

function distAngle(x1, y1, x2, y2)
  out = {}
  out.dist = distanceBetween(x1, y1, x2, y2)
  out.angle = getAngle(x1, y1, x2, y2)
  return out
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {
    fullscreen = false,
    resizable = false,
    pixelperfect = true
  })
  --push:setBorderColor{pal.black}
  --Lighter:newWorld(gameWidth,gameHeight,{0,0,0,0.99})
  world = bf.newWorld(0, 0, false)

  plant = player.new(gameWidth/2, gameHeight/2, 8)

  for i = 1, 10 do
    local rad = 12
    local pos = randomPos(rad)
    table.insert(pillar, pillar.new(pos.x, pos.y, rad*2,rad*2))
  end

  --local wall = {
  --    100, 100,
  --    300, 100,
  --    300, 300,
  --    100, 300
  --}
--
  --lighter:addPolygon(wall)
  freqenemy = 0.2
  timerenemy= freqenemy
  --local lightX, lightY = 500, 500

-- addLight signature: (x,y,radius,r,g,b,a)
  --local light = lighter:addLight(lightX, lightY, 300, pal.yellow)
  img_floor_night = love.graphics.newImage("assets/images/floor_night_test.png")
  img_floor_night:setWrap("repeat", "repeat")
  img_floor_night_quad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, img_floor_night:getWidth(), img_floor_night:getHeight())
end

function randomPos(rad)
  local out = {}
  --local boxOffset =  rad
  out.x = love.math.random(rad, gameWidth-rad)
  out.y = love.math.random(rad, gameHeight-rad)
  return out
end

--function spawnEnemy()
--  local side = love.math.random(0, 3)
--  if side == 0 then
--    table.insert(enemy, enemy.new(gameWidth-9, love.math.random(9, gameHeight-9))) --right
--  elseif side == 1 then
--    table.insert(enemy, enemy.new(9, love.math.random(9, gameHeight-9))) --left
--  elseif side == 2 then
--    table.insert(enemy, enemy.new(love.math.random(9, gameWidth-9), gameHeight-9)) --bottom
--  elseif side == 3 then
--    table.insert(enemy, enemy.new(love.math.random(9, gameWidth-9), 9)) --top
--  end
--end

function love.update(dt)
  world:update(dt)
  plant.update(dt)
  for i=#enemy,1,-1 do
    en = enemy[i]
    en.update(dt)
    if en.isDead() then
      en.destroy()
      table.remove(enemy, i)
    end
  end
  timerenemy = timerenemy - dt
  if timerenemy < 0 then
    timerenemy = freqenemy
    local pos = randomPos(4)
    table.insert(enemy, enemy.new(pos.x, pos.y))
  end

end

-- Call after your light positions have been updated
function preDrawLights()
  
  love.graphics.setCanvas({ lightCanvas, stencil = true})
  love.graphics.clear(pal.purle) -- Global illumination level
  push:start()
  self.lighter:drawLights()
  push:finish()
  love.graphics.setCanvas()
 -- push:finish()
end

-- Call after you have drawn your scene (but before UI)
function drawLights()
 -- push:start()
  love.graphics.setBlendMode("multiply", "alphamultiply")
  
  love.graphics.draw(lightCanvas)
  love.graphics.setBlendMode("alpha")
  --push:finish()=
end

local function shadowStencil()
  --love.graphics.setColor(0,0,0)

  lighter:drawLights()
end

function love.draw()
  --preDrawLights()
  
  --preDrawLights()
  push:start()
  --love.graphics.setStencilTest("greater",0)
  --love.graphics.stencil(floorStencil, "replace", 1)
  --love.graphics.draw(img_floor_night, img_floor_night_quad, 0, 0)
  --love.graphics.seartStencilTest()
    
  --love.graphics.draw(img_floor_night,img_floor_night, 0,0)
  --preDrawLights()
  --love.graphics.clear(pal.purple)
  
  --love.graphics.circle('fill', gameWidth/2, gameHeight/2, 12)
  
  
  --love.graphics.clear(pal.purple)
  
 
  love.graphics.stencil(shadowStencil, "replace", 1, true)
  love.graphics.setStencilTest("greater", 0)
  --love.graphics.clear(pal.white)
  --love.graphics.setStencilTest()
  for i, p in ipairs(moss) do
    p.draw()
  end
  --love.graphics.clear(pal.yellow)
  --love.graphics.setStencilTest()
  world:draw()
  
  --love.graphics.draw(img_floor_night,img_floor_night_quad, 0,0)
  plant.draw()
  
  
  for i, p in ipairs(enemy) do
    p.draw()
  end
  lighter:drawLights()
  push:finish()
  
end