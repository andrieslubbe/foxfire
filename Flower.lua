
flower = {}
function flower.new(x, y)
  local self = {}
  self.__index = self
  local x,y = x,y

  local animflower = anim8.newAnimation(gflower('1-5',1), 0.2, 'pauseAtEnd')
  
  function self.update(dt)
    animflower:update(dt)
  end
  function self.draw()
    love.graphics.setColor(0.043, 1.000, 0.902,0.4)
    animflower:draw(spriteflower, x, y)
  end

  return self
end