--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type='throwable',
        texture='tiles',
        frame = 109,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'down',
        states = {
            ['down'] = {
                frame = 109
            },
            ['up'] = {
                frame = 109
            }
        }
    },
    ['heal']={
        type='consumable',
        texture = 'hearts',
        frame = 3,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unused',
        states = {
            ['unused'] = {
            frame = 5
            },
            ['used'] = {
                frame = 5
            }
        }
    }
}