StaticObject = Class("StaticObject")

function StaticObject:initialize(x, y, w, h)
    self.position = vector(x, y)
    self.width = w
    self.height = h
    self.color = {255, 255, 255}
end

function StaticObject:update(dt)

end

function StaticObject:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end
