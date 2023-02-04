player = {}

function player.new(x, y, r)
  local self = {}
  self.__index = self
  
  local speed = 2400
  local lightradmin = 3
  local lightrad = lightradmin
  local light = lighter:addLight(x, y, r, pal.teal)
  local lightgrow = 20
  local maxLight = 40
  local stopped = false
  local spawnFreq = .3
  local spawnTimer = spawnFreq
  local spores = 0
  local sporesmax = 10
  local freqspores = 0.1
  local timerspores = freqspores

  local physics = bf.Collider.new(world, 'Circle', x, y, r)
  --local physics = world:newRectangleCollider(x,y,r/2,height)
  physics:setLinearDamping(1.8)
  physics.identity = "player"
  --setmetatable(self, physics)

  function self.getX()
    return physics.getX()
  end
  function self.getY()
    return physics.getY()
  end
  function self.getRadius()
    return physics.getRadius()
  end
  function self.getLight()
    return lightrad
  end
  function self.isStopped()
    return stopped
  end
  function self.getSpores()
    return spores
  end


  --function love.keypressed(key)
  --  if key == "space" then
  --    sounds.roots:play()
  --    sounds.light:play()
  --    --physics:setLinearVelocity(0,0)
  --    stopped = true
  --    --light = lighter:addLight(x, y, r*70, pal.bteal)
  --  end
  --end

  function self.still(dt)
    physics:setLinearDamping(10)
    if lightrad < maxLight then
      lightrad = lightrad + dt * lightgrow
    end
    timerspores = timerspores - dt
    if timerspores < 0 then
      timerspores = freqspores
      if spores < sporesmax then 
        spores = spores + 1
      end
    end
    --for i=#moss,1,-1 do
    --  dried = moss[i]
    --  local dist = distanceBetween(dried.getX(), dried.getY(), self:getX(), self:getY())
    --  if dist < self:getRadius() * lightrad then
    --    local fact = dist / lightrad^2
    --    dried.lit(fact)
    --  end
    --end
  end

  function self.moving(dt)
    spawnTimer = spawnTimer - dt
    if spawnTimer <= 0 then
      if spores > 0 then 
        spawnTimer = spawnFreq
        table.insert(moss, moss.new(self:getX(), self:getY()))
        spores = spores - 1
      end
    end
    physics:setLinearDamping(1.8)
    if lightrad > lightradmin then 
      lightrad = lightrad - dt * lightgrow*5
      if lightrad < lightradmin then
        lightrad = lightradmin
      end
    end
  end
  
    

  function self.update(dt)
    --for i, p in ipairs(moss) do
    --  p.update(dt)
    --end
    for i=#enemy,1,-1 do
      en = enemy[i]
      local dist = distanceBetween(en.getX(), en.getY(), self:getX(), self:getY())
      if dist <  lightrad / 2.5 * self:getRadius() then
          en.lit()
        
      end
    end

    for i=#moss,1,-1 do
      dried = moss[i]
      local dist = distanceBetween(dried.getX(), dried.getY(), self:getX(), self:getY())
      if dist < lightrad / 2.5 * self:getRadius() then
        local fact = lightrad / dist
        if fact > 0.7 then
          fact = 0.7
        end
          dried.lit(fact)
        
      end
      dried.update(dt)
      if dried.isDead() then
        table.remove(moss, i)
        dried.destroy()
      end
    end


    if stopped == true then
      self.still(dt)
      
    else
      self.moving(dt)
      --sounds.light:stop()
    end
    
    lighter:updateLight(light, self:getX(), self:getY(), lightrad * self:getRadius())
    local moveAngles = {}
  
   
      if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        table.insert(moveAngles, math.pi * 1.5)
        if love.keyboard.isDown("s") or love.keyboard.isDown("right") then
          table.insert(moveAngles,math.pi*2)
        end
      elseif love.keyboard.isDown("s") or love.keyboard.isDown("right") then
        table.insert(moveAngles,0)
      end
      if love.keyboard.isDown("r") or love.keyboard.isDown("down") then
        table.insert(moveAngles,math.pi / 2)
      end
      if love.keyboard.isDown("a")  or love.keyboard.isDown("left") then
        table.insert(moveAngles, math.pi)
      end
      --print(#moveAngles)
      
      if #moveAngles > 0 then
        stopped = false
        local sum = 0
        for _,v in pairs(moveAngles) do -- Get the sum of all numbers in t
          sum = sum + v
        end
        local moveAngle = sum / #moveAngles
        --moveAngle = moveAngle % (2 * math.pi)
        local xbounce = math.cos(moveAngle) * speed * dt
        local ybounce = math.sin(moveAngle) * speed * dt
        physics:applyForce(xbounce,ybounce)
      else 
        stopped = true
      end
    
    --print(physics:getLinearVelocity())

  
  end

  function physics:draw()
    love.graphics.setColor(1,1,1, 0.1)
    love.graphics.circle('fill',self:getX(), self.getY(),self:getRadius())
  end

  function self.draw()
    --love.graphics.setColor(unpack(pal.yellow))
    --love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
    --lighter:drawVisibilityPolygon(light)
    
  end

  return self

end

