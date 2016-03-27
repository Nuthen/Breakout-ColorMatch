Particles = Class("Particles")

function Particles:initialize()
    self.systems = {}
    
    local img = love.graphics.newImage("assets/img/particle_white.png")

    self.systems[1] = love.graphics.newParticleSystem(img, 512)
    self.systems[2] = love.graphics.newParticleSystem(img, 512)
    self.systems[3] = love.graphics.newParticleSystem(img, 512)
    self.systems[4] = love.graphics.newParticleSystem(img, 20)
    self.systems[5] = love.graphics.newParticleSystem(img, 100)

    signal.register('wallHit', function(obj, wall)
        if obj:isInstanceOf(Ball) then
            local dir = math.atan2(obj.velocity.y*-1, obj.velocity.x)
            local offset = math.rad(90)
            local dxMin = math.cos(dir - offset)
            local dyMin = math.sin(dir - offset)
            local dxMax = math.cos(dir + offset)
            local dyMax = math.sin(dir + offset)
            local speed = 600

            self.systems[1]:setPosition(obj.position.x + obj.width/2, obj.position.y + obj.height/2)
            self.systems[1]:setLinearAcceleration(dxMin*speed, dyMin*speed, dxMax*speed, dyMax*speed)
            self.systems[1]:setColors(wall.color[1], wall.color[2], wall.color[3], 255, wall.color[1], wall.color[2], wall.color[3], 0)
            self.systems[1]:setSizes(2, 0)
            self.systems[1]:setParticleLifetime(.2, .7)
            self.systems[1]:emit(40)
        elseif obj:isInstanceOf(Paddle) then
            local dir = math.atan2(obj.velocity.y*-1, obj.velocity.x)
            local offset = math.rad(90)
            local dxMin = math.cos(dir - offset)
            local dyMin = math.sin(dir - offset)
            local dxMax = math.cos(dir + offset)
            local dyMax = math.sin(dir + offset)
            local speed = 600

            local xOffset = obj.width/2
            if obj.velocity.x < 0 then xOffset = xOffset*-1 end

            self.systems[5]:setPosition(obj.position.x + obj.width/2 + xOffset, obj.position.y + obj.height/2)
            self.systems[5]:setLinearAcceleration(dxMin*speed, dyMin*speed, dxMax*speed, dyMax*speed)
            self.systems[5]:setColors(wall.color[1], wall.color[2], wall.color[3], 255, wall.color[1], wall.color[2], wall.color[3], 0)
            self.systems[5]:setSizes(2, 0)
            self.systems[5]:setParticleLifetime(.2, .7)
            self.systems[5]:emit(40)
        end
    end)

    signal.register('paddleHit', function(ball, paddle)
        local dir = math.atan2(ball.velocity.y*-1, ball.velocity.x)
        local offset = math.rad(90)
        local dxMin = math.cos(dir - offset)
        local dyMin = math.sin(dir - offset)
        local dxMax = math.cos(dir + offset)
        local dyMax = math.sin(dir + offset)
        local speed = 600

        self.systems[2]:setPosition(ball.position.x + ball.width/2, ball.position.y + ball.height/2)
        self.systems[2]:setLinearAcceleration(dxMin*speed, dyMin*speed, dxMax*speed, dyMax*speed)
        self.systems[2]:setColors(paddle.color[1], paddle.color[2], paddle.color[3], 255, paddle.color[1], paddle.color[2], paddle.color[3], 0)
        self.systems[2]:setSizes(2, 0)
        self.systems[2]:setParticleLifetime(.2, .7)
        self.systems[2]:emit(40)
    end)

    signal.register('brickHit', function(ball, brick)
        local dir = math.atan2(ball.velocity.y*-1, ball.velocity.x)
        local offset = math.rad(20)
        local dxMin = math.cos(dir - offset)
        local dyMin = math.sin(dir - offset)
        local dxMax = math.cos(dir + offset)
        local dyMax = math.sin(dir + offset)
        local speed = 800

        self.systems[3]:setPosition(ball.position.x + ball.width/2, ball.position.y + ball.height/2)
        self.systems[3]:setLinearAcceleration(dxMax*speed, dyMax*speed, dxMin*speed, dyMin*speed)
        self.systems[3]:setSpeed(5, 200)
        self.systems[3]:setColors(brick.color[1], brick.color[2], brick.color[3], 255)
        self.systems[3]:setSizes(1, 0)
        self.systems[3]:setParticleLifetime(.2, .7)
        self.systems[3]:emit(80)
    end)

    signal.register('ballMove', function(ball)
        local dir = math.atan2(ball.velocity.y*-1, ball.velocity.x)
        local offset = math.rad(20)
        local dxMin = math.cos(dir - offset)
        local dyMin = math.sin(dir - offset)
        local dxMax = math.cos(dir + offset)
        local dyMax = math.sin(dir + offset)
        local speed = 800

        self.systems[4]:setPosition(ball.position.x + ball.width/2, ball.position.y + ball.height/2)
        self.systems[4]:setLinearAcceleration(dxMax*speed, dyMax*speed, dxMin*speed, dyMin*speed)
        self.systems[4]:setSpeed(5, 200)
        self.systems[4]:setColors(ball.color[1], ball.color[2], ball.color[3], 255)
        self.systems[4]:setSizes(1, 0)
        self.systems[4]:setParticleLifetime(.2, .7)
        self.systems[4]:emit(1)
    end)
end

function Particles:update(dt)
    for i, system in pairs(self.systems) do
        system:update(dt)
    end
end

function Particles:draw()
    for i, system in pairs(self.systems) do
        love.graphics.draw(system)
    end
end
