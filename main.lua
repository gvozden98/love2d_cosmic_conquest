--[[
    TODO: Need to implement the win state and add more levels

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
require "/src/EnemyBomb"
require "/src/AllEnemyBombs"
require "/src/Level"
local levels = require "/src/Level"
local background = love.graphics.newImage("/assets/sprites/Space Background_800x600.png")

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 800
local currentLevel = 1
local gameState = ""
local transitionTimer = 0
local player = Player()
local enemies = {}
_G.allEnemyBombs = {}
local explosions = {}
local removedEnemyBombs = {}


function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    gameState = "start"
    LoadLevel(currentLevel)
    _G.titlefont = love.graphics.newFont('fonts/font.ttf', 34)
    _G.pressKeyFont = love.graphics.newFont('fonts/font.ttf', 20)
end

function love.update(dt)
    --check collision with the enemies

    player:update(dt)
    AllEnemyBombs:update(dt)
    AllEnemyBombs:collidesWithPlayer(player)
    if gameState == "fight" then
        for key, enemy in pairs(enemies) do
            enemy:collides(player)
            enemy:shoot(dt)
            if enemy.collided == true then
                table.remove(enemies, key)
                table.insert(explosions, Explosion(enemy.x, enemy.y, 2))
            end
            if enemy.collided and enemy.shooting then
                for key, removedEnemyBomb in pairs(removedEnemyBombs) do
                    print("bomb added " .. " " .. removedEnemyBomb.bombx .. " " .. key)
                end
            end
        end
        --explode the ships if they have been hit
    end

    if gameState == "transition" then
        transitionTimer = transitionTimer + dt
        print(transitionTimer)
        if transitionTimer > 3 then
            print(transitionTimer)
            gameState = "fight"
            transitionTimer = 0
        end
    end

    if WinConditionMet() == true then
        print(currentLevel)
        currentLevel = currentLevel + 1
        LoadLevel(currentLevel)
        gameState = "transition"
    end
    for key, explosion in pairs(explosions) do
        explosion:update(dt)
    end
    if player.collided then
        gameState = "dead"
    end
    --print(gameState)
end

function love.draw()
    love.graphics.draw(background)
    player:render()
    if gameState == "fight" or gameState == "dead" then
        for key, enemy in pairs(enemies) do
            enemy:render()
        end
    end
    for key, explosion in pairs(explosions) do
        explosion:render()
    end
    AllEnemyBombs:render()

    if gameState == "start" then
        love.graphics.setFont(titlefont)
        love.graphics.printf('Cosmic Conquest', 0, 400, WINDOW_WIDTH, 'center')
        love.graphics.setFont(pressKeyFont)
        love.graphics.printf('Press Enter to start', 0, 450, WINDOW_WIDTH, 'center')
    end
    if gameState == "dead" then
        love.graphics.setFont(titlefont)
        love.graphics.printf('Game Over', 0, 400, WINDOW_WIDTH, 'center')
        love.graphics.setFont(pressKeyFont)
        love.graphics.printf('Press Enter to restart', 0, 450, WINDOW_WIDTH, 'center')
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
    if key == 'space' and not player.collided then
        player:shoot()
    end
    --end

    --love.keyboard.isDown() cannot keep track of pressed keys in other classes besides main
    if gameState == "start" then
        if key == 'return' then
            gameState = "fight"
        end
    end
    if gameState == "dead" then
        if key == 'return' then
            levels[currentLevel].enemies.enemies = {}
            player = Player()
            currentLevel = 1
            _G.allEnemyBombs = {}
            LoadLevel(currentLevel)
            gameState = "fight"
        end
    end
end

function LoadLevel(level)
    -- Load level data (enemy types, positions, etc.)
    -- Set up initial game state for the given level
    local currentLevelData = levels[level]
    currentLevelData:populate()
    enemies = currentLevelData.generatedEnemies
    --print(#currentLevelData.generatedEnemies)
end

function WinConditionMet()
    -- Define win conditions based on your game's rules
    -- For example, return true if all enemies are destroyed
    if #enemies == 0 then
        print("all enemies are dead")
        return true
    else
        return false
    end
end
