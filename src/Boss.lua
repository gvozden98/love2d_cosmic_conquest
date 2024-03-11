require '/src/EnemyBomb'
require '/src/Explosion'
require '/src/TrackingRocket'
Boss = class()


function Boss:init(x, y, sprite, dead, bombSprite, player)
    self.player = player
    self.enemySpritesheet = love.graphics.newImage("assets/sprites/boss/boss.png")
    self.width = 128
    self.height = 128
    self.x = x
    self.y = y
    self.collided = false
    self.shotX = 0
    self.bombs = {}
    self.shooting = false
    self.dx = 150
    self.dy = 100
    self.life = 25
    self.dead = dead
    self.explosions = {}

    --destruction
    self.destruction = love.graphics.newImage("assets/sprites/boss/boss_dead.png")
    self.gridDestruction = anim8.newGrid(128, 128, self.destruction:getWidth(), self.destruction:getHeight())
    self.destructionAnimation = anim8.newAnimation(self.gridDestruction('1-13', 1), 0.08, "pauseAtEnd")

    --engine
    self.engine = love.graphics.newImage("assets/sprites/boss/boss_engine.png")
    self.gridEngine = anim8.newGrid(128, 128, self.engine:getWidth(), self.engine:getHeight())
    self.engineAnimation = anim8.newAnimation(self.gridEngine('1-8', 1), 0.08)

    --------Weapons---------------


    --------Bomb variables
    self.timer = 0
    self.minInterval = 0.3
    self.maxInterval = 0.5
    self.interval = 0.15
    self.bombSprite = bombSprite

    --------Laser
    self.laserOffsetX = 33
    self.laserOffsetY = 64
    self.laserX = self.x + self.laserOffsetX
    self.laserY = self.y + self.laserOffsetY
    self.laserHeight = 712
    self.laserWidth = 61
    self.laserAnimationTimer = 0.5 --perfect time for laser animation
    self.laserTimer = 0
    self.minLaserInterval = 4
    self.maxLaserInterval = 8
    self.shootingLaser = false
    self.laserInterval = 5
    self.laser = love.graphics.newImage("assets/sprites/boss/MegaLaserSheetLong.png")
    self.gridLaser = anim8.newGrid(self.laserWidth, self.laserHeight, self.laser:getWidth(), self.laser:getHeight())
    self.laserFrames = self.gridLaser(1, '1-4', 1, '4-1')
    --{ ['1-3'] = 0.05, ['4-5'] = 0.2, ['6-8'] = 0.05 } frames 1-3 and 6-8 will go on for 0.05s while 4 and 5 will go on for 0.2s
    self.laserAnimation = anim8.newAnimation(self.laserFrames,
        { ['1-3'] = 0.20, ['4-5'] = self.laserAnimationTimer, ['6-8'] = 0.10 })

    --------Tracking Bomb
    self.trackingRockets = {}
    self.trackingRocketAnimationTimer = 0.5 --perfect time for laser animation
    self.trackingRocketTimer = 0
    self.minTrackingRocketInterval = 1
    self.maxTrackingRocketInterval = 2
    self.shootingTrackingRocket = false
    self.trackingRocketInterval = 5
    self.trackingRocketWidth = 32
    self.trackingRocketHeight = 32
    -- self.trackingRocket = love.graphics.newImage("assets/sprites/boss/trackingRocket.png")
    -- self.gridTrackingRocket = anim8.newGrid(self.trackingRocketWidth, self.trackingRocketHeight,
    --     self.trackingRocket:getWidth(),
    --     self.trackingRocket:getHeight())
    -- self.trackingRocketFrames = self.gridTrackingRocket(1, 1, 1, 2, 1, 3, 1, 4)
    -- self.trackingRocketAnimation = anim8.newAnimation(self.trackingRocketFrames, 0.08, 'pauseAtEnd')

    --moving
    self.movingTimer = 0
    self.minMovingIterval = 1
    self.maxMovingInterval = 2
    self.movingInterval = 1.5
    self.leftOrRight = -1
    self.downOrUp = -1
end

function Boss:update(dt)
    self:laserPosition()
    self.destructionAnimation:update(dt)
    self.engineAnimation:update(dt)
    self.laserAnimation:update(dt)

    for k, explosion in pairs(self.explosions) do
        explosion:update(dt)
    end
    if not self.dead then
        self.x = self.x + self.dx * dt * self.leftOrRight
        self.y = self.y + self.dy * dt * self.downOrUp
        self:move(dt)
        self:shootLaser(dt)
        self:shootTrackingRocket(dt)
        self:laserCollidesWithPlayer()
    end
    --print(self.trackingRocket.dx)
    for k, rocket in pairs(self.trackingRockets) do
        rocket:update(dt)
    end
end

