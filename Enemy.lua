enemy = {}

function enemy.new(x, y)
  local self = {}
  self.__index = self
  
  local width = 8
  local height = 8
  local pow = 40
  local dead = false
  local lit = 0
  local trap = 0
  local hit = 0
  --local freqmove = math.random(15,40)/10
  --local timermove = 0
  --local wall = {
  --  x-width/2,y-height/2,
  --  x+width/2,y-height/2,
  --  x+width/2,y+height/2,
  --  x-width/2,y+height/2,
  --}
  --local poly = lighter:addPolygon(wall)

  local physics = bf.Collider.new(world, 'Rectangle', x, y, width, height)
  physics:setLinearDamping(1.2)

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
  function self.trap()
    trap = 1
  end

  function self.update(dt)
    --timermove = timermove - dt
    --if timermove < 0 then
    --  timermove = freqmove
    --  
    --end
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

    if trap > 0 then
      trap = trap - dt
      if trap < 0 then
        trap = 0
      end
    end 
    if hit > 0 then
      physics:setLinearDamping(0.05)
      hit = hit - dt
    end 
    if hit < 0 then 
      physics:setLinearDamping(1.2) 
      hit = 0
    end
  end

  function physics:postSolve(other)
    if other.identity == 'player' then
      if trap > 0 then
        --self:kill()
        hit = 1
        --dead = true
      else
        --TODO: damage player
      end
    elseif other.identity == 'pillar' then
      if hit > 0 then
        dead = true
      end
    end
  end

  function physics:draw(alpha)
    local col = pal.red
    if trap>0 then
      col = pal.white
    end
    love.graphics.setColor(col)
    if lit>0 or hit>0 then
      --style = 'fill'
      --love.graphics.setColor(unpack(pal.white))
      --love.graphics.rectangle('fill', self:getX(),self:getY(),width,height)
    --else
    --  love.graphics.setColor(unpack(pal.orange))
      --love.graphics.setColor(0.875, 0.027, 0.447,0.2)
      love.graphics.rectangle('fill', self:getX(),self:getY(),width,height)
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