player = {}

function player.new(x, y, r)
  local self = {}
  self.__index = self
  
  local speed = 1400
  local lightrad = 1
  local light = lighter:addLight(x, y, r, pal.bteal)
  local isStopped = false

  local physics = bf.Collider.new(world, 'Circle', x, y, r)
  physics:setLinearDamping(1.8)
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

  function love.keypressed(key)
    if key == "space" then
      --physics:setLinearVelocity(0,0)
      isStopped = true
      --light = lighter:addLight(x, y, r*70, pal.bteal)
    end
  end
 

  function self.update(dt)
    if isStopped == true then
      physics:setLinearDamping(10)
      if lightrad < 80 then
        lightrad = lightrad + 0.01/dt
      end
    else
      physics:setLinearDamping(1.8)
      lightrad = 1
    end
    
    lighter:updateLight(light, self:getX(), self:getY(), self.getRadius() * 2 * lightrad)
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
      isStopped = false
      local sum = 0
      for _,v in pairs(moveAngles) do -- Get the sum of all numbers in t
        sum = sum + v
      end
      local moveAngle = sum / #moveAngles
      --moveAngle = moveAngle % (2 * math.pi)
      local xbounce = math.cos(moveAngle) * speed * dt
      local ybounce = math.sin(moveAngle) * speed * dt
      physics:applyForce(xbounce,ybounce)
    end
  
    --print(physics:getLinearVelocity())

    
  end

  function physics:draw()
  end

  function self.draw()
    --love.graphics.setColor(unpack(pal.yellow))
    --love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
  end

  
  return self

end

