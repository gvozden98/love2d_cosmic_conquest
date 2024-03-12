require '/src/Enemy'
Enemies = class {}
function Enemies:init(type, isBoss, sprite, bombSprite)
    self.enemySpritesheet = love.graphics.newImage(sprite)
    self.enemies = {}
    self.quads = {}
    self.type = type or 1
    self.isBoss = isBoss
    self.bombSprite = bombSprite
    self.player = player
end

function Enemies:getSprite()
    for y = 0, 1 do
        for x = 0, 3 do
            self.quads[#self.quads + 1] = love.graphics.newQuad(x * 32, y * 32, 32, 32,
                self.enemySpritesheet:getDimensions())
        end
    end
end

--populate a level with rows of enemies, starting from startX pixels from the left and separated by 64 pixels from the top
function Enemies:populate(startX, rows, speed, minInterval, maxInterval)
    while rows > 0 do
        for i = startX, 600, 64 do
            table.insert(self.enemies,
                Enemy(self.quads[self.type], i, rows * 64, self.bombSprite, speed, minInterval, maxInterval))
        end
        rows = rows - 1
    end
end

function Enemies:populateBoss()
    table.insert(self.enemies, Boss(236, 64, self.enemySpritesheet, false, "assets/sprites/bomb.png", self.player))
end
