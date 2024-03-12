require "/src/Enemies"
require "/src/Enemy"
require "/src/Boss"

Level = class {}

function Level:init(enemies, startingXWhereEnemiesSpawn, numberOfRowsOfEnemies, isBoss)
    self.enemies = enemies
    self.generatedEnemies = enemies.enemies
    self.startingXWhereEnemiesSpawn = startingXWhereEnemiesSpawn
    self.numberOfRowsOfEnemies = numberOfRowsOfEnemies

    self.isBoss = isBoss
end

function Level:populate()
    self.enemies:getSprite() -- need to modify populate function to choose a sprite
    self.enemies:populate(self.startingXWhereEnemiesSpawn, self.numberOfRowsOfEnemies)
end

function Level:populateBoss()
    --print(#self.generatedEnemies)
    self.enemies:populateBoss()
    self.generatedEnemies = self.enemies.enemies
    --print(#self.generatedEnemies)
    --print("boss")
    music['backgroundMusic']:stop()
    music['backgroundMusic']:setLooping(false)

    music['bossMusic']:setVolume(0.4)
    music['bossMusic']:play()
    music['bossMusic']:setLooping(true)
end

return {
    Level(
        Enemies(1, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/orangeBomb.png", 100, 2, 6,
            300),
        32,
        1,
        false),
    Level(
        Enemies(2, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/frostBomb.png", 110, 2, 5,
            350), 32,
        2,
        false),
    Level(
        Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/frostBall.png", 125, 2, 4,
            375), 32,
        3,
        false),
    Level(
        Enemies(4, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/purpleBomb.png", 150, 2, 4,
            400), 32,
        4,
        false),
    Level(
        Enemies(5, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/darkRedBomb.png", 175, 2, 4,
            425), 32,
        3,
        false),
    Level(
        Enemies(6, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/greenBomb.png", 200, 2, 4,
            450), 32,
        3,
        false),
    Level(
        Enemies(7, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/greenMovingBomb.png", 210, 1,
            3, 450), 32,
        3,
        false),
    Level(
        Enemies(8, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bombs/purpleMovingBomb.png", 220,
            1, 3, 450), 32,
        4,
        false),
    Level(Enemies(1, true, "assets/sprites/boss/boss.png", "assets/sprites/bomb.png"), 128, 1, true),
    Level(Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png"), 32, 1, false),


}
