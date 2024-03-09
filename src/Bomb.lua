Bomb = class {}
--probably need to include player but maybe not
function Bomb:init(playerx)
    -- bomb probably needs to have a seperate class
    self.bomb = love.graphics.newImage("assets/sprites/newPlayerBomb.png")
    self.bombGrid = anim8.newGrid(16, 16, self.bomb:getWidth(), self.bomb:getHeight())
    self.frames = self.bombGrid(1, 1, 1, 2, 1, 3, 1, 4)
    self.bombAnimation = anim8.newAnimation(self.frames, 0.08)
    self.bombx = playerx + self.bomb:getWidth() / 2 + 7
    self.bomby = WINDOW_HEIGHT - 124 --why not playery?
    self.bombdy = 500
    self.remove = false
end

function Bomb:update(dt)
    self.bombAnimation:update(dt)
    self.bombdy = 500
    self.bomby = self.bomby - self.bombdy * dt
end

function Bomb:render()
    --love.graphics.draw(self.bomb, self.bombx, self.bomby)
    self.bombAnimation:draw(self.bomb, self.bombx, self.bomby)
end

-- function Bomb:reset()
--     self.bomby = WINDOW_HEIGHT - 124
--     self.bombdy = 0
-- end
