--[[
    TODO: Enemies should all be separated, sprites should be loaded once, not every time i initialize an object, state machine needs to be made and levels should be added
    If enemies to the left are shot, all of them dissapear, most likely need to change the collides method
]]

-- imports
_G.love = require("love")
require 'lib/class'
local push = require 'lib/push'
require "src/Player"
require "src/Enemy"

-- constants
WINDOW_WIDTH = 600
WINDOW_HEIGHT = 800
local player = Player()
_G.spritesheet = love.graphics.newImage("assets/sprites/enemy_spaceships_sheet.png")
local quads = {}
for y = 0, 1 do
    for x = 0, 3 do
        quads[#quads + 1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, spritesheet:getDimensions())
    end
end
local enemies = {}


function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    for i = 32, 600, 64 do
        table.insert(enemies, Enemy(quads[1], i, 64))
    end
end

function love.update(dt)
    player:update(dt)
    --print(#enemies)
    for _, enemie in pairs(enemies) do
        if enemie:collides(player) == true then
            enemie.collided = true
        end
    end
    for key, enemie in ipairs(enemies) do
        if enemie.collided == true then
            table.remove(enemies, key)
        end
    end
end

function love.draw()
    player:render()


    for key, enemie in pairs(enemies) do
        --print(enemie.x .. " " .. enemie.y)
        enemie:render()
    end
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
    if key == 'space' then
        player:shoot()
    end
    --end

    --love.keyboard.isDown() cannot keep track of pressed keys in other classes besides main
end
