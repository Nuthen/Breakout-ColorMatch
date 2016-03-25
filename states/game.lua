game = {}

function beginContact(a, b, coll)
end
function endContact(a, b, coll)

end
function preSolve(a, b, coll)

end
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
    if a:getUserData() and b:getUserData() then
        local d = a:getUserData()
        local other = b:getUserData()
        if d.type == 'brick' then
            if game:isValidHit(d.colorType) then
                instance_destroy(d.object)
            end
        elseif d.type == 'ball' then
            --self.ball:addToLine()
            game:moveScreen(other.dir)
        end
    end
    if b:getUserData() and a:getUserData() then
        local d = b:getUserData()
        local other = a:getUserData()
        if d.type == 'brick' then
            if game:isValidHit(d.colorType) then
                instance_destroy(d.object)
            end
        elseif d.type == 'ball' then
            --d.object:addToLine()
            game:moveScreen(other.dir)
        end
    end
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

    love.physics.setMeter(10)
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- Create the outer bounds area
    -- bottom wall
    ground = {}
    ground.body = love.physics.newBody(world, 300, 800-16/2)
    ground.shape = love.physics.newRectangleShape(600, 16)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
    ground.fixture:setUserData({object = self, type = 'ground', dir = 'bottom'})
    ground.fixture:setCategory(1)

    -- top wall
    ground2 = {}
    ground2.body = love.physics.newBody(world, 300, 16/2)
    ground2.shape = love.physics.newRectangleShape(600, 16)
    ground2.fixture = love.physics.newFixture(ground2.body, ground2.shape)
    ground2.fixture:setUserData({object = self, type = 'ground', dir = 'top'})
    ground2.fixture:setCategory(2)

    -- left wall
    ground3 = {}
    ground3.body = love.physics.newBody(world, 16/2, 400)
    ground3.shape = love.physics.newRectangleShape(16, 800)
    ground3.fixture = love.physics.newFixture(ground3.body, ground3.shape)
    ground3.fixture:setUserData({object = self, type = 'ground', dir = 'left'})
    ground3.fixture:setCategory(3)

    -- right wall
    ground4 = {}
    ground4.body = love.physics.newBody(world, 600-16/2, 400)
    ground4.shape = love.physics.newRectangleShape(16, 800)
    ground4.fixture = love.physics.newFixture(ground4.body, ground4.shape)
    ground4.fixture:setUserData({object = self, type = 'ground', dir = 'right'})
    ground4.fixture:setCategory(4)


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
            local brick = Brick:new(xoff + (x-1) * 40, yoff + (y-1) * 24, colours[colorType], colorType)
            table.insert(objList, brick)
        end
    end

    table.insert(objList, Paddle:new())

    self.ball = Ball:new()

    self.targetColor = 1
    self.switchTick = 10 -- How many seconds between choosing a target block
    self.switchTimer = 0
    self.colorChoices = activeColors

    self.colors = colours
end

function game:update(dt)
    Flux.update(dt)
    world:update(dt)

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if masterObj then
        masterObj:update(dt)
    else
        for key, value in pairs(objList) do
            value:update(dt)
        end
    end
    self.ball:update(dt)

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

    for k, obj in ipairs(objList) do
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

    -- Draw
    for i = 0, 3, 1 do
        for key, value in pairs(objList) do
            if value.depth == i then
                value:draw()
                love.graphics.reset()
            end
        end
    end
    self.ball:draw()

    love.graphics.setColor({255, 255, 255})

    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
    love.graphics.polygon("fill", ground2.body:getWorldPoints(ground2.shape:getPoints()))
    love.graphics.polygon("fill", ground3.body:getWorldPoints(ground3.shape:getPoints()))
    love.graphics.polygon("fill", ground4.body:getWorldPoints(ground4.shape:getPoints()))

    -- Draw GUI
    for key, value in pairs(objList) do
        value:drawGui()
        love.graphics.reset()
    end


    -- DRAW TARGET BRICK

    local x, y = 5, 5
    local width = 40
    local height = 24

    love.graphics.setColor(self.colors[self.targetColor])
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor({0, 0, 0})
    love.graphics.rectangle("line", x, y, width, height)
end
