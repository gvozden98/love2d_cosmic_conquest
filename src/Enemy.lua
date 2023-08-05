Enemy = class {}

function Enemy:init(quad, x, y)
    self.quad = quad
    self.width = 32
    self.height = 32
    self.x = x
    self.y = y
    self.collided = false
end

function Enemy:update(dt)

end

function Enemy:render()
    if not self.collided then
        love.graphics.draw(spritesheet, self.quad, self.x, self.y)
    end
end

function Enemy:collides(player)
    for index, bomb in ipairs(player.bombs) do
        if self.y + self.height >= bomb.bomby + 3 and bomb.bomby + 3 <= self.y + self.height then
            if self.x + self.width >= bomb.bombx + 3 and bomb.bombx + 3 <= self.x + self.width then
                print("hit")
                self.collided = true
                return true
            end
        else
            return false
        end
        --print(#player.bombs)
    end
end
