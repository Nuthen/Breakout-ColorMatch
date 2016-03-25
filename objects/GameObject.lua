GameObject = Class('GameObject');

function GameObject:initialize()
	self.x = 0;
	self.y = 0;
	self.depth = 0;
end
function GameObject:update(dt)

end
function GameObject:destroy()

end
function GameObject:draw()

end
function GameObject:drawGui()

end
function GameObject:keypressed(key)

end
function GameObject:keyreleased(key)

end
function GameObject:mousepressed( x, y, button, isTouch)

end
function GameObject:mousereleased( x, y, button, isTouch)

end
function GameObject:wheelmoved( x, y)

end

-- Setup our object list
objList = {};
-- Master Objects allow us to pause other objects
masterObj = nil;

-- Object helpers
function object_destroy(object)
    for k, value in pairs(objList) do
        if value:isInstanceOf(object) then
			value:destroy();
            objList[k] = nil;
        end
    end
end
function instance_destroy(instance)
    for k, value in pairs(objList) do
        if value == instance then
			value:destroy();
            objList[k] = nil;
            return;
        end
    end
end
function object_find(object)
    local objs = {};
    for k, value in pairs(objList) do
        if value:isInstanceOf(object) then
            table.insert(objs, objList[k]);
        end
    end
    return objs;
end
