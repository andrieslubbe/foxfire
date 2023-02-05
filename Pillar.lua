pillar = {}

function pillar.new(x, y, width, height)
  local self = {}
  self.__index = self
  local width,height = width,height
  --local dead = false


  local wall = {
    x-width/2,y-height/2,
    x+width/2,y-height/2,
    x+width/2,y+height/2,
    x-width/2,y+height/2,
  }
  local light = lighter:addPolygon(wall)
  local physics = bf.Collider.new(world, 'Rectangle', x, y, width, height)
  physics.identity = 'pillar'
  physics.dead = false
  physics:setType('static')
  setmetatable(self, physics)
  --local physics = world:newRectangleCollider(x,y,width,height)

  function self.getX()
    return physics.getX()
  end
  function self.getY()
    return physics.getY()
  end
  function self.getWidth()
    return width
  end
  function self.getHeight()
    return height
  end
  

  function self.isDead()
    return physics.dead
  end
  function self.kill()
    physics.dead = true
  end
  function self.destroy()
    lighter:removePolygon(wall)
    physics:destroy()
  end

  --function physics:postSolve(other)
  --  if other.identity == 'enemy' then
  --    local colls = world:queryCircleArea(self:getX(), self:getY(), self:getRadius()*1.5)
  --    for _, collider in ipairs(colls) do
  --      if collider.identity == 'enemy' then
  --        p:destroy()
  --      end
  --    end
  --  end
  --    dead = true
  --    print('hit pillar')
  --  end
--
  --end


  function physics:draw()
    --love.graphics.setColor(0,0,0,0)
    --love.graphics.polygon('fill', wall)
    
  end

  return self
end