function Boss:render()
    if self.dead then
        self.destructionAnimation:draw(self.destruction, self.x, self.y)
    end

    if not self.dead then
        self.engineAnimation:draw(self.engine, self.x, self.y)
        if self.shootingLaser then
            --self.rayAnimation:draw(self.ray, self.x, self.y)
            self.laserAnimation:draw(self.laser, self.x + self.laserOffsetX, self.y + self.laserOffsetY)
        end
        if self.shootingTrackingRocket then
            --self.trackingRocketAnimation:draw(self.trackingRocket, self.x + 128, self.y + 64)
            for k, rocket in pairs(self.trackingRockets) do
                rocket:render()
            end
        end

        love.graphics.draw(self.enemySpritesheet, self.x, self.y)
        for k, explosion in pairs(self.explosions) do
            explosion:render()
        end
    end
end

--the sprite is not the width of the boss but a little wider so i had to adjust,done crudely, can be done a lot better
function Boss:collides()
    for index, bomb in ipairs(player.bombs) do
        if self.x + 20 < bomb.bombx + 3 and
            bomb.bombx < self.x + 20 + self.width - 68 and
            self.y - 20 < bomb.bomby + 3 and
            bomb.bomby < self.y - 20 + self.height - 20
        then
            sounds['boom']:stop()
            sounds['boom']:setVolume(0.4)
            sounds['boom']:play()
            self.collided = true
            bomb.remove = true
            self.life = self.life - 1
            table.insert(self.explosions, Explosion(bomb.bombx, bomb.bomby, 10, 0.03))
            print(self.life .. " " .. "player hit the boss")
            if self.life <= 0 then
                self.dead = true
            end
        end
    end
end

function Boss:laserCollidesWithPlayer()
    if player.x < self.laserX + self.laserWidth and
        self.laserX < player.x + player.width and
        player.y < self.laserY + self.laserHeight and
        self.laserY < player.y + player.height and self.shootingLaser
    then
        player.collided = true
        -- sounds['player_dead']:setVolume(0.5)
        -- sounds['player_dead']:play()
        if not player.dead then
            player:decreaseLife()
        end
    end
end

function Boss:shoot(dt)
    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.shooting = true
        self.shotX = self.x + 64
        table.insert(allEnemyBombs, EnemyBomb(self.shotX, self.y + self.width, self.bombSprite))
        self.timer = 0
        sounds['enemy_shoot']:stop()
        sounds['enemy_shoot']:setVolume(0.5)
        sounds['enemy_shoot']:play()
        self.interval = love.math.random(1, 50) / 100
        print(self.interval)
    end
end

function Boss:shootLaser(dt)
    self.laserTimer = self.laserTimer + dt
    --self.shootingLaser = false;
    --self.laserAnimation:pause()
    --print(self.laserTimer .. " " .. self.laserInterval)
    if self.shootingLaser and self.laserTimer > self.laserAnimationTimer + 0.15 then
        --self.laserAnimation:pause()
        self.shootingLaser = false
    end
    if self.laserTimer >= self.laserInterval then
        self.laserInterval = love.math.random(self.minLaserInterval, self.maxLaserInterval)
        --self.laserAnimation:resume()
        self.shootingLaser = true
        self.laserTimer = 0
        sounds['laser']:stop()
        sounds['laser']:setVolume(0.8)
        sounds['laser']:play()
    end
end

function Boss:shootTrackingRocket(dt)
    self.trackingRocketTimer = self.trackingRocketTimer + dt
    if self.trackingRocketTimer >= self.trackingRocketInterval then
        self.shootingTrackingRocket = true
        --self.shotX = self.x + 64
        --self.trackingRocket = TrackingRocket(self.x, self.y)
        table.insert(self.trackingRockets, TrackingRocket(self.x, self.y))
        self.trackingRocketTimer = 0
        sounds['enemy_shoot']:stop()
        sounds['enemy_shoot']:setVolume(0.5)
        sounds['enemy_shoot']:play()
        self.interval = love.math.random(self.minInterval, self.maxInterval)
    end
end

function Boss:move(dt)
    self.movingTimer = self.movingTimer + dt
    if self.x <= 16 then
        self.leftOrRight = 1
        self.movingTimer = 0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    if self.x >= 500 then
        self.leftOrRight = -1
        self.movingTimer = 0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    if self.y <= 16 then
        self.downOrUp = 1
        self.movingTimer = 0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    if self.y >= 500 then
        self.downOrUp = -1
        self.movingTimer = 0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    --print(self.movingTimer .. " " .. self.movingInterval)
    --print(self.x)
    if self.movingTimer >= self.movingInterval then
        self.leftOrRight = math.random(-1, 1)
        self.downOrUp = math.random(-1, 1)
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
        self.movingTimer = 0;
    end
end

function Boss:randomSpeed()
    return math.random(50, 150)
end

function Boss:laserPosition()
    self.laserX = self.x + self.laserOffsetX
    self.laserY = self.y + self.laserOffsetY
end
