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

  function self.draw()
    love.graphics.setColor(0.996, 0.329, 0.435, 1)
    love.graphics.circle("fill", x,y,r)
  end

  return self
end