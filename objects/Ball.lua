Ball = Class('Ball')

function Ball:initialize(x, y)
    self.width = 12
    self.height = 12
    self.position = vector(x or love.graphics.getWidth()/2 - self.width/2, y or love.graphics.getHeight() - 400)
    self.speed = 500
    self.velocity = vector(self.speed, self.speed)
    self.color = {255, 255, 0, 255}
    self.lineColor = {255, 255, 255, 127}

    self.prevPos = {} -- table of previous positions
    self.posMax = 80
    self.trailTime = 0

    self.shakeStrength = 20 -- multiplied by velocity

    self.angle = 0
end

function Ball:update(dt, world)
	self.trailTime = self.trailTime + dt

    if self.trailTime > 1/100 then
        self:addToLine()
        self.trailTime = 0
    end

    local goal = self.position + self.velocity:normalized()*self.speed * dt
    local actualX, actualY, cols, len = world:move(self, goal.x, goal.y) 
    self.position.x, self.position.y = actualX, actualY

    for i, col in pairs(cols) do
    	game:addShakeAccel(self.velocity*self.shakeStrength)

        local other = col.other

        -- flip velocity
        if col.normal.y ~= 0 then
            self.velocity.y = self.velocity.y * -1
        end

        if col.normal.x ~= 0 then
            self.velocity.x = self.velocity.x * -1
        end

        -- haven't tested this
        if other:isInstanceOf(StaticObject) and not other:isInstanceOf(Brick) then
            signal.emit('wallHit', self, other)
        end

        if other:isInstanceOf(Paddle) then
            self.speed = self.speed * 1.01

            signal.emit('paddleHit', self, other)
        end

        if other:isInstanceOf(Brick) and game:isValidHit(other.colorIndex) then
            game:remove(other)
            signal.emit('brickHit', self, other, self.velocity.x, self.velocity.y)
        end
    end

    self.angle = math.atan2(self.velocity.x, self.velocity.y)

    signal.emit('ballMove', self)
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
		-- local curve = love.math.newBezierCurve(self.prevPos)
		-- love.graphics.line(curve:render(8))
	    love.graphics.line(self.prevPos)
    end

    love.graphics.push()
    love.graphics.translate(self.position.x + self.width/2, self.position.y + self.width/2)
    love.graphics.rotate(self.angle)
    love.graphics.translate(-self.position.x - self.width/2, -self.position.y - self.width/2)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
    love.graphics.pop()
end
