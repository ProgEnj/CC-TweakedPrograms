-- Starting position handling


local t = turtle
-- Turtle strarts in bottom left corner of the grid_size variable.
-- so its 0, 0, 0. grid_size determines area that turtle will mine
-- coordinates as in math, fuck minecraft's system (even if it's just a letter)
-- no moving along z axis for now
local grid_size = { x = 5, y = 3 }
local current_position = { x = 5, y = 2 }
-- 0 degree is along x axis, moving counter clockwise (same as in math)
local turtle_direction = 90

function CheckOutOfBounds(direction)
    local isOutOfBounds = { x = false, y = false }

    if direction == "forward" then
        if turtle_direction == 0 and current_position.x + 1 > grid_size.x then
            isOutOfBounds.x = true
        elseif turtle_direction == 180 and current_position.x - 1 <= 0 then
            isOutOfBounds.x = true
        elseif turtle_direction == 90 and current_position.y + 1 > grid_size.y then
            isOutOfBounds.y = true
        elseif turtle_direction == 270 and current_position.y - 1 <= 0 then
            isOutOfBounds.y = true
        end
        return isOutOfBounds
    end

    if direction == "backward" then
        if turtle_direction == 0 and current_position.x - 1 <= 0 then
            isOutOfBounds.x = true
        elseif turtle_direction == 180 and current_position.x + 1 > grid_size.x then
            isOutOfBounds.x = true
        elseif turtle_direction == 90 and current_position.y - 1 <= 0 then
            isOutOfBounds.y = true
        elseif turtle_direction == 270 and current_position.y + 1 > grid_size.y then
            isOutOfBounds.y = true
        end
        return isOutOfBounds
    end
end

function SetDirection(addDirection)
    turtle_direction = turtle_direction + addDirection
    if (turtle_direction == -90) then
        turtle_direction = 270
    elseif (turtle_direction == 360) then
        turtle_direction = 0
    end
end

-- You can make move variable as enum where forward = 1 and backward -1
-- then just do for 0 and 90 "+ move" and for 180 and 270 "+ (-move)"
-- that will eliminnate 1 if statement (optimization, wow)
function ChangePosition(move)
    if move == "forward" then
        if turtle_direction == 0 then
            current_position.x = current_position.x + 1
        elseif turtle_direction == 90 then
            current_position.y = current_position.y + 1
        elseif turtle_direction == 180 then
            current_position.x = current_position.x - 1
        elseif turtle_direction == 270 then
            current_position.y = current_position.y - 1
        end
    elseif move == "back" then
        if turtle_direction == 0 then
            current_position.x = current_position.x - 1
        elseif turtle_direction == 90 then
            current_position.y = current_position.y - 1
        elseif turtle_direction == 180 then
            current_position.x = current_position.x + 1
        elseif turtle_direction == 270 then
            current_position.y = current_position.y + 1
        end
    end
end

function TurnTo(side)
    if side == "left" then
        SetDirection(90)
        t.turnLeft()
    elseif side == "right" then
        SetDirection(-90)
        t.turnRight()
    end
end

function MoveWithAction(side, action)
    if side == "forward" then
        if CheckOutOfBounds(side).x or CheckOutOfBounds(side).y then
            return false, "OutOfBounds"
        end
        if action ~= nil then
            action()
        end
        local isSuccess, err = t.forward()
        if not isSuccess then
            return isSuccess, err
        end
        ChangePosition(side)
        return true, nil
    elseif side == "back" then
        if CheckOutOfBounds(side).x or CheckOutOfBounds(side).y then
            return false, "OutOfBounds"
        end
        if action ~= nil then
            action()
        end
        local isSuccess, err = t.back()
        if not isSuccess then
            return isSuccess, err
        end
        ChangePosition(side)
        return true, nil
    elseif side == "left" then
        if CheckOutOfBounds(side).x or CheckOutOfBounds(side).y then
            return false, "OutOfBounds"
        end
        TurnTo("left")
        if action ~= nil then
            action()
        end
        local isSuccess, err = t.forward()
        if not isSuccess then
            return isSuccess, err
        end
        ChangePosition(side)
        return true, nil
    elseif side == "right" then
        if CheckOutOfBounds(side).x or CheckOutOfBounds(side).y then
            return false, "OutOfBounds"
        end
        TurnTo("right")
        if action ~= nil then
            action()
        end
        local isSuccess, err = t.turnRight()
        if not isSuccess then
            return isSuccess, err
        end
        ChangePosition(side)
        return true, nil
    end
end

function GoBack()
    repeat
        TurnTo("left")
        print(turtle_direction)
    until turtle_direction == 180

    repeat
        print(MoveWithAction("forward", nil))
        print("position: " .. current_position.x)
        print("direction: " .. turtle_direction)
    until CheckOutOfBounds("forward").x == true

    repeat
        TurnTo("left", nil)
    until turtle_direction == 270

    repeat
        MoveWithAction("forward", nil)
    until CheckOutOfBounds("forward").y == true

    repeat
        TurnTo("left", nil)
    until turtle_direction == 90
end

GoBack()
