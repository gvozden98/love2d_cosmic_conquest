Enemy = class{}

function Enemy:init()
    self.spritesheet = love.graphics.newImage("assets/sprites/spaceships.png")
    self.player1 = love.graphics.newQuad(0, 0, 48, 48, self.spritesheet:getDimensions())
    self.player2 = love.graphics.newQuad(48, 0, 48, 48, self.spritesheet:getDimensions())
    self.player3 = love.graphics.newQuad(0, 48, 48, 48, self.spritesheet:getDimensions())
    self.player4 = love.graphics.newQuad(48, 48, 48, 48, self.spritesheet:getDimensions())
end