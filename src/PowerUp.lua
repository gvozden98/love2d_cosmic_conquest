PowerUp = class()

function PowerUp:init(x, y, type)
    self.lifeSprite = love.graphics.newImage("assets/sprites/lifePowerUp.png")
    self.powerUpspritesheet = love.graphics.newImage("assets/sprites/powerUp.png")
    self.powerUp1 = love.graphics.newQuad(0, 0, 32, 32, self.powerUpspritesheet:getDimensions())
    self.powerUp2 = love.graphics.newQuad(32, 0, 32, 32, self.powerUpspritesheet:getDimensions())
    self.type = type
    self.x = x
    self.y = y
    self.dy = 250
    self.collided = false
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    if not self.collided then
        if self.type == 1 then
            love.graphics.draw(self.lifeSprite, self.x, self.y)
        elseif self.type == 2 then
            love.graphics.draw(self.powerUpspritesheet, self.powerUp1, self.x, self.y)
        else
            love.graphics.draw(self.powerUpspritesheet, self.powerUp2, self.x, self.y)
        end
    end
end

function PowerUp:collidesWithPlayer(player)
    if player.x < self.x + self.lifeSprite:getWidth() - 3 and
        self.x < player.x + player.width and
        player.y < self.y + self.lifeSprite:getWidth() - 3 and
        self.y < player.y + player.height
    then
        self.collided = true
        if self.type == 1 then
            player:increaseLife()
        elseif self.type == 2 then
            player:increaseShootingSpeed()
            player:increaseSpeed()
        elseif self.type == 3 then
            player:addBomb()
        end
    end
    return true
end

function PowerUp:speedUp(dt)
    self.y = self.y + self.dy * dt
end
