local t = turtle
local startPosition = { x = 0, y = 0, z = 0 }
local position = { x = 5, y = 5, z = 0 }
local size = { x = 10, y = 10, z = 10 }
local direction = 90

function CheckBounds()
    local bounds = {x = false, y = false, z = false}
    if position.x + 1 > size.x or position.x - 1 < 0 then
        bounds.x = true
    end
    if position.y + 1 > size.y or position.y - 1 < 0 then
        bounds.y = true
    end
    if position.z + 1 > size.z or position.z - 1 < 0 then
        bounds.z = true
    end
    return bounds 
end

function SetDirection(addDirection)
    direction = direction + addDirection
    if(direction == -90) then
        direction = 270
    elseif (direction >= 360) then
        direction = direction - 360 
    end
end

function ChangePosition(move)
    print("hi")
    if direction == 90 and move == "forward" then
        position.y = position.y + 1
    elseif direction == 180 and move == "forward" then
        position.x = position.x - 1
        print("hello")
    elseif direction == 270 and move == "forward"  then
        position.y = position.x + 1
    elseif direction == 0 and move == "forward" then
        position.x = position.x + 1
    end
    
    if direction == 90 and move == "back"  then
        position.y = position.y - 1
    elseif direction == 180 and move == "back"  then
        position.x = position.x + 1
    elseif direction == 270 and move == "back"  then
        position.y = position.x - 1
    elseif direction == 0 and move  == "back"  then
        position.x = position.x + 1
    end
end

function TurnTo(side)
    if side == "left" then
        t.turnLeft()
        SetDirection(90)
    elseif side == "right" then
        t.turnRight()
        SetDirection(-90)
    end
end

function MoveTo(side, toDo)
    if side == "forward" then
        if not CheckBounds().x and not CheckBounds().y then
            t.forward()
            if toDo ~= nil then
                toDo()
            end
            ChangePosition(side)
            return "success"
        else
            return "OutOfBounds"
        end
    elseif side == "back" then
        if not CheckBounds().x and not CheckBounds().y then
            t.back()
            if toDo ~= nil then
                toDo()
            end
            ChangePosition(side)
            return "success"
        else
            return "OutOfBounds"
        end
    elseif side == "up" then
        if not CheckBounds().z then
            t.up()
            position.z = position.z + 1
            return "success"
        else
            return "OutOfBoudns"
        end
    elseif side == "down" then
        if not CheckBounds().z then
            t.down()
            position.z = position.z - 1
            return "success"
        else
            return "OutOfBounds"
        end
    elseif side == "left" then
        if not CheckBounds().x and not CheckBounds().y then
            TurnTo("left")
            if toDo ~= nil then
                toDo()
            end
            t.forward()
            ChangePosition(side)
           return "success"
        else
            return "OutOfBounds"
        end
    elseif side == "right" then
        if not CheckBounds().x and not CheckBounds().y then
            TurnTo("right")
            if toDo ~= nil then
                toDo()
            end
            t.forward()
            ChangePosition(side)
            return "success"
        else
            return "OutOfBounds"
        end
    end
end

function GoBack()
    -- turte goes to 0, 0, 0. a bunch of while's
    -- and check with isonbound()
    -- Here is a big problem with CheckBounds() function and
    -- MoveTo() function as well they are trying to do all things at once
    -- which causes to not working in specific situations. Example:
    -- MoveTo() on x border tries to go for y = 0 but CheckBounds() returns
    -- false.
    -- TODO: reimplement CheckBounds() and MoveTo() functions.
    while direction ~= 180 do
        TurnTo("left")
    end
    
    while CheckBounds().x ~= true do
        print(MoveTo("forward", nil))
        print("position: " .. position.x)
        print("direction: " .. direction)
        
    end
    
    while direction ~= 270 do
        TurnTo("left", nil)
    end
    
    while CheckBounds().y ~= true do
        MoveTo("forward", nil)
    end
    
    while direction ~= 90 do
        TurnTo("left", nil)
    end
    
    while CheckBounds().z ~= true do
        MoveTo("down", nil)
    end
end

function FowardDig()
    MoveTo("forward", t.dig)
end

function RightDig()
    MoveTo("right", t.dig)
end

function LeftDig()
    MoveTo("left", t.dig)
end

GoBack()