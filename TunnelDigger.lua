local t = turtle
local startPosition = { x = -1, y = -1 }
local position = { x = 0, y = 0 }
local size = { x = 0, y = 0 }
local direction = 90

function IsOnBound()
    local bounds = {xbound = false, ybound = false}
    if position.x + 1 > size.x or position.x - 1 > 0 then
        xbound = true
    end
    if position.y + 1 > size.y or position.y - 1 > 0 then
        ybound = true
    end
    return bounds
end

function SetDirection(addDirection)
    direction = direction + addDirection
    if(direction == -90)
        direction = 270
    elseif (direction >= 360)
        direction = direction - 360 
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
        if not IsOnBound() then
            t.forward()
            toDo()
            position.y = position.y + 1
            return "success"
        else
            return "OutOfBounds"
        end
    elseif side == "back" then
        if not IsOnBound() then
            t.back()
            toDo()
            position.y = position.y - 1
            return "success"
        end
    elseif side == "left" then
        if not IsOnBound() then
            TurnTo("left")
            toDo()
            t.forward()
            position.x = position.x - 1
            return "success"
        end
    elseif side == "right" then
        if not IsOnBound() the
            TurnTo("right")
            toDo()
            t.forward()
            position.x = position.x + 1
            return "success"
        end
    end
end

function GoBack()
    -- turte goes to -1 -1, a bunch of while's
    -- and check with isonbound
end

function FowardDig()
    t.dig()
    MoveTo("forward", nil)
end

function RightDig()
    MoveTo("right", t.dig)
end

function LeftDig()
    MoveTo("left", t.dig)
end

FowardDig()
RightDig()