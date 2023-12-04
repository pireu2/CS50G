--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LeveUpMenuState = Class{__includes = BaseState}

function LeveUpMenuState:init(battleState, levels, increases)
    self.battleState = battleState
    
    self.battleMenu = Menu {
        width = 200,
        height = 200,
        x = VIRTUAL_WIDTH/2 - 100,
        y = VIRTUAL_HEIGHT/2 - 100,
        selectable = false,
        items = {
            {
                text = 'Level up!'
            },
            {
                text = 'HP: ' .. tostring(levels.HP) .. ' + ' .. tostring(increases.HPIncrease) .. ' = ' .. tostring(levels.HP + increases.HPIncrease)
            },
            {
                text = "Attach: " .. tostring(levels.attack) .. " + " .. tostring(increases.attackIncrease) .. " = " .. tostring(levels.attack + increases.attackIncrease)
            },
            {
                text = "Defense: " .. tostring(levels.defense) .. " + " .. tostring(increases.defenseIncrease) .. " = " .. tostring(levels.defense + increases.defenseIncrease)
            },
            {
                text = "Speed: " .. tostring(levels.speed) .. " + " .. tostring(increases.speedIncrease) .. " = " .. tostring(levels.speed + increases.speedIncrease)
            }
        }
    }
end

function LeveUpMenuState:update(dt)
    self.battleMenu:update(dt)
end

function LeveUpMenuState:render()
    self.battleMenu:render()
end