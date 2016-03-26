Brick = Class('Brick', StaticObject)

Brick.static.width = 40
Brick.static.height = 24

function Brick:initialize(x, y, color, colorIndex)
	StaticObject.initialize(self, x, y, Brick.width, Brick.height)
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
