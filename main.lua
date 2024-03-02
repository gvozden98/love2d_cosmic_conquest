--[[
    TODO: Enemies get their projectiles destroyed when they are destroyed, that needs fixing

]]
--[[
    Every single sprite and animation should be watched seperately, and all the same ones should be in a single table
]]

-- imports
_G.love = require("love")
_G.anim8 = require 'lib.anim8.anim8'
require 'lib/class'
local push = require 'lib/push'
require "/src/Player"
require "/src/Enemies"
require "/src/Enemy"
require "/src/Explosion"



-- constants
WINDOW_WIDTH = 600
WINDOW_HEIGHT = 800
local player = Player()
local newEnemies = Enemies()
newEnemies:getSprite()
newEnemies:Populate(32, 4)
local enemies = newEnemies.enemies
local explosions = {}
local playerExplosion = Explosion(player.x, player.y, 2)

function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    --check collision with the enemies

    -- if player.collided == true then
    --     playerExplosion = Explosion(player.x, player.y, 2)
    -- end
    player:update(dt)
    for key, enemy in pairs(enemies) do
        enemy:collides(player)
        enemy:collidesWithPlayer(player)
        enemy:update(dt)
        enemy:shoot(dt)
        if enemy.collided == true then
            table.remove(enemies, key)
            table.insert(explosions, Explosion(enemy.x, enemy.y, 2))
        end
    end
    --explode the ships if they have been hit
    for key, explosion in pairs(explosions) do
        explosion:update(dt)
    end
    -- if player.collided == true then
    --     playerExplosion:update(dt)
    -- end
end

function love.draw()
    player:render()
    for key, enemy in pairs(enemies) do
        enemy:render()
    end
    for key, explosion in pairs(explosions) do
        explosion:render()
    end

    -- if player.collided then
    --     playerExplosion:render()
    -- end
end

--[[adding a function to the keyboard table to check if keyboard was pressed,
    if we define love.keyboard outside of main it will overwrite the  function so it has to be done this way]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    --keep track of pressed key, altering love defined tables
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
    --if not player.shooting then
    if key == 'space' and not player.collided then
        player:shoot()
    end
    --end

    --love.keyboard.isDown() cannot keep track of pressed keys in other classes besides main
end
