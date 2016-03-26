Ball = Class('Ball')

function Ball:initialize(x, y)
    self.width = 12
    self.height = 12
    self.position = vector(x or love.graphics.getWidth()/2 - self.width/2, y or love.graphics.getHeight() - 400)
    self.speed = 650
    self.velocity = vector(self.speed, self.speed)
    self.color = {255, 255, 255, 255}
    self.lineColor = {255, 0, 255, 255}

    self.prevPos = {} -- table of previous positions
    self.posMax = 100
end

function Ball:update(dt, world)
	self:addToLine()

    local goal = self.position + self.velocity:normalized()*self.speed * dt
    local actualX, actualY, cols, len = world:move(self, goal.x, goal.y) 
    self.position.x, self.position.y = actualX, actualY

    for i, col in pairs(cols) do
        local other = col.other

        -- flip velocity
        if col.normal.y ~= 0 then
            self.velocity.y = self.velocity.y * -1
        end

        if col.normal.x ~= 0 then
            self.velocity.x = self.velocity.x * -1
        end

        if other:isInstanceOf(Brick) and game:isValidHit(other.colorIndex) then
            game:remove(other)
        end
    end
end

function Ball:addToLine()
	if #self.prevPos >= self.posMax then
		table.remove(self.prevPos, 2)
		table.remove(self.prevPos, 1)
	end
	table.insert(self.prevPos, self.position.x + self.width/2)
	table.insert(self.prevPos, self.position.y + self.height/2)
end

function Ball:draw()
	love.graphics.setColor(self.lineColor)
	if #self.prevPos >= 4 then
		local curve = love.math.newBezierCurve(self.prevPos)
		love.graphics.line(curve:render(8))
	end

    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end
