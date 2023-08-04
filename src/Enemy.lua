Enemy = class {}

function Enemy:init()
    self.spritesheet = love.graphics.newImage("assets/sprites/enemy_spaceships_sheet.png")
    self.quads = {}
    for y = 0, 1 do
        for x = 0, 3 do
            self.quads[#self.quads + 1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, self.spritesheet:getDimensions())
        end
    end
    self.width = 32
    self.height = 32
    self.x = 0
    self.y = 0
end

function Enemy:update(dt)

end

function Enemy:render(spriteIndex, x, y)
    love.graphics.draw(self.spritesheet, self.quads[spriteIndex], x, y)
end

function Enemy:collides(player)
    for index, bomb in ipairs(player.bombs) do
        if self.y + self.height >= bomb.bomby + 3 and bomb.bomby + 3 <= self.y + self.height then
            if self.x + self.width >= bomb.bombx + 3 and bomb.bombx + 3 <= self.x + self.width then
                print("hit")
                return true
            end
        else
            return false
        end
        --print(#player.bombs)
    end
end
