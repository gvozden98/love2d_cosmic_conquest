--require "src/Explosion"
TrackingRocket = class {}

function TrackingRocket:init(x, y)
    self.x = x
    self.y = y
    self.dx = 350
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
    self.trackingRocketAnimation = anim8.newAnimation(self.trackingRocketFrames, 0.3, 'pauseAtEnd')
    self.angle = math.atan(player.y - self.y, player.x - self.x)
    self.vx = 0
    self.vx = 0
    self.verticalComponent = 50 * math.sin(love.timer.getTime())
    self.collided = false
    self.explosion = Explosion(-50, -50, 10, 0.03)
end

function TrackingRocket:update(dt)
    self.explosion:update(dt)
    if not self.collided then
        self.trackingRocketAnimation:update(dt)
        self:collidesWithPlayer()
        -- Calculate the angle between the rocket and the player
        if not self.rocketCloseEnough then
            self.angle = math.atan2(player.y - self.y, player.x - self.x)
        end

        self.verticalComponent = 50 * math.sin(love.timer.getTime())
        -- Calculate the new velocity components
        self.vx = self.dx * math.cos(self.angle)
        self.vy = self.dx * math.sin(self.angle) + self.verticalComponent
        if self:getDistanceFromPlayer() < 35 then
            self.rocketCloseEnough = true
            self.x = self.x + self.vx * dt
            self.y = self.y + self.dx * dt
        else
            self.x = self.x + self.vx * dt
            self.y = self.y + self.vy * dt
        end
    end

    -- Update the rocket's position
    -- self.x = self.x + self.vx * dt
    -- self.y = self.y + self.vy * dt
end

function TrackingRocket:render()
    self.explosion:render(2, 2)
    if not self.collided then
        self.trackingRocketAnimation:draw(self.trackingRocket, self.x, self.y, self.angle - math.pi / 2) --why - math.pi/2
    end
end

function TrackingRocket:getDistanceFromPlayer()
    return player.y - self.y
end

function TrackingRocket:collidesWithPlayer()
    if player.x < self.x + 16 and
        self.x < player.x + player.width and
        player.y < self.y + 16 and
        self.y < player.y + player.height
    then
        --if collided then remove the bomb
        if not player.dead and not player.immune then
            if player.life > 1 then
                self.explosion = Explosion(player.x - 8, player.y - 8, 1, 0.03)
                sounds['boom']:stop()
                sounds['boom']:setVolume(0.5)
                sounds['boom']:play()
            else
                sounds['player_dead']:setVolume(0.5)
                sounds['player_dead']:play()
            end
            self.collided = true
            player.collided = true
            player:decreaseLife()
            player.immune = true
        end
    end
end
