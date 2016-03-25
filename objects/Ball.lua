Ball = Class('Ball', GameObject)

function Ball:initialize()
    self.body = love.physics.newBody(world, 300, 400, "dynamic")
    self.shape = love.physics.newCircleShape(12)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setRestitution(1)
    self.fixture:setFriction(0)
    self.body:setBullet(true)
    self.body:setFixedRotation(true)
	self.fixture:setUserData({object = self, type = "ball", colorType = -1})

    self.body:applyLinearImpulse(1000, 1500)

    self.color = {255, 255, 255, 255}
    self.lineColor = {255, 0, 255, 255}

    self.prevPos = {} -- table of previous positions

    self.posMax = 100
end

function Ball:destroy()
	self.body:destroy()
end

function Ball:update(dt)
	self:addToLine()
end

function Ball:addToLine()
	if #self.prevPos >= self.posMax then
		table.remove(self.prevPos, 2)
		table.remove(self.prevPos, 1)
	end
	table.insert(self.prevPos, self.body:getX())
	table.insert(self.prevPos, self.body:getY())
end

function Ball:draw()
	love.graphics.setColor(self.lineColor)
	if #self.prevPos >= 4 then
		love.graphics.line(self.prevPos)
	end

	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
