Paddle = Class('Paddle')

function Paddle:initialize(x, y)
    self.width = 80
	self.height = 16
	self.position = vector(
        x or love.graphics.getWidth()/2 - self.width/2,
        y or love.graphics.getHeight() - 80 
    )
    self.speed = 500
	self.color = {255, 255, 255}
	self.shakeDistance = -15
end

function Paddle:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end

function Paddle:update(dt, world)
    local goal = self.position:clone()
    if love.keyboard.isDown("a", "left") then
        goal.x = self.position.x - self.speed * dt 
    elseif love.keyboard.isDown("d", "right") then
        goal.x = self.position.x + self.speed * dt 
    end

    local actualX, actualY, cols, len = world:move(self, goal.x, goal.y) 
    self.position.x, self.position.y = actualX, actualY

    for i, col in pairs(cols) do
        local other = col.other
    end
end
