BossRay = class {}

function BossRay:init()
    self.ray = love.graphics.newImage("assets/sprites/boss/boss_ray.png")
    self.gridRay = anim8.newGrid(36,36, self.ray:getWidth(), self.ray:getHeight())
    self.rayAnimation = anim8.newAnimation(self.gridRay('1-2', 1), 0.08,'pauseAtEnd')
end

function BossRay:update()
    self.rayAnimation:update(dt)
end

function BossRay:render()
    self.rayAnimation:draw(self.ray,self.x,self.y)
end