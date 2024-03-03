require '/src/Enemy'
Enemies = class {}
function Enemies:init()
    self.enemySpritesheet = love.graphics.newImage("assets/sprites/enemy_spaceships_sheet.png")
    self.enemies = {}
    self.quads = {}
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
function Enemies:populate(startX, rows)
    while rows > 0 do
        for i = startX, 600, 64 do
            table.insert(self.enemies, Enemy(self.quads[1], i, rows * 64))
        end
        rows = rows - 1
    end
end
