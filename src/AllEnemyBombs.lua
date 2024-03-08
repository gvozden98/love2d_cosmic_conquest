require "/src/Explosion"

AllEnemyBombs = class {}

function AllEnemyBombs:init()
    self.explosion = Explosion(-30, -30, 1, 0.03)
end

function AllEnemyBombs:update(dt)
    self.explosion:update(dt)
    for _, Bomb in ipairs(allEnemyBombs) do
        Bomb:update(dt)
        if Bomb.bomby >= 820 then
            Bomb.remove = true
        end
    end

    --remove bomb if it has gone past the screen
    for index, Bomb in ipairs(allEnemyBombs) do
        if Bomb.remove == true then
            table.remove(allEnemyBombs, index)
        end
    end
end

function AllEnemyBombs:render()
    self.explosion:render()
    for index, bomb in ipairs(allEnemyBombs) do
        bomb:render()
    end
end

function AllEnemyBombs:collidesWithPlayer(player)
    for index, enemyBomb in pairs(allEnemyBombs) do
        if player.x < enemyBomb.bombx + 3 and
            enemyBomb.bombx < player.x + player.width and
            player.y < enemyBomb.bomby + 3 and
            enemyBomb.bomby < player.y + player.height
        then
            --if collided then remove the bomb
            if not player.dead then
                if player.life > 1 then
                    self.explosion = Explosion(player.x + 8, player.y + 8, 1, 0.03)
                    sounds['boom']:stop()
                    sounds['boom']:setVolume(0.5)
                    sounds['boom']:play()
                else
                    sounds['player_dead']:setVolume(0.5)
                    sounds['player_dead']:play()
                end
                player.collided = true
                player:decreaseLife()
                enemyBomb.remove = true
            end
        end
    end
end
