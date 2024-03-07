Bomb = class {}
--probably need to include player but maybe not
function Bomb:init(playerx, playery)
    -- bomb probably needs to have a seperate class
    self.bomb = love.graphics.newImage("assets/sprites/bomb.png")
    self.bombx = playerx + self.bomb:getWidth() / 2 + 7
    self.bomby = WINDOW_HEIGHT - 124 --why not playery?
    self.bombdy = 500
    self.remove = false
end

function Bomb:update(dt, shotX)
    self.bombdy = 500
    self.bomby = self.bomby - self.bombdy * dt
end

function Bomb:render()
    love.graphics.draw(self.bomb, self.bombx, self.bomby)
end

-- function Bomb:reset()
--     self.bomby = WINDOW_HEIGHT - 124
--     self.bombdy = 0
-- end
