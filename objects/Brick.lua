Brick = Class('Brick', StaticObject)

function Brick:initialize(x, y, color, colorIndex)
	StaticObject.initialize(self, x, y, 40, 24)
    assert(self.draw)
    self.color = color
	self.colorIndex = colorIndex
end

function Brick:update(dt, world)
    StaticObject.update(self, dt, world)
end

function Brick:draw()
    StaticObject.draw(self)
end
