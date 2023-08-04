Player = class {}

function Player:init()
    self.spritesheet = love.graphics.newImage("assets/sprites/spaceships.png")
    self.player1 = love.graphics.newQuad(0, 0, 48, 48, self.spritesheet:getDimensions())
    self.player2 = love.graphics.newQuad(48, 0, 48, 48, self.spritesheet:getDimensions())
    self.player3 = love.graphics.newQuad(0, 48, 48, 48, self.spritesheet:getDimensions())
    self.player4 = love.graphics.newQuad(48, 48, 48, 48, self.spritesheet:getDimensions())
    self.height = 48
    self.width = 48
    self.x = WINDOW_WIDTH / 2 - self.width/2
    self.y = WINDOW_HEIGHT - 100
    self.dx = 300
end

function Player:update(dt)
    if love.keyboard.isDown('left') then
        if self.x <= self.width/2 then
            self.x= self.width/2
        else
            self.x = self.x - self.dx * dt
        end
    end
    if love.keyboard.isDown('right') then
        -- Dont know why i had to subtract another 1/2 of the width
        if self.x>=WINDOW_WIDTH-self.width- self.width/2 then
            self.x = WINDOW_WIDTH - self.width - self.width/2
        else
            self.x = self.x + self.dx * dt
        end
        
    end
end

function Player:render()
    -- can not get width of quad for some reason
    love.graphics.draw(self.spritesheet, self.player1, self.x, self.y)
end

function Player:shoot()
    if love.keyboard.wasPressed('space') then
        
    end
end
function Player:collides()

end
