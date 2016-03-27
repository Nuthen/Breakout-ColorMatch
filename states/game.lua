game = {}

objects = {}
function game:add(obj, addToBump)
    if addToBump == nil then
        addToBump = true
    end
    table.insert(objects, obj)
    if addToBump then
        self.world:add(obj, obj.position.x, obj.position.y, obj.width, obj.height)
    end
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

function game:isValidHit(colorType)
    return colorType == self.targetColor
end

function game:enter()
    self.world = bump.newWorld()
    
    self.walls = {}
    -- Create the outer bounds area
    local wallSize = 5
    -- bottom wall
    local wall = self:add(StaticObject:new(0, love.graphics.getHeight()-wallSize, love.graphics.getWidth(), wallSize))
    table.insert(self.walls, wall)
    -- top wall
    local wall = self:add(StaticObject:new(0, 0, love.graphics.getWidth(), wallSize))
    table.insert(self.walls, wall)
    -- left wall
    local wall = self:add(StaticObject:new(0, 0, wallSize, love.graphics.getHeight())) 
    table.insert(self.walls, wall)
    -- right wall
    local wall = self:add(StaticObject:new(love.graphics.getWidth()-wallSize, 0, wallSize, love.graphics.getHeight()))
    table.insert(self.walls, wall)

    -- gameWidth and gameHeight is screen size minus the padding area
    local gameWidth = love.graphics.getWidth() - 64
    local gameHeight = love.graphics.getHeight() - 32

    local xSpacing = 10
    local ySpacing = 10
    local rows = math.floor(gameWidth / (Brick.width + xSpacing)) - 1
    local columns = 6
    local xoff = (love.graphics.getWidth() - rows*(Brick.width + xSpacing))/2
    local yoff = 80

    local activeColors = 3

    local colours = {}
    colours[1] = {255, 107, 107}
    colours[2] = {199, 244, 100}
    colours[3] = {78, 205, 196}
    colours[4] = {255, 255, 0}
    colours[5] = {255, 0, 255}
    colours[6] = {0, 255, 255}

    for y = 1, columns do
        for x = 1, rows do
            local colorType = (math.floor((x-1)*(1/4)) + y) % activeColors + 1
            local brick = self:add(Brick:new(xoff + (x-1) * (Brick.width + xSpacing), yoff + (y-1) * (Brick.height + ySpacing), colours[colorType], colorType))
        end
    end

    self.paddle = self:add(Paddle:new())
    self.ball = self:add(Ball:new())

    self.targetColor = 1
    self.switchTick = 10 -- How many seconds between choosing a target block
    self.switchTimer = 0
    self.colorChoices = activeColors

    self.colors = colours

    --self:add(Particles:new(), false)
    self.particles = Particles:new()
    self.shakePos = vector(0, 0)
    self.shakeReturnSpeed = .1 -- rate it returns to the center
    self.shakeVel = vector(0, 0)
    self.shakeAccel = vector(0, 0)

    self.timeDilation = 1
    self.scaleDilation = 1

    self.sound = Sound:new()

    signal.register('brickHit', function(obj, wall)
        self.timeDilation = .5
        Flux.to(self, .3, {scaleDilation = 1.2}):after(self, .3, {scaleDilation = 1})
        Flux.to(self, 1, {timeDilation = 1})
    end)

    self.camera = camera.new(300, 400)
    self.camera:lockX(0)
    self.cameraLookMarginX = 200
    self.cameraLookMarginY = 400
end

function game:addShakeAccel(accel)
    -- cap the largest possible amount of acceleration
    local maxAccel = 20000
    if accel:len() > maxAccel then
        accel = accel:normalized() * maxAccel
    end

    self.shakeAccel = self.shakeAccel + accel
end

function game:update(dt)
    dt = dt * self.timeDilation

    -- screen shake
    self.shakeAccel = self.shakeAccel - self.shakeReturnSpeed*self.shakeAccel
    self.shakeVel = self.shakeVel + self.shakeAccel*dt
    self.shakePos = self.shakePos + self.shakeVel*dt
    self.shakePos = self.shakePos - self.shakeReturnSpeed*self.shakePos
    self.shakeVel = self.shakeVel * .9 -- damping
    --

    Flux.update(dt)

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    for key, obj in pairs(objects) do
        if self.world:hasItem(obj) then
            obj:update(dt, self.world)
        end
    end

    -- Determines when the target block should be changed
    self.switchTimer = self.switchTimer + dt
    if self.switchTimer >= self.switchTick then
        self.switchTimer = 0

        self:pickTarget()
    end

    for i, wall in pairs(self.walls) do
        wall.color = self.colors[self.targetColor]
    end

    self.particles:update(dt)
    self.sound:update(dt)
    self.camera:lookAt(self.ball.position.x + self.ball.width/2, self.ball.position.y + self.ball.height/2)
    self.camera:zoomTo(self.scaleDilation)

    local marginX = self.cameraLookMarginX * 1/self.camera.scale
    local marginY = self.cameraLookMarginY * 1/self.camera.scale
    self.camera.x = math.max(marginX, math.min(600-marginX, self.camera.x))
    self.camera.y = math.max(marginY, math.min(600-marginY, self.camera.y))
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
    --love.graphics.setBackgroundColor(255, 2, 100)
    love.graphics.setBackgroundColor(self.colors[self.targetColor]) -- sets the color outside the border

    -- everything in here will be a part of the screen shake
    love.graphics.push()
    love.graphics.translate(self.shakePos.x, self.shakePos.y)

    self.camera:attach()

    --love.graphics.scale(self.scaleDilation)
    --love.graphics.translate(1/self.scaleDilation * (-self.ball.position.x + self.ball.width/2 + 300), 1/self.scaleDilation*(-self.ball.position.y + self.ball.height/2 + 400))
    --love.graphics.translate(self.ball.position.x, self.ball.position.y)

    love.graphics.setColor(127, 127, 127) -- this is the true background color
    love.graphics.rectangle('fill', 5, 5, love.graphics.getWidth()-5, love.graphics.getHeight()-5) -- draws the background color

    for key, obj in pairs(objects) do
        obj:draw()
    end
    self.ball:draw()

    self.particles:draw()


    self.camera:detach()

    love.graphics.pop()
    --

    -- DRAW TARGET BRICK

    local x, y = 5, 5
    local width = 40
    local height = 24

    love.graphics.setColor(self.colors[self.targetColor])
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor({0, 0, 0})
    love.graphics.rectangle("line", x, y, width, height)
end
