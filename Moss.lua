moss = {}

function moss.new(x, y)
  local self = {}
  self.__index = self

  --local rad= 4
  local growrate = 0.02
  local decay = .8
  local x = x
  local y = y
  --local light = lighter:addLight(x, y, rad, pal.yellow)
  local life = 0.01
  local dead = false
  local lit = 0
  local energy = 3

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

  function self.update(dt)
    
    if life <= 0 then
      dead = true
    end
    if lit>0 then -- update energy
      energy = energy + lit*dt
      lit = 0
      --rad = rad + dt*growrate
      --life = life + dt*growrate
      --lighter:updateLight(light, nil, nil, rad)
    end
    if energy > 0 then
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
      if dist < self:getRadius() + p.getRadius() then
        p.kill()
      end
    end

  end

  function self.draw()
    love.graphics.setColor(pal.yellow)
    love.graphics.circle('fill', x, y, life)
  end

  return self

end