EnemyBomb = class {}

function EnemyBomb:init(enemyX, enemyY)
    self.bomb = love.graphics.newImage("assets/sprites/bomb.png")
    self.bombdy = 300
    self.remove = false
    --[[    love.math.random() * coneAngle generates a random angle within the cone angle.
    - coneAngle / 2 shifts the range to the left by half of the cone angle, making the cone symmetric around the initial direction.
    + math.pi / 2 adjusts the range to start from 90 degrees (right).]]
    local coneAngle = math.pi / 4 -- Adjust the cone angle as needed
    self.angle = love.math.random() * coneAngle - coneAngle / 2 + math.pi / 2


    -- Set initial position based on the angle
    local initialX = math.cos(self.angle)
    local initialY = math.sin(self.angle)
    self.bombx = enemyX + initialX
    self.bomby = enemyY + initialY
end

function EnemyBomb:update(dt, shotX)
    --self.bombdy = 500
    --self.bomby = self.bomby + self.bombdy * dt

    local deltaX = math.cos(self.angle) * self.bombdy * dt
    local deltaY = math.sin(self.angle) * self.bombdy * dt

    self.bombx = self.bombx + deltaX
    self.bomby = self.bomby + deltaY
end

function EnemyBomb:render()
    love.graphics.draw(self.bomb, self.bombx, self.bomby)
end
