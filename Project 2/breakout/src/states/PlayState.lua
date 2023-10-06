--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}
--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
    self.powerup = Powerup()
    self.recoverPoints = 5000
    self.powerupPoints = params.powerupPoints
    self.bonusBalls = {}

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)
    self.powerup:update(dt)

    if self.ball:collides(self.paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        collisionPaddle(self.ball, self.paddle)
    end

    for k, bonus in pairs(self.bonusBalls) do
        if bonus:collides(self.paddle) then
            collisionPaddle(bonus, self.paddle)
        end
    end

        
    if self.powerup:collides(self.paddle) then
        if self.powerup.active then
            ball1 = spawnBall(self.powerup)
            ball2 = spawnBall(self.powerup)
            table.insert(self.bonusBalls, ball1)
            table.insert(self.bonusBalls, ball2)
            self.powerup.active = false
            self.powerup:reset()
        end
    end
    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do

        -- only check collision if we're in play
        if brick.inPlay and self.ball:collides(brick) then

            -- add to score
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            -- trigger the brick's hit function, which removes it from play
            brick:hit()

            -- if we have enough points, recover a point of health
            recoverHealth(self.score, self.recoverPoints, self.health)

            -- go to our victory screen if there are no more bricks left
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball,
                    recoverPoints = self.recoverPoints,
                    powerupPoints = self.powerupPoints
                })
            end

            --
            collisionBricks(self.ball, brick)

            -- only allow colliding with one brick, for corners
            break
        end
    end


    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            for i, bonus in pairs(self.bonusBalls) do
                if bonus:collides(brick) then
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()

                    -- if we have enough points, recover a point of health
                    recoverHealth(self.score, self.recoverPoints, self.health)

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = self.ball,
                            recoverPoints = self.recoverPoints,
                            powerupPoints = self.powerupPoints
                        })
                    end

                    --
                    collisionBricks(bonus, brick)
                end
            end
        end
    end


    -- if ball goes below bounds, revert to serve state and decrease health
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints,
                powerupPoints = self.powerupPoints
            })
        end
    end

    if self.powerup.y >= VIRTUAL_HEIGHT then
        self.powerup.active = false
        self.powerup:reset()
    end

    if self.score > self.powerupPoints then
        self.powerup.active = true
        self.powerupPoints = self.powerupPoints + math.random(1000)
    end

    for k, bonus in pairs(self.bonusBalls) do
        bonus:update(dt)
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    for k, bonus in pairs(self.bonusBalls) do
        bonus:render()
    end

    self.paddle:render()
    self.ball:render()
    self.powerup:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end


function collisionBricks(ball, brick)
    -- collision code for bricks
    --
    -- we check to see if the opposite side of our velocity is outside of the brick;
    -- if it is, we trigger a collision on that side. else we're within the X + width of
    -- the brick and should check to see if the top or bottom edge is outside of the brick,
    -- colliding on the top or bottom accordingly 
    --

    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
    -- so that flush corner hits register as Y flips, not X flips
    if ball.x + 2 < brick.x and ball.dx > 0 then
        
        -- flip x velocity and reset position outside of brick
        ball.dx = -ball.dx
        ball.x = brick.x - 8
    
    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
    -- so that flush corner hits register as Y flips, not X flips
    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
        
        -- flip x velocity and reset position outside of brick
        ball.dx = -ball.dx
        ball.x = brick.x + 32
    
    -- top edge if no X collisions, always check
    elseif ball.y < brick.y then
        
        -- flip y velocity and reset position outside of brick
        ball.dy = -ball.dy
        ball.y = brick.y - 8
    
    -- bottom edge if no X collisions or top collision, last possibility
    else
        
        -- flip y velocity and reset position outside of brick
        ball.dy = -ball.dy
        ball.y = brick.y + 16
    end

    -- slightly scale the y velocity to speed up the game, capping at +- 150
    if math.abs(ball.dy) < 150 then
        ball.dy = ball.dy * 1.02
    end
end



function recoverHealth(score, recoverPoints, health)
    if score > recoverPoints then
        -- can't go above 3 health
        health = math.min(3, health + 1)

        -- multiply recover points by 2
        recoverPoints = recoverPoints + math.min(100000, recoverPoints * 2)

        -- play recover sound effect
        gSounds['recover']:play()
    end
end

function collisionPaddle(ball, paddle)
    ball.y = paddle.y - 8
    ball.dy = -ball.dy

    
    -- tweak angle of bounce based on where it hits the paddle
    

    -- if we hit the paddle on its left side while moving left...
    if ball.x < paddle.x + (paddle.width / 2) and paddle.dx < 0 then
        ball.dx = -50 + -(8 * (paddle.x + paddle.width / 2 - ball.x))
    
    -- else if we hit the paddle on its right side while moving right...
    elseif ball.x > paddle.x + (paddle.width / 2) and paddle.dx > 0 then
        ball.dx = 50 + (8 * math.abs(paddle.x + paddle.width / 2 - ball.x))
    end

    gSounds['paddle-hit']:play()
end

function spawnBall(powerup)
    bonus = Ball()
    bonus.skin = math.random(7)
    bonus.x = powerup.x
    bonus.y = powerup.y
    bonus.dx = math.random(-200, 200)
    bonus.dy = math.random(-50, -60)

    return bonus
end