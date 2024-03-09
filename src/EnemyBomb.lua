EnemyBomb = class {}
--local bomb = "bomb.png"
function EnemyBomb:init(enemyX, enemyY, bombSprite)
    self.bomb = love.graphics.newImage(bombSprite)
    self.bombdy = 300
    self.remove = false
    self.type = type or 1
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

function EnemyBomb:update(dt)
    if self.bomby >= 820 then
        self.remove = true
    end
    local deltaX = math.cos(self.angle) * self.bombdy * dt
    local deltaY = math.sin(self.angle) * self.bombdy * dt

    self.bombx = self.bombx + deltaX
    self.bomby = self.bomby + deltaY
end

function EnemyBomb:render()
    if not self.remove then
        love.graphics.draw(self.bomb, self.bombx, self.bomby)
    end
end

function EnemyBomb:collidesWithPlayer(player)
    if player.x < self.bombx + 3 and
        self.bombx < player.x + player.width and
        player.y < self.bomby + 3 and
        self.bomby < player.y + player.height
    then
        --if collided then remove the bomb
        player.collided = true
        self.remove = true
    end
end
