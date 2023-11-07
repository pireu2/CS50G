--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerThrowState = Class{__includes = BaseState}

function PlayerThrowState:init(player, dungeon)
    self.player = player
    self.entity = player
    self.dungeon = dungeon

    self.entity:changeAnimation('idle-'..self.entity.direction)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end


function PlayerThrowState:enter()
    self.projectile = Projectile({
        ['x'] = self.player.x,
        ['y'] = self.player.y - 4,
        ['width'] = 16,
        ['height'] = 16,
        ['direction'] = self.player.direction
    }, self.dungeon)
end

function PlayerThrowState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
            love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        if self.projectile.hit then
            self.entity:changeState('walk')
        end
    end
    self.projectile:update(dt)
end

function PlayerThrowState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
    self.projectile:render()
end