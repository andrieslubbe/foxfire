blood = {}

function blood.new(x, y, r)
  local self = {}
  self.__index = self

  local maxrad = r
  local x,y,r = x,y,2
  local growrate = 3
  local hit = 0
  local grow = 1
  
  --local life = lifemax

  local light = lighter:addLight(x, y, r, pal.red)

  function self.hit()
    hit = 1
  end

  function self.update(dt)
    if grow == 1 then
      if r < maxrad then
        r = r + dt * growrate
      else
        grow = 0
        r = maxrad
      end
    else
      if hit ==1 then
        r = r - 1
      end
    --else
    --  r = r - dt * growrate
    end
    --if r > lifemax then
    --  grow = 0
    --end
    lighter:updateLight(light, nil, nil, r*2.5)
  end
  function self.getX()
    return x
  end
  function self.getY()
    return y
  end
  function self.getRadius()
    return r
  end
  
  function self.isDead()
    return r <= 0
  end

  function self.destroy()

  end

  function self.draw()
    love.graphics.setColor(0.875, 0.027, 0.447,0.5)
    love.graphics.circle("fill", x,y,r)
  end

  return self
end