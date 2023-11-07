--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdlePot = Class{__includes = BaseState}

function PlayerIdlePot:init(player, dungeon)
    self.player = player
    self.entity = player
    self.dungeon = dungeon

    self.entity:changeAnimation('idle-pot-'..self.entity.direction)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdlePot:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
            love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk')
    end
    if love.keyboard.wasPressed('space') then
        print('throw')
        self.entity:changeState('throw')
    end
end

function PlayerIdlePot:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))


    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][109],
            math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY)-4)

end