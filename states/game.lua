game = {}

-- Game TODO:
--      * Add identity and title to conf.lua


-- Some constants
Game = {Title = "", FPS = 60, BackgroundColor = {64, 64, 64}};
love.graphics.setColour = love.graphics.setColor;


function beginContact(a, b, coll)
end
function endContact(a, b, coll)

end
function preSolve(a, b, coll)

end
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
    if a:getUserData() then
        local d = a:getUserData();
        instance_destroy(d.object);
    end
    if b:getUserData() then
        local d = b:getUserData();
        instance_destroy(d.object);
    end
end

function game:enter()
    min_dt = 1/Game.FPS;
    next_time = love.timer.getTime();

    love.physics.setMeter(10);
    world = love.physics.newWorld(0, 0, true);
    world:setCallbacks(beginContact, endContact, preSolve, postSolve);

    -- Create the outer bounds area
    ground = {}
    ground.body = love.physics.newBody(world, 300, 800-16/2)
    ground.shape = love.physics.newRectangleShape(600, 16);
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)

    ground2 = {}
    ground2.body = love.physics.newBody(world, 300, 16/2)
    ground2.shape = love.physics.newRectangleShape(600, 16);
    ground2.fixture = love.physics.newFixture(ground2.body, ground2.shape)

    ground3 = {}
    ground3.body = love.physics.newBody(world, 16/2, 400)
    ground3.shape = love.physics.newRectangleShape(16, 800);
    ground3.fixture = love.physics.newFixture(ground3.body, ground3.shape)

    ground4 = {}
    ground4.body = love.physics.newBody(world, 600-16/2, 400)
    ground4.shape = love.physics.newRectangleShape(16, 800);
    ground4.fixture = love.physics.newFixture(ground4.body, ground4.shape)

    -- Create the ball
    ball = {}
    ball.body = love.physics.newBody(world, 300, 400, "dynamic")
    ball.shape = love.physics.newCircleShape( 12);
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(1);
    ball.fixture:setFriction(0);
    ball.body:setBullet(true);
    ball.body:setFixedRotation(true);

    ball.body:applyLinearImpulse(1000, 1500)

    -- gameWidth and gameHeight is screen size minus the padding area
    local gameWidth = love.graphics.getWidth() - 64;
    local gameHeight = love.graphics.getHeight() - 32;

    local rows = math.floor(gameWidth / 40) - 1;
    local columns = 6;
    local xoff = (love.graphics.getWidth() - rows*40)/2;
    local yoff = 80;

    local colours = {};
    colours[1] = {255, 0, 0};
    colours[2] = {0, 255, 0};
    colours[3] = {0, 0, 255};
    colours[4] = {255, 255, 0};
    colours[5] = {255, 0, 255};
    colours[6] = {0, 255, 255};

    for y = 0, columns-1 do
        for x = 0, rows-1 do
            local brick = Brick:new(xoff + x * 40, yoff + y * 24, colours[y+1] );
            table.insert(objList, brick);
        end
    end

    table.insert(objList, Paddle:new());
end

function game:update(dt)
	Flux.update(dt);
    world:update(dt);

    next_time = next_time + min_dt;
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if masterObj then
        masterObj:update(dt);
    else
        for key, value in pairs(objList) do
            value:update(dt);
        end
    end
end

function game:keypressed(key, code)

end

function game:mousepressed(x, y, mbutton)

end

function game:draw()
    love.graphics.setColor(255, 255, 255)
    --love.graphics.setFont(font[48])
    --local x = love.graphics.getWidth()/2 - love.graphics.getFont():getWidth(text)/2
    --local y = love.graphics.getHeight()/2 - love.graphics.getFont():getHeight(text)/2
	-- love.graphics.print(text, x, y)

   love.graphics.clear( Game.BackgroundColor);

    -- Draw
    for i = 0, 3, 1 do
        for key, value in pairs(objList) do
            if value.depth == i then
                value:draw();
                love.graphics.reset();
            end
        end
    end

    love.graphics.setColor({255, 255, 255});
    if ball then
        love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius());
    end

    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
    love.graphics.polygon("fill", ground2.body:getWorldPoints(ground2.shape:getPoints()))
    love.graphics.polygon("fill", ground3.body:getWorldPoints(ground3.shape:getPoints()))
    love.graphics.polygon("fill", ground4.body:getWorldPoints(ground4.shape:getPoints()))

    -- Draw GUI
   for key, value in pairs(objList) do
       value:drawGui();
       love.graphics.reset();
   end

    local cur_time = love.timer.getTime();
    if next_time <= cur_time then
        next_time = cur_time;
        return;
    end
    love.timer.sleep(next_time - cur_time);
end