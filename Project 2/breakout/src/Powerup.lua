Powerup = Class{}

function Powerup:init()
    self.width = 16
    self.height = 16
    self.x = math.random(1,VIRTUAL_WIDTH)
    self.y = 0
    self.dy = POWERUP_SPEED
    self.active = false
end

function Powerup:update(dt)
    if self.active then 
        self.y = self.y + self.dy*dt
    end
end

function Powerup:reset()
    self.x = math.random(10,VIRTUAL_WIDTH - 10)
    self.y = 0
end

function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.active then
        if self.x > target.x + target.width or target.x > self.x + self.width then
            return false
        end

        -- then check to see if the bottom edge of either is higher than the top
        -- edge of the other
        if self.y > target.y + target.height or target.y > self.y + self.height then
            return false
        end 

    -- if the above aren't true, they're overlapping
        return true
    else
        return false
    end
    
end

function Powerup:render()
    if self.active then
        love.graphics.draw(gTextures['main'], gFrames['powerup'][1], self.x, self.y)
    end
end



