push = require "libs/push/push"
bf = require "libs/breezefield"
--wf = require "libs/windfield/windfield"
Lighter = require "libs/lighter"
anim8 = require("libs/anim8/anim8")


love.window.setTitle("Fox Fire")

require 'Player'
require 'Pillar'
require 'Moss'
require 'Enemy'
require 'Blood'
require 'Particles'
require 'Wall'
require 'Flower'

lighter = Lighter()
--Lighter:newWorld(800,600,{0,0,0,0.99})
local fontL = love.graphics.newFont(48)
local font = love.graphics.newFont(16)
local fontS = love.graphics.newFont(10)
gameWidth, gameHeight = 960, 540
screenWidth, screenHeight = 1920, 1080

--spriteflower, animflower, gflower
spriteflower = love.graphics.newImage("assets/images/flower-Sheet.png")
  gflower = anim8.newGrid(32,32, spriteflower:getWidth(), spriteflower:getHeight())
  
local score
local pillarcount
local timelimit = 300
local timetaken

pal = {
  green = {0.373,	1.000,	0.051},
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
  timetaken = 0
  pillarcount = 80
  pause = true
  score = 0

  --table.insert(flower, flower.new(300,200))
  sounds = {}
  sounds.light = love.audio.newSource("assets/sounds/light.mp3", "static")
  sounds.music = love.audio.newSource("assets/sounds/music.mp3", "static")
  sounds.enemy_death = love.audio.newSource("assets/sounds/enemy_death.mp3", "static")
  sounds.roots = love.audio.newSource("assets/sounds/roots.mp3", "static")
  sounds.boom = love.audio.newSource("assets/sounds/far_off_boom.mp3", "static")
  sounds.hit = love.audio.newSource("assets/sounds/hit-swing-sword-small-2.mp3", "static")
  sounds.music:setLooping(true)
  sounds.light:setLooping(true)
  sounds.light:setVolume(0.5)
  sounds.music:play()

  

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

  for i = 1, pillarcount do
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
  freqenemy = 1
  timerenemy= freqenemy
  --local lightX, lightY = 500R, 500

  wallThicknes = 2
  table.insert(wall, wall.new(gameWidth/2, gameHeight+wallThicknes, gameWidth + wallThicknes*2, wallThicknes))
  table.insert(wall, wall.new(gameWidth/2, -wallThicknes, gameWidth + wallThicknes * 2, wallThicknes))
  table.insert(wall, wall.new(-wallThicknes, gameHeight/2, wallThicknes, gameHeight))
  table.insert(wall, wall.new(gameWidth+wallThicknes, gameHeight/2, wallThicknes, gameHeight))

-- addLight signature: (x,y,radius,r,g,b,a)
  --local light = lighter:addLight(lightX, lightY, 300, pal.yellow)
  img_hourglass = love.graphics.newImage("assets/images/hourglass.png")

  img_floor_night = love.graphics.newImage("assets/images/floor_night_test.png")
  img_floor_night:setWrap("repeat", "repeat")
  img_floor_night_quad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, img_floor_night:getWidth(), img_floor_night:getHeight())

  img_shrooms = love.graphics.newImage("assets/images/shrooms.png")
  img_shrooms:setWrap("repeat", "repeat")
  img_shrooms_quad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, img_shrooms:getWidth(), img_shrooms:getHeight())
end


function love.gamepadpressed(joystick, button)
  if button == 'start' then
      --print("pause")
      pause = not pause
  elseif button =='x' then
    love.event.quit("restart")
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit("restart")
  end
  if key == "space" then
    pause = not pause
  end
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
function explode(x, y, col)
  --for i=1,12 do
  --  table.insert(particles, particles.new(
  --    x,y, 1,
  --    col,math.random(6,8)/20,-math.random(6,8)/20,math.random()*2*math.pi,math.random(28,44)))
  --end
  for i=1,5 do
    table.insert(particles, particles.new(
      x,y,4,
      'teal',2,1.1,math.random()*2*math.pi,math.random(7,12)))
  end
end

function enemySpawner(dt)
  timerenemy = timerenemy - dt
  if timerenemy < 0 then
    if #enemy < 12 then
      timerenemy = freqenemy
      local pos = randomPos(4)
      table.insert(enemy, enemy.new(pos.x, pos.y))
    end
  end
