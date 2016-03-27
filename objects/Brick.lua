Brick = Class('Brick', StaticObject)

Brick.static.width = 40
Brick.static.height = 24

function Brick:initialize(x, y, color, colorIndex)
	StaticObject.initialize(self, x, y, Brick.width, Brick.height)
    assert(self.draw)
    self.color = color
	self.colorIndex = colorIndex
end

function Brick:budge(vel)
	vel.y = vel.y*-1
	local dir = math.atan2(vel.y, vel.x)
	local x, y = self.position.x, self.position.y
	Flux.to(self, .1, {posX = x + math.cos(dir)*5, posY = y + math.sin(dir)*5}):after(self, .2, {posX = x, posY = y})
end

function Brick:update(dt, world)
    StaticObject.update(self, dt, world)
end

function Brick:draw()
    StaticObject.draw(self)
end

function Brick:drawShadow()
    StaticObject.drawShadow(self)
end
