enemy = {}

function enemy.new(x, y)
  local self = {}
  self.__index = self
  
  local width = 4
  local height = 4
  local pow = 20
  local dead = false
  local lit = 0
  --local wall = {
  --  x-width/2,y-height/2,
  --  x+width/2,y-height/2,
  --  x+width/2,y+height/2,
  --  x-width/2,y+height/2,
  --}
  --local poly = lighter:addPolygon(wall)

  local physics = bf.Collider.new(world, 'Rectangle', x, y, width, height)
  physics:setLinearDamping(1.8)

  function self.getX()
    return physics.getX()
  end
  function self.getY()
    return physics.getY()
  end
  function self.getRadius()
    return width
  end
  function self.isDead()
    return dead
  end
  function self.kill()
    dead = true
  end
  function self.destroy()
    physics:destroy()
  end
  function self.lit()
    lit = 1
  end

  function self.update(dt)
    if lit == 0  then
      
      local a = getAngle(self:getX(), self:getY(), plant.getX(), plant.getY())
      local xbounce = math.cos(a) * pow * dt
      local ybounce = math.sin(a) * pow * dt
      physics:applyForce(xbounce,ybounce)
      --lighter:updatePolygon(light, self:getX(), self:getY())
      --poly = 
    else
      lit = lit - dt
      if lit < 0 then
        lit = 0
      end
    end
  end

  function physics:draw(alpha)
    local style = 'line'
    if lit>0 then
      style = 'fill'
      --love.graphics.setColor(unpack(pal.white))
      --love.graphics.rectangle('fill', self:getX(),self:getY(),width,height)
    --else
    --  love.graphics.setColor(unpack(pal.orange))
    love.graphics.setColor(pal.red)
    love.graphics.rectangle(style, self:getX(),self:getY(),width,height)
    end
    
    
  end


  function self.draw()
    
    --if lit then
    --  love.graphics.setColor(unpack(pal.white))
    --  love.graphics.rectangle('fill', x,y,width,height)
    --end
  end

  return self

end