moss = {}

function moss.new(x, y)
  local self = {}
  self.__index = self

  --local rad= 4
  local growrate = 2
  local decay = 1
  local lightscale = 10
  local x = x
  local y = y
  
  local life = 0.01
  local lifemax = 40
  local dead = false
  local lit = 0
  local energy = 3
  local light = lighter:addLight(x, y, life, 0.373,	1.000,	0.051 , 0.5)

  --local physics = bf.Collider.new(world, 'Circle', x, y, 4)
  function self.getX()
    return x
  end
  function self.getY()
    return y
  end
  function self.getRadius()
    return life
  end
  function self.destroy()
    lighter:removeLight(light)
    --physics:destroy()
  end
  function self.isDead()
    return dead
  end

  function self.lit(fact)
    lit = fact
    --print(lit)
  end
  function self.hit()
    life = life -3
  end

  function self.update(dt)
    
    if life <= 0 then
      dead = true
    end
    if lit>0 then -- update energy
      energy = energy + lit*dt *lightscale
      lit = 0
      --rad = rad + dt*growrate
      --life = life + dt*growrate
      
    end
    if energy > 0 and life < lifemax then
      if energy > growrate then -- excess energy
        energy = energy - growrate
        life = life + growrate
      elseif energy <= 0 then 
        energy = 0
      else --some energy
        life = life + energy
        energy = 0

      end
    else
      life = life - dt * decay
    end
    

    for i, p in ipairs(enemy) do
      local dist = distanceBetween(p.getX(), p.getY(), self:getX(), self:getY())
      if dist < life   then
        p.lit()
        p.trap()
      end
      if dist < self:getRadius() + p.getRadius() then
        --p.kill()
        --self:hit()
      end
    end
    for i, p in ipairs(blood) do
      local dist = distanceBetween(p.getX(), p.getY(), self:getX(), self:getY())
      if dist < life + p.getRadius() then
        self:hit()
        p.hit()
      end
    end
    lighter:updateLight(light, nil, nil, life*2)

  end

  function self.draw()
    love.graphics.setColor(1,1,1, 0.1)
    love.graphics.circle('line', x, y, life)
  end

  return self

end