require '/src/Bomb'
require '/src/Explosion'

Player = class {}

function Player:init()
    self.spritesheet = love.graphics.newImage("assets/sprites/spaceships.png")
    --thruster
    self.thruster = love.graphics.newImage("assets/sprites/thruster-Sheet2.png")
    self.grid = anim8.newGrid(16, 16, self.thruster:getWidth(), self.thruster:getHeight())
    self.firstAnimation = anim8.newAnimation(self.grid('1-5', 1), 0.08)
    --
    self.player1 = love.graphics.newQuad(0, 0, 48, 48, self.spritesheet:getDimensions())
    self.player2 = love.graphics.newQuad(48, 0, 48, 48, self.spritesheet:getDimensions())
    self.player3 = love.graphics.newQuad(0, 48, 48, 48, self.spritesheet:getDimensions())
    self.player4 = love.graphics.newQuad(48, 48, 48, 48, self.spritesheet:getDimensions())

    self.lifeSpritsheet = love.graphics.newImage("assets/sprites/health.png")
    self.health1 = love.graphics.newQuad(0, 0, 96, 32, self.lifeSpritsheet:getDimensions())
    self.health2 = love.graphics.newQuad(96, 0, 96, 32, self.lifeSpritsheet:getDimensions())
    self.health3 = love.graphics.newQuad(192, 0, 96, 32, self.lifeSpritsheet:getDimensions())
    self.health4 = love.graphics.newQuad(288, 0, 96, 32, self.lifeSpritsheet:getDimensions())
    self.health5 = love.graphics.newQuad(380, 0, 96, 32, self.lifeSpritsheet:getDimensions())
    self.height = 48
    self.width = 48
    self.x = WINDOW_WIDTH / 2 - self.width / 2
    self.y = WINDOW_HEIGHT - 100
    self.dx = 300
    self.dy = 450
    self.life = 4

    self.shotX = 0
    self.bombs = {}
    self.explosion = Explosion(self.x, self.y, 2, 0.08)
    self.shooting = false
    self.collided = false
    self.dead = false
    --auto shooting
    self.fireRate = 1.5
    self.timer = 0
end

function Player:update(dt)
    self.firstAnimation:update(dt)
    self.explosion.x = self.x
    self.explosion.y = self.y
    if self.life == 0 then
        self.dead = true
    end
    if not self.dead then
        if love.keyboard.isDown('left') then
            if self.x <= self.width - 43 then
                self.x = self.width - 43
            else
                self.x = self.x - self.dx * dt
            end
        end
        if love.keyboard.isDown('right') then
            if self.x >= WINDOW_WIDTH - self.width - self.width + 43 then
                self.x = WINDOW_WIDTH - self.width - self.width + 43
            else
                self.x = self.x + self.dx * dt
            end
        end
        if self.shooting == true then
            for _, Bomb in ipairs(self.bombs) do
                Bomb:update(dt)
                if Bomb.bomby <= -16 then
                    Bomb.remove = true
                    --print(#self.bombs)
                end
            end
        end
        -- remove bomb if it has gone past the screen
        for index, Bomb in ipairs(self.bombs) do
            if Bomb.remove == true then
                table.remove(self.bombs, index)
            end
        end
    else
        --track the explosion to be at the place of the ship
        self.explosion:update(dt)
    end
end

function Player:render()
    -- can not get width of quad for some reason
    self:getHealth()
    if not self.dead then
        self.firstAnimation:draw(self.thruster, self.x + 17, self.y + 38) --specific number to suite the ship specs
        love.graphics.draw(self.spritesheet, self.player1, self.x, self.y)
    else
        self.explosion:render()
    end

    if self.shooting == true then
        for index, bomb in ipairs(self.bombs) do
            if not self.dead then
                bomb:render()
            end
        end
    end
end

function Player:autoShoot(dt)
    if not self.dead then
        self.timer = self.timer + dt * 2
        if self.timer >= self.fireRate then
            print(self.fireRate)
            self.shooting = true
            self.shotX = self.x
            table.insert(self.bombs, Bomb(self.shotX))
            self.timer = 0
            sounds['shoot']:setVolume(0.5)
            sounds['shoot']:play()
        end
    end
end

function Player:shoot()
    self.shooting = true
    self.shotX = self.x
    table.insert(self.bombs, Bomb(self.shotX))
    sounds['shoot']:stop()
    sounds['shoot']:setVolume(0.3)
    sounds['shoot']:play()
end

function Player:speedUp(dt)
    self.y = self.y - self.dy * dt
end

function Player:reset()
    self.x = WINDOW_WIDTH / 2 - self.width / 2
    self.y = WINDOW_HEIGHT - 100
end

function Player:increaseLife()
    if self.life < 4 then
        self.life = self.life + 1
        print("life " .. self.life)
    end
end

function Player:decreaseLife()
    self.life = self.life - 1
    print("life " .. self.life)
end

function Player:increaseShootingSpeed()
    if self.fireRate >= 0.5 then
        self.fireRate = self.fireRate - self.fireRate / 5
    end
end

function Player:getHealth()
    if self.life == 4 then
        return love.graphics.draw(self.lifeSpritsheet, self.health1, 16, WINDOW_HEIGHT - 48)
    end
    if self.life == 3 then
        return love.graphics.draw(self.lifeSpritsheet, self.health2, 16, WINDOW_HEIGHT - 48)
    end
    if self.life == 2 then
        return love.graphics.draw(self.lifeSpritsheet, self.health3, 16, WINDOW_HEIGHT - 48)
    end
    if self.life == 1 then
        return love.graphics.draw(self.lifeSpritsheet, self.health4, 16, WINDOW_HEIGHT - 48)
    end
    if self.life == 0 then
        return love.graphics.draw(self.lifeSpritsheet, self.health5, 16, WINDOW_HEIGHT - 48)
    end
end
