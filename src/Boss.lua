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
    self.shootingRay = false
    self.dx = 150
    self.dy = 100
    --shooting variables
    self.timer = 0
    self.minInterval = 0.5
    self.maxInterval = 1
    self.interval = love.math.random(self.minInterval, self.maxInterval)

    --destruction
    self.destruction = love.graphics.newImage("assets/sprites/boss/boss_dead.png")
    self.gridDestruction = anim8.newGrid(128,128, self.destruction:getWidth(), self.destruction:getHeight())
    self.destructionAnimation = anim8.newAnimation(self.gridDestruction('1-13', 1), 0.08,"pauseAtEnd")

    --engine
    self.engine = love.graphics.newImage("assets/sprites/boss/boss_engine.png")
    self.gridEngine = anim8.newGrid(128,128, self.engine:getWidth(), self.engine:getHeight())
    self.engineAnimation = anim8.newAnimation(self.gridEngine('1-8', 1), 0.08)

    --weapons
    self.ray = love.graphics.newImage("assets/sprites/boss/boss_ray.png")
    self.gridRay = anim8.newGrid(36,36, self.ray:getWidth(), self.ray:getHeight())
    self.rayAnimation = anim8.newAnimation(self.gridRay('1-2', 1), 0.08,'pauseAtEnd')

    --moving
    self.movingTimer = 0
    self.minMovingIterval = 1
    self.maxMovingInterval = 2
    self.movingInterval = 1.5
    self.leftOrRight = -1
    self.downOrUp = -1
end

function Boss:update(dt)
    self.destructionAnimation:update(dt)
    self.engineAnimation:update(dt)
    self.rayAnimation:update(dt)
    self.x=self.x+self.dx*dt*self.leftOrRight
    self.y=self.y+self.dy*dt*self.downOrUp
    self:move(dt)
    self:shootRay(dt)
end

function Boss:render()
    if self.collided then
        self.destructionAnimation:draw(self.destruction, self.x, self.y)
    end
    
    if not self.collided then
        love.graphics.draw(self.enemySpritesheet, self.x, self.y)
        self.engineAnimation:draw(self.engine,self.x,self.y)
        if self.shootingRay then
        self.rayAnimation:draw(self.ray,self.x,self.y)
        end
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

function Boss:shootRay(dt)
    self.timer = self.timer + dt
    self.shootingRay=false;
    if self.timer >= self.interval then
        self.shootingRay = true
        self.timer = 0
        --table.insert(allEnemyBombs, EnemyBomb(self.x, self.y))
    end
end

function Boss:move(dt)
    self.movingTimer = self.movingTimer + dt
    if self.x<=16 then
        self.leftOrRight = 1
        self.movingTimer=0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    if self.x>=500 then
        self.leftOrRight = -1
        self.movingTimer=0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    if self.y<=16 then
        self.downOrUp = 1
        self.movingTimer=0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    if self.y>=500 then
        self.downOrUp = -1
        self.movingTimer=0
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
    end
    --print(self.movingTimer .. " " .. self.movingInterval)
    --print(self.x)
    if self.movingTimer >= self.movingInterval then
        self.leftOrRight = math.random(-1,1)
        self.downOrUp = math.random(-1,1)
        self.dx = self:randomSpeed()
        self.dy = self:randomSpeed()
        self.movingTimer=0;
    end

 
end

function Boss:randomSpeed()
    return math.random(50,150)
end
