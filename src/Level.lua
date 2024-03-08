require "/src/Enemies"
require "/src/Enemy"
require "/src/Boss"

Level = class {}

function Level:init(enemies, startingXWhereEnemiesSpawn, numberOfRowsOfEnemies, isBoss)
    self.enemies = enemies
    self.generatedEnemies = {}
    self.startingXWhereEnemiesSpawn = startingXWhereEnemiesSpawn
    self.numberOfRowsOfEnemies = numberOfRowsOfEnemies
    self.isBoss = isBoss
end

function Level:populate()
    print(#self.generatedEnemies)
    self.enemies:getSprite() -- need to modify populate function to choose a sprite
    self.enemies:populate(self.startingXWhereEnemiesSpawn, self.numberOfRowsOfEnemies)
    self.generatedEnemies = self.enemies.enemies
    print(#self.generatedEnemies)
end

function Level:populateBoss()
    print(#self.generatedEnemies)
    self.enemies:populateBoss()
    self.generatedEnemies = self.enemies.enemies
    print(#self.generatedEnemies)
end

return {
    Level(Enemies(1, false, "assets/sprites/enemy_spaceships_sheet.png"), 32, 1, false),
    Level(Enemies(2, false, "assets/sprites/enemy_spaceships_sheet.png"), 32, 1, false),
    Level(Enemies(4, false, "assets/sprites/enemy_spaceships_sheet.png"), 32, 1, false),
    Level(Enemies(1, true, "assets/sprites/boss/boss.png"), 128, 1, true),
    Level(Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png"), 32, 1, false),
    --Level(Enemies(3, false, "assets/sprites/enemy_spaceships_sheet.png"), 32, 1, false),


    -- Level(Enemies(4), 32, 3,false),
    -- Level(Enemies(5), 32, 4,false),

}
