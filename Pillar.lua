pillar = {}

function pillar.new(x, y, width, height)
  local self = {}
  self.__index = self
  local width,height = width,height


  local wall = {
    x-width/2,y-height/2,
    x+width/2,y-height/2,
    x+width/2,y+height/2,
    x-width/2,y+height/2,
  }
  local light = lighter:addPolygon(wall)
  local physics = bf.Collider.new(world, 'Rectangle', x, y, width, height)
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
  physics:setType('static')
  setmetatable(self, physics)


  function physics:draw()
    --love.graphics.setColor(0,0,0,0)
    --love.graphics.polygon('fill', wall)
  end

  return self
end