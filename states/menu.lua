menu = {}
function menu:init()
end

function menu:enter()

end

function menu:update(dt)

end

function menu:keyreleased(key, code)
    state.switch(game)
end

function menu:mousepressed(x, y, mbutton)
end

function menu:draw()
    local f = fontLight[24]
    love.graphics.setFont(f)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBackgroundColor(127, 127, 127)
    local text = "Music by Eric Matyas"
    love.graphics.print(text, love.graphics.getWidth()/2-f:getWidth(text)/2, love.graphics.getHeight()/2+125)
    
    local text = "< PRESS ANY KEY TO START >"
    love.graphics.print(text, love.graphics.getWidth()/2-f:getWidth(text)/2, love.graphics.getHeight()/2)
    
    local text = "Made by Nuthen and Ikroth"
    love.graphics.print(text, love.graphics.getWidth()/2-f:getWidth(text)/2, love.graphics.getHeight()/2+100)
    
end
