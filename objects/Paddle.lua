Paddle = Class('Paddle', GameObject);

function Paddle:initialize()
	GameObject:initialize();
	self.width = 80;
	self.height = 16;
	self.x = (love.graphics.getWidth() - self.width)/2;
	self.y = love.graphics.getHeight() - 80;
	self.color = color;
    self.body = love.physics.newBody(world, self.x + self.width/2, self.y + self.height/2);
    self.shape = love.physics.newRectangleShape(self.width, self.height);
    self.fixture = love.physics.newFixture(self.body, self.shape);
end

function Paddle:destroy()
	self.body:destroy();
end

function Paddle:draw()
	love.graphics.setColor({255, 255, 255});
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height);
end

function Paddle:update(dt)
	if love.keyboard.isDown("left") then
		self.x = self.x - 500 * dt;
		self.x = math.max(16, self.x);
		self.body:setPosition(self.x + self.width/2, self.y + self.height/2);
	end
	if love.keyboard.isDown("right") then
		self.x = self.x + 500 * dt;
		self.x = math.min(love.graphics.getWidth() - self.width - 16, self.x);
		self.body:setPosition(self.x + self.width/2, self.y + self.height/2);
	end
end
