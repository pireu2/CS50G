--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.visible = true
    self.isflag = self.texture == 'flag'
    self.flagframe = 0
    self.down = false
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

local timer = 0

function GameObject:update(dt)
    if self.texture == 'flag' then
        if self.down == false then
            timer = timer + dt
            if timer >= 0.5 then
                self.flagframe = (self.flagframe + 1) % 2
                timer = timer % 0.5
            end
        else
            self.flagframe = 2
        end
    end
end


function GameObject:render()
    if self.visible then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame + self.flagframe], self.x, self.y)
    end
end