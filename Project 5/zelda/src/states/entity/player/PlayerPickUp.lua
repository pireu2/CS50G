
--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPickUp = Class{__includes = EntityIdleState}

function PlayerPickUp:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.entity = player
    -- render offset for spaced character sprite (negated in render function of state)
    self.player.offsetY = 5
    self.player.offsetX = 0
    self.animationTimer = 0

    self.player:changeAnimation('pick-up')
end

function PlayerPickUp:update(dt)
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer > 0.3 then
        self.animationTimer = 0
        for k,object in pairs(self.dungeon.currentRoom.objects) do
            if object.type == 'throwable' then
                object.state = 'up'
                object.solid = false
                object.onCollide = function() return end
            end
        end
        self.player:changeState('pot-idle')

    end

end

function PlayerSwingSwordState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

end