end

function love.update(dt)
  if pause then
    return
  end
  if #pillar == 0 or timetaken >= timelimit then
    pause = true
  end
  timetaken = timetaken + dt
  for i, p in ipairs(flower) do
    p.update(dt)
  end
  --animation:update(dt)
  joysticks = love.joystick.getJoysticks()
  world:update(dt)
  plant.update(dt)
  for i=#enemy,1,-1 do
    en = enemy[i]
    en.update(dt)
    if en.isDead() then
      explode(en.getX()+en.getRadius()/2, en.getY()+en.getRadius()/2, 'pink')
      table.insert(blood, blood.new(en.getX()+en.getRadius()/2,en.getY()+en.getRadius()/2,en.getRadius()*2))
      en.destroy()
      table.remove(enemy, i)
      score = score + 1
    end
  end
  
  enemySpawner(dt)

  for i=#pillar,1,-1 do
    pil = pillar[i]
    
    if pil.isDead() then 
      sounds.boom:play()
      table.insert(flower, flower.new(pil.getX()-pil.getWidth()/2,pil.getY()-pil.getHeight()/2))
      pil.destroy()
      table.remove(pillar,i)
      
    end
  end

  for i=#blood,1,-1 do
    bl = blood[i]
    bl.update(dt)
    if bl.isDead() then 
      bl.destroy()
      table.remove(blood,i)
    end
  end

  for p=#particles,1,-1 do
    local particle = particles[p]
    if particle.isDead() == true then
      table.remove(particles, p)
    else
      particle.update(dt)
    end
  end
  for i, p in ipairs(flower) do
    p.update(dt)
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
  love.graphics.setColor(1,1,1,1)

  lighter:drawLights()
  --love.graphics.setColor(1,1,1)
  --push:start()
  --love.graphics.circle('fill', plant:getX(), plant:getY(), plant:getLight())
  --push:finish()
end
local function playerStencil()
  love.graphics.setColor(1,1,1,1)
  love.graphics.circle('fill', plant:getX(), plant:getY(), plant:getLight() * plant.getRadius()/2.5)
end

local function shroomStencil()
  love.graphics.setColor(1,1,1,.4)
  for i, v in ipairs(moss) do
    love.graphics.circle("fill", 
      v.getX(),-- / gameWidth * screenWidth, 
      v.getY(), --/ gameHeight * screenHeight, 
      v.getRadius()) --/ gameHeight * screenHeight)
  end
  --love.graphics.setColor(0,0,0)
  
  --love.graphics.setColor(1,1,1)
end


local function pillarStencil()
  --love.graphics.setColor(0,1,1,1)
  for i, v in ipairs(pillar) do
    love.graphics.rectangle("fill", 
      v.getX()-v.getWidth()/2,
      v.getY()-v.getHeight()/2,
      v.getWidth(),
      v.getHeight()) 
  end
  
end

local function enemyStencil()
  love.graphics.setColor(1,1,1,.4)
  for i, v in ipairs(enemy) do
    love.graphics.rectangle("fill", 
      v.getX()-v.getRadius()/2,
      v.getY()-v.getRadius()/2,
      v.getWidth(),
      v.getHeight())
  end
  --love.graphics.setColor(0,0,0)
  
  --love.graphics.setColor(1,1,1)
end



