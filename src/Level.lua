require "/src/Enemies"
require "/src/Enemy"

Level = class {}

function Level:init(enemies, startingXWhereEnemiesSpawn, numberOfRowsOfEnemies, sprite)
    self.enemies = enemies
    self.generatedEnemies = {}
    self.startingXWhereEnemiesSpawn = startingXWhereEnemiesSpawn
    self.numberOfRowsOfEnemies = numberOfRowsOfEnemies
end

function Level:populate()
    print(#self.generatedEnemies)
    self.enemies:getSprite() -- need to modify populate function to choose a sprite
    self.enemies:populate(self.startingXWhereEnemiesSpawn, self.numberOfRowsOfEnemies)
    self.generatedEnemies = self.enemies.enemies
    print(#self.generatedEnemies)
end

return {
    Level(Enemies(), 32, 1),
    Level(Enemies(), 32, 1),
    Level(Enemies(), 32, 1),
    Level(Enemies(), 32, 1),

}
