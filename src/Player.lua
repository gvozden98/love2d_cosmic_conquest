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
    self.height = 48
    self.width = 48
    self.x = WINDOW_WIDTH / 2 - self.width / 2
    self.y = WINDOW_HEIGHT - 100
    self.dx = 300
    self.dy = 450

    self.shotX = 0
    self.bombs = {}
    self.explosion = Explosion(self.x, self.y, 2, 0.08)
    self.shooting = false
    self.collided = false
    --auto shooting
    self.fireRate = 1.5
    self.timer = 0
end

function Player:update(dt)
    self.firstAnimation:update(dt)
    self.explosion.x = self.x
    self.explosion.y = self.y
    if not self.collided then
        if love.keyboard.isDown('left') then
            if self.x <= self.width / 2 then
                self.x = self.width / 2
            else
                self.x = self.x - self.dx * dt
            end
        end
        if love.keyboard.isDown('right') then
            -- Dont know why i had to subtract another 1/2 of the width
            if self.x >= WINDOW_WIDTH - self.width - self.width / 2 then
                self.x = WINDOW_WIDTH - self.width - self.width / 2
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
    if not self.collided then
        self.firstAnimation:draw(self.thruster, self.x + 17, self.y + 38) --specific number to suite the ship specs
        love.graphics.draw(self.spritesheet, self.player1, self.x, self.y)
    else
        self.explosion:render()
    end

    if self.shooting == true then
        for index, bomb in ipairs(self.bombs) do
            if not self.collided then
                bomb:render()
            end
        end
    end
end

function Player:autoShoot(dt)
    -- self.timer = self.timer + dt
    -- if self.timer >= self.fireRate then
    --     self.shooting = true
    --     self.shotX = self.x
    --     table.insert(self.bombs, Bomb(self.shotX))
    --     self.timer = 0
    --     sounds['shoot']:setVolume(0.5)
    --     sounds['shoot']:play()
    -- end
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
