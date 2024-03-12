require '/src/EnemyBomb'
Enemy = class {}
local movementSpeed = 100
function Enemy:init(quad, x, y, bombSprite, speed, minInterval, maxInterval, shootingSpeed)
    self.enemySpritesheet = love.graphics.newImage("assets/sprites/enemy_spaceships_sheet.png")
    self.quad = quad
    self.width = 32
    self.height = 32
    self.x = x
    self.y = y
    self.speed = speed
    self.dx = speed
    self.dy = speed
    self.collided = false
    self.shotX = 0
    self.bombs = {}
    self.shooting = false
    self.bombSprite = bombSprite
    --shooting variables
    self.shootingSpeed = shootingSpeed
    self.timer = 0
    self.minInterval = minInterval
    self.maxInterval = maxInterval
    self.interval = love.math.random(self.minInterval, self.maxInterval)

    --movement
    self.moveTimer = 5
    self.moveLinearTimer = math.random(1, 10)
end

function Enemy:update(dt)
    self:move(dt)
end

function Enemy:render()
    if not self.collided then
        love.graphics.draw(self.enemySpritesheet, self.quad, self.x, self.y)
    end
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
-- function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
-- return self.x < bomb.bombx + 3 and
--     bomb.bombx < self.x + self.width and
--     self.y < bomb.bomby + self.height and
--     bomb.bomby < self.y + 3
-- end
function Enemy:collides()
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
            self.dead = true
            bomb.remove = true
        end
    end
end

function Enemy:shoot(dt)
    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.shooting = true
        self.shotX = self.x
        table.insert(allEnemyBombs, EnemyBomb(self.shotX, self.y, self.bombSprite,self.shootingSpeed))
        self.timer = 0
        sounds['enemy_shoot']:stop()
        sounds['enemy_shoot']:setVolume(0.5)
        sounds['enemy_shoot']:play()
    end
end

function Enemy:move(dt)
    print(self.speed)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.moveTimer = self.moveTimer + dt
    self.moveLinearTimer = self.moveLinearTimer + dt

    if self.x >= 600 - self.width - 5 then
        self.dx = self.dx * -1
        self:checkDy()
    end
    if self.x <= 0 then
        self.dx = self.dx * -1
        self:checkDy()
    end
    if self.y >= 500 then
        self.dy = self.dy * -1
        self:checkDx()
    end
    if self.y <= self.width then
        self.dy = self.dy * -1
        self:checkDx()
    end
    if self.moveTimer > 5 and (self.x >= 48 and self.x <= 600 - self.width - 64) then
        self.dx = self.dx * self:random()
        self.dy = self.dy * self:random()
        self.moveTimer = 0
    end
    if ((self.x > 100 and self.x < 500) and (self.y < 350 and self.y > 100)) and self.moveLinearTimer > 10 then
        local random = self:random()
        if random == 1 then
            self.dx = 0
            self:checkDy()
        else
            self.dy = 0
            self:checkDx()
        end
        self.moveLinearTimer = 0
    end
end

function Enemy:random()
    local x = math.random(-100, 100)
    if x == 0 then
        return 1
    elseif x < 0 then
        return -1
    elseif x > 0 then
        return 1
    end
end

function Enemy:checkDy()
    if self.dy < 0 then
        self.dy = -self.speed
    else
        self.dy = self.speed
    end
end

function Enemy:checkDx()
    if self.dx < 0 then
        self.dx = -self.speed
    else
        self.dx = self.speed
    end
end
