local PhysicsUtil = class("PhysicsUtil")

function PhysicsUtil.SightChaseSpeed2D(spx, spy, force, forceAngle, maxSpeed)
    local PI = math.pi
    local oldAngle = Utils.FixAngle(Utils.GetAngle(spx, spy))
    forceAngle = Utils.FixAngle(forceAngle)
    local moveAngle = forceAngle - oldAngle
    if math.abs(moveAngle) > PI then
        moveAngle = moveAngle + 2 * PI * (moveAngle > 0 and -1 or 1)
    end
    moveAngle = Utils.FixAngle(moveAngle)
    if math.abs(moveAngle) > PI / 2 then
        forceAngle = oldAngle + PI / 2 * (moveAngle < 0 and -1 or 1)
    end
    return Utils.ForceSpeed2D(spx, spy, force, forceAngle, maxSpeed)
end

return PhysicsUtil