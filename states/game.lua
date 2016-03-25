game = {}

objects = {}
function game:add(obj)
    table.insert(objects, obj)
    self.world:add(obj, obj.position.x, obj.position.y, obj.width, obj.height)
    return obj
end

function game:remove(obj)
    for i, o in pairs(objects) do
        if o == obj then
            table.remove(objects, i)
            break
        end
    end
    self.world:remove(obj)
end

function game:moveScreen(dir) -- takes string of top, bottom, left, right
    local x, y, display = love.window.getPosition( )

    local dx, dy = 0, 0
    local accel = 10

    if dir == 'top'    then dy = -accel end
    if dir == 'bottom' then dy =  accel end
    if dir == 'left'   then dx = -accel end
    if dir == 'right'  then dx =  accel end

    self.windowAcceldx = self.windowAcceldx + dx
    self.windowAcceldy = self.windowAcceldy + dy

    love.window.setPosition( x + dx, y + dy, display )
end

function game:updateScreenMove(dt)
    local x, y, display = love.window.getPosition( )
    local desktopWidth, desktopHeight = love.window.getDesktopDimensions( display )
    local width, height = love.graphics.getDimensions( )

    local dx, dy = 0, 0
    self.windowVeldx = self.windowVeldx + self.windowAcceldx*dt
    self.windowVeldy = self.windowVeldy + self.windowAcceldy*dt

    dx = dx + self.windowVeldx
    dy = dy + self.windowVeldy

    dx = dx * dt
    dy = dy * dt

    -- move back towards the middle of the screen
    --dx = dx + (windowWidth/2 - width/2 - x)*.01
    --dy = dy + (windowHeight/2 - height/2 - y)*.01

    local dir = math.atan2((y - (desktopHeight/2 - height/2)), (x - (desktopWidth/2 - width/2)))
    local centerdx = math.cos(dir) * -.5
    local centerdy = math.sin(dir) * -.5

    local tol = .1
    if math.abs(centerdx) < tol then centerdx = 0 end
    if math.abs(centerdy) < tol then centerdy = 0 end

    dx = dx + centerdx
    dy = dy + centerdy

    --if math.abs(dx) < tol then dx = 0 end
    --if math.abs(dy) < tol then dy = 0 end

    love.window.setPosition( x + dx, y + dy, display )

    local damping = .9
    self.windowAcceldx = self.windowAcceldx * damping
    self.windowAcceldy = self.windowAcceldy * damping

    -- cut of vel if below tol
    if math.abs(self.windowVeldx) < tol then self.windowVeldx = 0 end
    if math.abs(self.windowVeldy) < tol then self.windowVeldy = 0 end

    if math.abs(self.windowAcceldx) < tol then self.windowAcceldx = 0 end
    if math.abs(self.windowAcceldy) < tol then self.windowAcceldy = 0 end
end


function game:isValidHit(colorType)
    return colorType == self.targetColor
end

function game:enter()
    self.windowAcceldx = 0
    self.windowAcceldy = 0

    self.windowVeldx = 0
    self.windowVeldy = 0

    self.world = bump.newWorld()

    -- Create the outer bounds area
    local wallSize = 20
    -- bottom wall
    local wall = self:add(StaticObject:new(0, love.graphics.getHeight()-wallSize, love.graphics.getWidth(), wallSize))
    -- top wall
    local wall = self:add(StaticObject:new(0, 0, love.graphics.getWidth(), wallSize))
    -- left wall
    local wall = self:add(StaticObject:new(0, 0, wallSize, love.graphics.getHeight())) 
    -- right wall
    local wall = self:add(StaticObject:new(love.graphics.getWidth()-wallSize, 0, wallSize, love.graphics.getHeight()))

    -- gameWidth and gameHeight is screen size minus the padding area
    local gameWidth = love.graphics.getWidth() - 64
    local gameHeight = love.graphics.getHeight() - 32

    local rows = math.floor(gameWidth / 40) - 1
    local columns = 6
    local xoff = (love.graphics.getWidth() - rows*40)/2
    local yoff = 80

    local activeColors = 3

    local colours = {}
    colours[1] = {255, 0, 0}
    colours[2] = {0, 255, 0}
    colours[3] = {0, 0, 255}
    colours[4] = {255, 255, 0}
    colours[5] = {255, 0, 255}
    colours[6] = {0, 255, 255}

    for y = 1, columns do
        for x = 1, rows do
            local colorType = (math.floor((x-1)*(1/4)) + y) % activeColors + 1
            local brick = self:add(Brick:new(xoff + (x-1) * 40, yoff + (y-1) * 24, colours[colorType], colorType))
        end
    end

    self.paddle = self:add(Paddle:new())
    self.ball = self:add(Ball:new())

    self.targetColor = 1
    self.switchTick = 10 -- How many seconds between choosing a target block
    self.switchTimer = 0
    self.colorChoices = activeColors

    self.colors = colours
end

function game:update(dt)
    Flux.update(dt)

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    for key, obj in pairs(objects) do
        obj:update(dt, self.world)
    end

    -- Determines when the target block should be changed
    self.switchTimer = self.switchTimer + dt
    if self.switchTimer >= self.switchTick then
        self.switchTimer = 0

        self:pickTarget()
    end

    self:updateScreenMove(dt)
end

function game:remainingOfColor(colorType)
    count = 0

    for k, obj in ipairs(objects) do
        if obj:isInstanceOf(Brick) then
            if obj.colorIndex == colorType then
                count = count + 1
            end
        end
    end

    return count
end

function game:pickTarget()
    local oldTarget = self.targetColor
    local possible = self.colorChoices

    if self.colorChoices > 1 then
        local choices = {}
        for i = 1, possible do
            if i ~= oldTarget then -- ensure it is a different color than before
                if self:remainingOfColor(i) > 0 then
                    table.insert(choices, i)
                end
            end
        end

        if #choices == 0 then
            self.targetColor = oldTarget
        else
            local index = math.random(1, #choices)
            self.targetColor = choices[index]
        end
    else
        self.targetColor = 1
    end
end

function game:keypressed(key, code)

end

function game:mousepressed(x, y, mbutton)

end

function game:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(0, 0, 0)

    for key, obj in pairs(objects) do
        obj:draw()
    end
    self.ball:draw()

    -- DRAW TARGET BRICK

    local x, y = 5, 5
    local width = 40
    local height = 24

    love.graphics.setColor(self.colors[self.targetColor])
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor({0, 0, 0})
    love.graphics.rectangle("line", x, y, width, height)
end
