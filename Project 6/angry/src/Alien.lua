--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Alien = Class{}

function Alien:init(world, type, x, y, userData)
    self.world = world
    self.type = type or 'square'

    self.body = love.physics.newBody(self.world,
            x or math.random(VIRTUAL_WIDTH), y or math.random(VIRTUAL_HEIGHT - 35),
            'dynamic')

    -- different shape and sprite based on type passed in
    if self.type == 'square' then
        self.shape = love.physics.newRectangleShape(35, 35)
        self.sprite = math.random(5)
    else
        self.shape = love.physics.newCircleShape(17.5)
        self.sprite = 9
    end

    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.fixture:setUserData(userData)

    -- used to keep track of despawning the Alien and flinging it
    self.launched = false

    self.canSplit = true
    self.siblings = {}
    end

function Alien:split()
    if not self.canSplit then
        return
    end

    self.canSplit = false
    local vx,vy = self.body:getLinearVelocity()

    self.siblings[1] = Alien(self.world, self.type, self.body:getX(), self.body:getY() + 10, 'Player')
    self.siblings[1].body:setLinearVelocity(vx, 2*vy)
    self.siblings[1].sprite = 10

    self.siblings[2] = Alien(self.world, self.type, self.body:getX(), self.body:getY() - 10, 'Player')
    self.siblings[2].body:setLinearVelocity(vx, vy/2)
    self.siblings[2].sprite = 7

    --[[self.siblings[1].fixture:setGroupIndex(-1)
    self.siblings[2].fixture:setGroupIndex(-1)]]

    --[[Timer.after(0.2, function()
        self.siblings[1].fixture:setGroupIndex(0)
        self.siblings[2].fixture:setGroupIndex(0)
    end)]]
end

function Alien:hasStopped()
    if #self.siblings == 2 then
        return self:isStopped(self) and self:isStopped(self.siblings[1]) and self:isStopped(self.siblings[2])
    else
        return self:isStopped(self)
    end
end

function Alien:isStopped()
    local xPos, yPos = self.body:getPosition()
    local xVel, yVel = self.body:getLinearVelocity()

    if xPos < 0 or (math.abs(xVel) + math.abs(yVel) < 1.5) then
        return true
    else
        return false
    end
end

function Alien:render()
    love.graphics.draw(gTextures['aliens'], gFrames['aliens'][self.sprite],
            math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(),
            1, 1, 17.5, 17.5)

    if #self.siblings == 2 then
        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][self.siblings[1].sprite],
                math.floor(self.siblings[1].body:getX()), math.floor(self.siblings[1].body:getY()), self.siblings[1].body:getAngle(),
                1, 1, 17.5, 17.5)

        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][self.siblings[2].sprite],
                math.floor(self.siblings[2].body:getX()), math.floor(self.siblings[2].body:getY()), self.siblings[2].body:getAngle(),
                1, 1, 17.5, 17.5)
    end


end