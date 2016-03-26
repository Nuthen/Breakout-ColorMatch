Particles = Class("Particles")

function Particles:initialize()
    self.systems = {}
    
    local img = love.graphics.newImage("assets/img/particle.png")

    self.systems[1] = love.graphics.newParticleSystem(img, 512)
    self.systems[1]:setLinearAcceleration(-100, -100, 100, 100)

    signal.register('brickHit', function(ball, brick)
        self.systems[1]:setPosition(brick.position.x, brick.position.y)
        self.systems[1]:emit(80)
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
