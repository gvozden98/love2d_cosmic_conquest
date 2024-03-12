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
    print(#self.generatedEnemies)
    self.enemies:populateBoss()
    self.generatedEnemies = self.enemies.enemies
    print(#self.generatedEnemies)
end

return {
    Level(Enemies(1, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 100, 2, 6, 300), 32,
        1,
        false),
    Level(Enemies(2, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 110, 2, 5, 350), 32,
        2,
        false),
    Level(Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 125, 2, 4, 375), 32,
        3,
        false),
    Level(Enemies(4, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 150, 1, 3, 400), 32,
        4,
        false),
    Level(Enemies(5, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 175, 1, 2, 425), 32,
        3,
        false),
    Level(Enemies(6, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 200, 1, 2, 450), 32,
        3,
        false),
    Level(Enemies(7, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 250, 1, 2, 450), 32,
        3,
        false),
    Level(Enemies(8, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png", 275, 2, 6, 450), 32,
        4,
        false),
    Level(Enemies(1, true, "assets/sprites/boss/boss.png", "assets/sprites/bomb.png"), 128, 1, true),
    Level(Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png", "assets/sprites/bomb.png"), 32, 1, false),
    --Level(Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png"), 32, 1, false),


    -- Level(Enemies(4), 32, 3,false),
    -- Level(Enemies(5), 32, 4,false),

}
