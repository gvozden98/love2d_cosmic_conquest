require "/src/Enemies"
require "/src/Enemy"

Level = class {}

function Level:init(enemies, startingXWhereEnemiesSpawn, numberOfRowsOfEnemies, sprite)
    self.enemies = enemies
    self.generatedEnemies = {}
    --self.explosions = explosions or {}
    --self.sprite = sprite --need to modify this to take the right sprite
    self.startingXWhereEnemiesSpawn = startingXWhereEnemiesSpawn
    self.numberOfRowsOfEnemies = numberOfRowsOfEnemies
end

function Level:populate()
    self.enemies:getSprite()
    self.enemies:populate(self.startingXWhereEnemiesSpawn, self.numberOfRowsOfEnemies)
    self.generatedEnemies = self.enemies.enemies
end

return {
    Level(Enemies(), 32, 1),
    Level(Enemies(), 32, 2),
    Level(Enemies(), 32, 3)

}
