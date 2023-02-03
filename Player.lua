player = {}

function player.new(x, y, r)
  local self = {}
  self.__index = self
  
  local speed = 1000
  local light = lighter:addLight(x, y, r*70, pal.bteal)

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
 

  function self.update(dt)
    local moveAngles = {}
    if love.keyboard.isDown("w") then
      table.insert(moveAngles, math.pi * 1.5)
      if love.keyboard.isDown("s") then
        table.insert(moveAngles,math.pi*2)
      end
    elseif love.keyboard.isDown("s") then
      table.insert(moveAngles,0)
    end
    if love.keyboard.isDown("r") then
      table.insert(moveAngles,math.pi / 2)
    end
    if love.keyboard.isDown("a") then
      table.insert(moveAngles, math.pi)
    end
    --print(#moveAngles)
    
    if #moveAngles > 0 then
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

    lighter:updateLight(light, self:getX(), self:getY())
  end

  function physics:draw()
  end

  function self.draw()
    love.graphics.setColor(unpack(pal.yellow))
    love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
  end

  
  return self

end

