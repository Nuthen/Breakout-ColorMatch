Sound = Class('Sound')

function Sound:initialize()
	self.musicVolume = .5
	self.soundVolume = 1
	self.currentMusicVolume = self.musicVolume

	self.music = {

	}
	self.sounds = {
		brickHitSuccess = "assets/sound/hit_brick_success.wav",
		brickHitFail = "assets/sound/hit_brick_fail.wav",
		paddleHit = "assets/sound/hit_paddle.wav",
		wallHit = "assets/sound/hit_wall.wav",
	}
	for i, sound in pairs(self.music) do
		self.music[i] = love.audio.newSource(sound)
		self.music[i]:setVolume(self.musicVolume)
		self.music[i]:setLooping(true)
	end
	for i, sound in pairs(self.sounds) do
		self.sounds[i] = love.audio.newSource(sound)
		self.sounds[i]:setVolume(self.soundVolume)
	end

    signal.register('brickHit', function() self:onBrickHit() end)
    signal.register('brickFail', function() self:onBrickFail() end)
    signal.register('paddleHit', function() self:onPaddleHit() end)
    signal.register('wallHit', function() self:onWallHit() end)
end

function Sound:update(dt)

end

function Sound:onBrickHit()
	self.sounds.brickHitSuccess:play()
end

function Sound:onBrickFail()
	self.sounds.brickHitFail:play()
end

function Sound:onPaddleHit()
	self.sounds.paddleHit:play()
end
function Sound:onWallHit()
	self.sounds.wallHit:play()
end