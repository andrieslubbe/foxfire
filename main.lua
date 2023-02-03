push = require "libs/push/push"
bf = require "libs/breezefield"
Lighter = require "libs/lighter"


love.window.setTitle("Fox Fire")

require 'Player'
require 'Pillar'

lighter = Lighter()

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

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {
    fullscreen = false,
    resizable = false,
    pixelperfect = true
  })
  --push:setBorderColor{pal.black}

  world = bf.newWorld(0, 0, false)

  plant = player.new(gameWidth/2, gameHeight/2, 8)

  for i = 1, 10 do
    local rad = 8
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

  --local lightX, lightY = 500, 500

-- addLight signature: (x,y,radius,r,g,b,a)
  --local light = lighter:addLight(lightX, lightY, 300, pal.yellow)
end

function randomPos(rad)
  local out = {}
  --local boxOffset =  rad
  out.x = love.math.random(rad, gameWidth-rad)
  out.y = love.math.random(rad, gameHeight-rad)
  return out
end

function love.update(dt)
  world:update(dt)
  plant.update(dt)
end

-- Call after your light positions have been updated
function preDrawLights()
  --push:start()
  love.graphics.setCanvas({ lightCanvas, stencil = true})
  love.graphics.clear(0.4,0.4,0.4) -- Global illumination level
  self.lighter:drawLights()
  love.graphics.setCanvas()
  --push:finish()
end

-- Call after you have drawn your scene (but before UI)
function drawLights()
 -- push:start()
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.draw(lightCanvas)
  love.graphics.setBlendMode("alpha")
  --push:finish()
end

function love.draw()
  --push:start()
  
  --love.graphics.circle('fill', gameWidth/2, gameHeight/2, 12)
  lighter:drawLights()
  world:draw()
  --push:finish()

end