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
require "/src/Boss"
require "/src/PowerUp"
local levels = require "/src/Level"
local currentLevelData = levels[1]

local background = love.graphics.newImage("/assets/sprites/Space_Background_long2.png")
local backgroundY = -2200
local backgroundSpeed = 400

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 800
local currentLevel = 1
local gameState = ""
local transitionTimer = 0
_G.player = Player()
local enemies = {}
_G.allEnemyBombs = {}
local explosions = {}
local finish = false
local powerUps = {}
----------------------------music


function love.load()
    AllEnemyBombs:init()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    gameState = "start"
    LoadLevel(currentLevel)
    --fonts
    _G.titlefont = love.graphics.newFont('fonts/font.ttf', 34)
    _G.pressKeyFont = love.graphics.newFont('fonts/font.ttf', 20)
    --sounds
    _G.sounds = {
        ['boom'] = love.audio.newSource('sounds/boom.wav', 'static'),
        ['enemy_shoot'] = love.audio.newSource('sounds/enemyshoot.wav', 'static'),
        ['finish'] = love.audio.newSource('sounds/finish.wav', 'static'),
        ['player_dead'] = love.audio.newSource('sounds/playerdead.wav', 'static'),
        ['shoot'] = love.audio.newSource('sounds/shoot.wav', 'static'),
        ['transition'] = love.audio.newSource('sounds/transition.wav', 'static'),
        ['laser'] = love.audio.newSource('sounds/laser1.wav', 'static')
    }
    _G.music = {
        ['backgroundMusic'] = love.audio.newSource('sounds/music/background8bit.mp3'),
        ['bossMusic'] = love.audio.newSource('sounds/music/bossMusic.mp3')
    }

    music['backgroundMusic']:setVolume(0.3)
    music['backgroundMusic']:play()
end

function love.update(dt)
    if currentLevel > #levels - 1 then
        gameState = "finish"
        if finish == false then
            finishSound()
        end
    end
    --print(#enemies .. " " .. currentLevel)
    player:update(dt)
    AllEnemyBombs:update(dt)
    AllEnemyBombs:collidesWithPlayer(player)
    if gameState == "fight" or gameState == "dead" then
        --player:autoShoot(dt)
        for key, enemy in pairs(enemies) do
            enemy:collides()
            enemy:shoot(dt)
            enemy:update(dt)
            if enemy.collided == true then
                if currentLevelData.isBoss then
                    if enemy.dead then
                        table.remove(enemies, key)
                        table.insert(explosions, Boss(enemy.x, enemy.y, "", true))
                    end
                end
                if not currentLevelData.isBoss then
                    if math.random(1, 100) < 20 then
                        if math.random(-1, 1) < 0 then
                            table.insert(powerUps, PowerUp(enemy.x, enemy.y, true))
                        else
                            table.insert(powerUps, PowerUp(enemy.x, enemy.y, false))
                        end
                    end
                    table.remove(enemies, key)
                    table.insert(explosions, Explosion(enemy.x, enemy.y, 2, 0.08))
                end
            end
        end
    end

    if gameState == "transition" then
        transitionTimer = transitionTimer + dt
        sounds['transition']:setVolume(0.8)
        sounds['transition']:play()
        --move the background
        backgroundY = backgroundY + backgroundSpeed * dt
        if backgroundY > background:getHeight() then
            backgroundY = 0
        end
        --speed up the bombs and powerups
        for key, bomb in pairs(allEnemyBombs) do
            bomb.bombdy = 1000
        end
        for _, powerUp in pairs(powerUps) do
            powerUp.dy = 1000
        end
        --player:speedUp(dt)
        if transitionTimer > 2 then
            --player:reset()
            --print(transitionTimer)
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
    for key, powerUp in pairs(powerUps) do
        powerUp:update(dt)
        powerUp:collidesWithPlayer(player)

        if powerUp.collided == true then
            table.remove(powerUps, key)
        end
    end
    if player.dead then
        gameState = "dead"
    end
    --print(gameState)
    if backgroundY > -800 then
        print("aaaa")
        backgroundY = -2200
        background = love.graphics.newImage("/assets/sprites/Space_Background_long2.png")
    end
end

function love.draw()
    love.graphics.draw(background, 0, backgroundY)
    --love.graphics.draw(background, 0, backgroundY + background:getHeight())
    --love.graphics.draw(background, 0, -2200)

    player:render()



    if gameState == "fight" or gameState == "dead" then
        for key, enemy in pairs(enemies) do
            enemy:render()
        end
    end
    for key, explosion in pairs(explosions) do
        explosion:render()
    end
    for key, powerUp in pairs(powerUps) do
        powerUp:render()
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
    if gameState == "finish" then
        love.graphics.setFont(titlefont)
        love.graphics.printf('Congratulations', 0, 400, WINDOW_WIDTH, 'center')
        love.graphics.setFont(pressKeyFont)
        love.graphics.printf('Press Enter to restart', 0, 450, WINDOW_WIDTH, 'center')
    end
    if gameState == "transition" then
        love.graphics.setFont(titlefont)
        love.graphics.printf('Level ' .. currentLevel, 0, 400, WINDOW_WIDTH, 'center')
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

    --Shooting on click

    --if not player.shooting then
    if key == 'space' and not player.dead and gameState == "fight" then
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
            finish = false
            backgroundY = -2200
            gameState = "fight"
        end
    end
    if gameState == "finish" then
        if key == 'return' then
            levels[currentLevel].enemies.enemies = {}
            player = Player()
            currentLevel = 1
            _G.allEnemyBombs = {}
            LoadLevel(currentLevel)
            finish = false
            backgroundY = -2200
            gameState = "fight"
        end
    end
end

function LoadLevel(level)
    -- Load level data (enemy types, positions, etc.)
    -- Set up initial game state for the given level

    currentLevelData = levels[level]
    if not currentLevelData.isBoss then
        currentLevelData:populate()
    else
        currentLevelData:populateBoss()
    end

    enemies = currentLevelData.generatedEnemies

    --print(#currentLevelData.generatedEnemies)
end

function WinConditionMet()
    -- Define win conditions based on your game's rules
    -- For example, return true if all enemies are destroyed
    if #enemies == 0 then
        --print("all enemies are dead")
        return true
    else
        return false
    end
end

function finishSound()
    sounds['finish']:setVolume(0.5)
    sounds['finish']:play()
    finish = true
end
