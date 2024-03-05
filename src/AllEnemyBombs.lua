AllEnemyBombs = class {}

function AllEnemyBombs:init()
end

function AllEnemyBombs:update(dt)
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
            player.collided = true
            enemyBomb.remove = true
            player.collided = true
            sounds['player_dead']:setVolume(0.5)
            sounds['player_dead']:play()
        end
    end
end
