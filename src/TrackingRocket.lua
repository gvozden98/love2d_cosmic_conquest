TrackingRocket = class {}

function TrackingRocket:init(x, y)
    self.x = x
    self.y = y
    self.dx = 150
    self.dy = 150
    self.deviation = 50
    self.timer = 0
    self.trackingRocketWidth = 32
    self.trackingRocketHeight = 32
    self.trackingRocket = love.graphics.newImage("assets/sprites/boss/trackingRocket.png")
    self.gridTrackingRocket = anim8.newGrid(self.trackingRocketWidth, self.trackingRocketHeight,
        self.trackingRocket:getWidth(),
        self.trackingRocket:getHeight())
    self.trackingRocketFrames = self.gridTrackingRocket(1, 1, 1, 2, 1, 3, 1, 4)
    self.trackingRocketAnimation = anim8.newAnimation(self.trackingRocketFrames, 0.2, 'pauseAtEnd')
    self.angle = math.atan(player.y - self.y, player.x - self.x)
    self.vx = 0
    self.vx = 0
    self.verticalComponent = 50 * math.sin(love.timer.getTime())
end

function TrackingRocket:update(dt)
    self.trackingRocketAnimation:update(dt)

    -- Calculate the angle between the rocket and the player
    self.angle = math.atan2(player.y - self.y, player.x - self.x)
    self.verticalComponent = 50 * math.sin(love.timer.getTime())
    -- Calculate the new velocity components
    self.vx = self.dx * math.cos(self.angle)
    self.vy = self.dx * math.sin(self.angle) + self.verticalComponent
    print(self.angle)
    -- Update the rocket's position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function TrackingRocket:render(dt)
    self.trackingRocketAnimation:draw(self.trackingRocket, self.x, self.y, self.angle)
end
