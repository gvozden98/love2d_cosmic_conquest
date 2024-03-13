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
    self.immune = false
    self.immuneTimer = 1
    self.immuneOpacity = 0.4
    --auto shooting
    self.numberOfBombs = 1
    self.fireRate = 1.5
    self.timer = 0
end

function Player:update(dt)
    if self.immune then
        self.immuneTimer = self.immuneTimer - dt
        --print(self.immuneTimer)
    end
    self:manageImmune()
    self.firstAnimation:update(dt)
    self.explosion.x = self.x
    self.explosion.y = self.y
    if self.life == 0 then
        self.bombs = {}
        self.dead = true
    end
    if not self.dead then
        if love.keyboard.isDown('left') then
            if self.x <= self.width - 51 then
                self.x = self.width - 51
            else
                self.x = self.x - self.dx * dt
            end
        end
        if love.keyboard.isDown('right') then
            if self.x >= WINDOW_WIDTH - self.width - self.width + 51 then
                self.x = WINDOW_WIDTH - self.width - self.width + 51
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
        if self.immune then
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        self.firstAnimation:draw(self.thruster, self.x + 17, self.y + 38) --specific number to suite the ship specs
        love.graphics.draw(self.spritesheet, self.player1, self.x, self.y)
        love.graphics.setColor(1, 1, 1, 1)
    else
        self.explosion:render(1, 1)
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
    if self.dead then
        return
    end
    self.timer = self.timer + dt * 2
    if self.timer >= self.fireRate then
        self.shooting = true
        local x = 1;
        for i = 1, self.numberOfBombs, 1 do
            table.insert(self.bombs, Bomb(self.x - 8 * x, self.y + 3))
            x = x * -1
            if self.numberOfBombs == 3 then
                table.insert(self.bombs, Bomb(self.x, self.y - 3))
            end
        end
        self.timer = 0
        sounds['shoot']:setVolume(0.5)
        sounds['shoot']:play()
    end
    if not self.dead then

    end
end

function Player:shoot()
    -- self.shooting = true
    -- table.insert(self.bombs, Bomb(self.x, self.y))
    -- sounds['shoot']:stop()
    -- sounds['shoot']:setVolume(0.3)
    -- sounds['shoot']:play()
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
    if self.life > 0 and not self.immune then
        self.life = self.life - 1
        print("life " .. self.life)
    end
end

function Player:increaseShootingSpeed()
    if self.fireRate >= 0.4 then
        self.fireRate = self.fireRate - self.fireRate / 5
    end
end

function Player:increaseSpeed()
    self.dx = self.dx * 1.03
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

function Player:addBomb()
    if self.numberOfBombs < 3 then
        self.numberOfBombs = self.numberOfBombs + 1
        print(self.numberOfBombs .. "bombi")
    end
end

function Player:manageImmune()
    if self.immuneTimer <= 0 then
        self.immuneTimer = 1
        self.immune = false
    end
end
