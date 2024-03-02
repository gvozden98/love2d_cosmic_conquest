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

    --shooting variables
    self.timer = 0
    self.minInterval = 1
    self.maxInterval = 10
    self.interval = love.math.random(self.minInterval, self.maxInterval)
end

function Enemy:update(dt)
    for _, Bomb in ipairs(self.bombs) do
        Bomb:update(dt)
        if Bomb.bomby >= 820 then
            Bomb.remove = true
        end
    end

    --remove bomb if it has gone past the screen
    for index, Bomb in ipairs(self.bombs) do
        if Bomb.remove == true then
            table.remove(self.bombs, index)
        end
    end
end

function Enemy:render()
    if not self.collided then
        love.graphics.draw(self.enemySpritesheet, self.quad, self.x, self.y)
    end

    for index, bomb in ipairs(self.bombs) do
        bomb:render()
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
            --if collided then remove the bomb
            self.collided = true
            bomb.remove = true
        end
    end
end

function Enemy:collidesWithPlayer(player)
    for index, enemyBomb in pairs(self.bombs) do
        if player.x < enemyBomb.bombx + 3 and
            enemyBomb.bombx < player.x + player.width and
            player.y < enemyBomb.bomby + 3 and
            enemyBomb.bomby < player.y + player.height
        then
            --if collided then remove the bomb
            player.collided = true
            enemyBomb.remove = true
            player.collided = true
        end
    end
end

function Enemy:shoot(dt)
    self.timer = self.timer + dt
    if self.timer >= self.interval then
        print("Action performed!")

        self.shotX = self.x
        table.insert(self.bombs, EnemyBomb(self.shotX, self.y))
        self.timer = 0
    end
end
