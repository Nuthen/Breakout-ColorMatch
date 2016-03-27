Class = require 'libs.middleclass'
Flux = require 'libs.flux'
state = require 'libs.state'
bump = require 'libs.bump'
camera = require 'libs.camera'
vector = require 'libs.vector'
signal = require 'libs.signal'

-- entities
require 'objects.Brick'
require 'objects.Paddle'
require 'objects.Ball'
require 'objects.StaticObject'
require 'objects.fx.particle'
require 'objects.sound.sound'

-- gamestates
require 'states.game'

function love.load()
    _font = 'assets/font/OpenSans-Regular.ttf'
    _fontBold = 'assets/font/OpenSans-Bold.ttf'
    _fontLight = 'assets/font/OpenSans-Light.ttf'

    font = setmetatable({}, {
        __index = function(t,k)
            local f = love.graphics.newFont(_font, k)
            rawset(t, k, f)
            return f
        end 
    })

    fontBold = setmetatable({}, {
        __index = function(t,k)
            local f = love.graphics.newFont(_fontBold, k)
            rawset(t, k, f)
            return f
        end
    })

    fontLight = setmetatable({}, {
        __index = function(t,k)
            local f = love.graphics.newFont(_fontLight, k)
            rawset(t, k, f)
            return f
        end 
    })

    love.window.setIcon(love.image.newImageData('assets/img/icon.png'))
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(font[14])

    state.registerEvents()
    state.switch(game)

    math.randomseed(os.time()/10)

    -- Sound is instantiated before the game because it observes things beyond the game scope
    --soundManager = Sound:new()

    --if not love.filesystem.exists(options.file) then
    --    options:save(options:getDefaultConfig())
    --end

    --options:load()
end

function love.keypressed(key, code)

end

function love.mousepressed(x, y, mbutton)
    
end

function love.textinput(text)

end

function love.resize(w, h)

end

function love.update(dt)
    
end

function love.draw()

end
