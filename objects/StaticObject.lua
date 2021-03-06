StaticObject = Class("StaticObject")

function StaticObject:initialize(x, y, w, h, tag)
    self.position = vector(x, y)
    self.width = w
    self.height = h
    self.color = {255, 255, 255}
    self.tag = tag or ""

    self.widthStart = self.width
    self.heightStart = self.height

    self.posX = self.position.x
    self.posY = self.position.y
    if self.tag ~= "top" and self.tag ~= "bottom" and self.tag ~= "left" and self.tag ~= "right" then
    	self.posY = self.posY - 400
		Flux.to(self, 3, {posY = self.position.y}):delay(math.random()):ease("elasticout")
	end
end

function StaticObject:update(dt)
end

function StaticObject:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.posX+(self.widthStart-self.width)/2, self.posY+(self.heightStart-self.height)/2, self.width, self.height)
end

function StaticObject:drawShadow()
	if self.tag ~= "bottom" and self.tag ~= "right" then
		local offset = 4
   		love.graphics.setColor(70, 70, 70, 255)
   		love.graphics.rectangle("fill", self.posX+offset+(self.widthStart-self.width)/2, self.posY+offset+(self.heightStart-self.height)/2, self.width, self.height)
   	end
end

function StaticObject:pushOut()
	local bounce = 3
	if self.tag == "top" or self.tag == "bottom" then
		Flux.to(self, .5, {height = self.heightStart*(bounce)}):after(self, 1, {height = self.heightStart}):ease("elasticout")
	elseif self.tag == "left" or self.tag == "right" then
		Flux.to(self, .5, {width = self.widthStart*(bounce)}):after(self, 1, {width = self.widthStart}):ease("elasticout")
	end
end
