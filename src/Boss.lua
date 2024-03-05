require '/src/EnemyBomb'
Boss = class {}

function Boss:init(x, y, sprite,collided)
    self.enemySpritesheet = love.graphics.newImage("assets/sprites/boss/boss.png")
    self.width = 128
    self.height = 128
    self.x = x
    self.y = y
    self.collided = collided
    self.shotX = 0
    self.bombs = {}
    self.shooting = false
    self.dx = 150
    --self.dy = 50
    --shooting variables
    self.timer = 0
    self.minInterval = 2
    self.maxInterval = 6
    self.interval = love.math.random(self.minInterval, self.maxInterval)

    --destruction
    self.destruction = love.graphics.newImage("assets/sprites/boss/boss_dead.png")
    self.grid = anim8.newGrid(128,128, self.destruction:getWidth(), self.destruction:getHeight())
    self.firstAnimation = anim8.newAnimation(self.grid('1-13', 1), 0.08,"pauseAtEnd")

    --moving
    self.movingTimer = 0
    self.minMovingIterval = 1
    self.maxMovingInterval = 2
    self.movingInterval = 1.5
    self.leftOrRight = -1
end

function Boss:update(dt)
    self.firstAnimation:update(dt)
    self.x=self.x+self.dx*dt*self.leftOrRight
    self:move(dt)
end

function Boss:render()
    if self.collided then
        self.firstAnimation:draw(self.destruction, self.x, self.y)
    end
    
    if not self.collided then
        love.graphics.draw(self.enemySpritesheet, self.x, self.y)
    end
end

function Boss:collides(player)
    for index, bomb in ipairs(player.bombs) do
        if self.x < bomb.bombx + 3 and
            bomb.bombx < self.x + self.width and
            self.y < bomb.bomby + 3 and
            bomb.bomby < self.y + self.height
        then
            sounds['boom']:stop()
            sounds['boom']:setVolume(0.4)
            sounds['boom']:play()
            self.collided = true
            bomb.remove = true
        end
    end
end

function Boss:shoot(dt)
    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.shooting = true
        self.shotX = self.x+64
        table.insert(allEnemyBombs, EnemyBomb(self.shotX, self.y+128))
        self.timer = 0
        sounds['enemy_shoot']:stop()
        sounds['enemy_shoot']:setVolume(0.5)
        sounds['enemy_shoot']:play()
    end
end

function Boss:move(dt)
    self.movingTimer = self.movingTimer + dt
    if self.x<=16 then
        self.leftOrRight = 1
        self.movingTimer=0
    end
    if self.x>=500 then
        self.leftOrRight = -1
        self.movingTimer=0
    end
    --print(self.movingTimer .. " " .. self.movingInterval)
    print(self.x)
    if self.movingTimer >= self.movingInterval then
        self.leftOrRight = math.random(-1,1)
        self.movingTimer=0;
    end

 
end
