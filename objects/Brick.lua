Brick = Class('Brick', GameObject);

function Brick:initialize(x, y, colour)
	GameObject:initialize();
	self.x = x;
	self.y = y;
	self.width = 40;
	self.height = 24;
	self.colour = colour;
    self.body = love.physics.newBody(world, self.x + self.width/2, self.y + self.height/2);
    self.shape = love.physics.newRectangleShape(self.width, self.height);
    self.fixture = love.physics.newFixture(self.body, self.shape);
	self.fixture:setUserData({object = self, type = "brick"});
end

function Brick:destroy()
	self.body:destroy();
end

function Brick:draw()
	love.graphics.setColour(self.colour);
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height);

	love.graphics.setColour({0, 0, 0});
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height);
end