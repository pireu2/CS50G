--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(params, dungeon)
    self.originX = params.x
    self. originY = params.y
    self.x = params.x
    self.y = params.y
    self.width = params.width
    self.height = params.height
    self.direction = params.direction
    self.dungeon = dungeon
    self.hit = false

    self.dx = 0
    self.dy = 0

    if self.direction == 'up' then
        self.dy = -50
    elseif self.direction == 'down' then
        self.dy = 50
    elseif self.direction == 'left' then
        self.dx = -50
    elseif self.direction == 'right' then
        self.dx = 50
    end

end

function Projectile:update(dt)
    if self.direction == 'up' then
        if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height then
            self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height
            self.hit = true
        end
    elseif self.direction == 'down' then
        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
                + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.y + self.height >= bottomEdge then
            self.y = bottomEdge - self.height
            self.hit = true
        end

    elseif self.direction == 'left' then
        if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
            self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.hit = true
        end
    elseif self.direction == 'right' then
        if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
            self.hit = true
        end
    end


    if not self.hit then
        self.x = self.x + dt * self.dx
        self.y = self.y + dt * self.dy

        for k, entity in pairs(self.dungeon.currentRoom.entities) do
            if entity:collides(self) and entity.type == 'enemy' then
                entity:damage(1)
                self.hit = true
            end
        end
    end

    if math.abs(self.x - self.originX) > 4 * TILE_SIZE or math.abs(self.y - self.originY) > 4 * TILE_SIZE then
        self.hit = true
    end
end

function Projectile:render()
    if not self.hit then
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][109], math.floor(self.x), math.floor(self.y))
    end
end