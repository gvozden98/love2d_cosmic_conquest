-- imports
_G.love = require("love")
require 'lib/class'
local push = require 'lib/push'
require "src/player"

-- constants
WINDOW_WIDTH = 600
WINDOW_HEIGHT = 800
local player = Player()
function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    
end

function love.update(dt)

    player:update(dt)
    player:shoot()
    love.keyboard.keysPressed = {}
    
end

function love.draw()
    player:render()
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
    --love.keyboard.isDown() cannot keep track of pressed keys in other classes besides main
end