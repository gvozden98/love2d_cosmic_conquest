require '/src/EnemyBomb'
Enemy = class {}

function Enemy:init(quad, x, y)
    self.enemySpritesheet = love.graphics.newImage("assets/sprites/enemy_spaceships_sheet.png")
    self.quad = quad
    self.width = 32
    self.height = 32
    self.x = x
    self.y = y
    self.collided = false
    self.shotX = 0
    self.bombs = {}
    self.shooting = false

    --shooting variables
    self.timer = 0
    self.minInterval = 2
    self.maxInterval = 6
    self.interval = love.math.random(self.minInterval, self.maxInterval)
end

function Enemy:update(dt)

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
function Enemy:collides(player)
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

function Enemy:shoot(dt)
    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.shooting = true
        self.shotX = self.x
        table.insert(allEnemyBombs, EnemyBomb(self.shotX, self.y))
        self.timer = 0
        sounds['enemy_shoot']:stop()
        sounds['enemy_shoot']:setVolume(0.5)
        sounds['enemy_shoot']:play()
    end
end