function love.draw()
  --preDrawLights()
  
  --preDrawLights()
  push:start()
  --love.graphics.setStencilTest("greater",0)
  --love.graphics.stencil(floorStencil, "replace", 1)
  --love.graphics.draw(img_floor_night, img_floor_night_quad, 0, 0)
  --love.graphics.seartStencilTest()
    
  
  --preDrawLights()
  --love.graphics.clear(pal.purple)
  
  --love.graphics.circle('fill', gameWidth/2, gameHeight/2, 12)
  
  
  --love.graphics.clear(pal.purple)
  
  --love.graphics.draw(img_floor_night,img_floor_night_quad, 0,0)
  --love.graphics.stencil(shadowStencil, "replace", 0, true)
  --love.graphics.stencil(playerStencil, "replace", 255, true)
  --love.graphics.setStencilTest("greater", 0)
  --love.graphics.clear(pal.white)
  --love.graphics.setStencilTest()
  
  for i, p in ipairs(moss) do
    p.draw()
  end
  
 
  --love.graphics.clear(pal.purple)
  --love.graphics.setStencilTest()
  
  
  --
  plant.draw()
  for i, p in ipairs(enemy) do
    p.draw()
  end
  

  love.graphics.stencil(shroomStencil, "replace", 1)
  love.graphics.stencil(pillarStencil, "replace",0,true)
  
  
  --love.graphics.setColor(1,1,1)
  love.graphics.setStencilTest("equal",1)
  --
  --love.graphics.draw(img_floor_night,img_floor_night_quad, 0,0)
  
  love.graphics.draw(img_floor_night,img_floor_night_quad, 0,0)
  love.graphics.draw(img_shrooms, img_shrooms_quad, 0, 0)
  
  
 love.graphics.stencil(playerStencil,"replace",1,false)
 love.graphics.stencil(shroomStencil, "replace",0,true)
 love.graphics.setStencilTest("equal",1)
 love.graphics.draw(img_floor_night,img_floor_night_quad, 0,0)

  --love.graphics.setStencilTest("greater",0)
  --love.graphics.stencil(shadowStencil, "replace",1,false)
  --love.graphics.clear(pal.purple)
  love.graphics.setStencilTest()
  for i, p in ipairs(blood) do
    p.draw()
  end
 
  
  --love.graphics.stencil(pillarStencil, "replace", 1, false)
  --love.graphics.draw(img_floor_night, img_floor_night_quad, 0, 0)

  lighter:drawLights()
  for i, p in ipairs(particles) do
    p.draw()
  end
  for i, p in ipairs(flower) do
    p.draw()
  end
  --love.graphics.setStencilTest()
  world:draw()
  
  
  --local ammo = ''
  --for i=1,plant.getSpores() do
  --  ammo = ammo .. '•'
  --end
  
  local progress = ''
  for i=1,#pillar  do
    progress = progress .. '|'
  end
  for i=1,pillarcount - #pillar  do
    progress = progress .. '-'
  end
  love.graphics.setFont(font)
  
  love.graphics.setColor(pal.yellow)
  --love.graphics.printf(ammo, 0, gameHeight/16, gameWidth, 'center')
  --love.graphics.setFont(fontS)
  --love.graphics.printf(score, 0, gameHeight/16-10, gameWidth, 'center')
  love.graphics.printf(progress, 0, gameHeight/16*15+10, gameWidth, 'center')

  local timestring = ''
  for i=1,math.ceil(timetaken)  do
    timestring = timestring .. '\\'
  end
  for i=1,timelimit - math.ceil(timetaken)  do
    timestring = timestring .. '|'
  end
  love.graphics.setFont(fontS)
  love.graphics.setColor(pal.white)
  love.graphics.printf(timestring, 0, gameHeight/16-30, gameWidth, 'center')
  
 -- 
  --animation:draw(sprite, plant:getX()-plant:getRadius(),plant:getY()-plant:getRadius())
  
  push:finish()
  love.graphics.draw(img_hourglass,screenWidth-54,13)
  --love.graphics.print(love.timer.getFPS( ),10,10)
  if pause then
    drawMenu()
  end
end

function drawOutlineRec(y,width,height)
  love.graphics.setColor(pal.blue)
  love.graphics.rectangle("fill",screenWidth/2-width/2,y-13,width,height,4,4)
  love.graphics.setColor(unpack(pal.bteal))
  love.graphics.rectangle("line",screenWidth/2-width/2,y-13,width,height,4,4)
end

function drawMenu()
  --love.graphics.setColor(.2,.2,.2,.2)
  love.graphics.setColor(1, 1, 1, 0.05)
  love.graphics.rectangle("fill",0,0,screenWidth,screenHeight)
  love.graphics.setColor(pal.green)
  --drawOutlineRec(screenHeight/4,80,48)
  drawOutlineRec(screenHeight/5*4,160,40)
  love.graphics.setColor(pal.white)
  love.graphics.setFont(fontL)
  love.graphics.printf("| |", 0, screenHeight/4 , screenWidth, 'center')
  --love.graphics.printf("ESC", 0, screenHeight/4 , screenWidth, 'center')
  love.graphics.setFont(fontS)
  love.graphics.printf("|____________|", 0, screenHeight/5*4 , screenWidth, 'center')
end