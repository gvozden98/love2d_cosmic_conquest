Explosion = class {}

function Explosion:init(x, y, animationNumber)
    self.explosion = love.graphics.newImage("assets/sprites/Explotion2.png")
    self.grid = anim8.newGrid(32, 32, self.explosion:getWidth(), self.explosion:getHeight())
    self.firstAnimation = anim8.newAnimation(self.grid('1-8', animationNumber), 0.08, 'pauseAtEnd')
    self.x = x
    self.y = y
    self.finished = false
    self.remove = false
end

function Explosion:update(dt)
    self.firstAnimation:update(dt)
end

function Explosion:render()
    self.firstAnimation:draw(self.explosion, self.x, self.y)
end
