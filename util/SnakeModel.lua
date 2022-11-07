local SnakeMass = class("SnakeMass")

function SnakeMass:__init(x, y, nextDistance)
    self.x = x
    self.y = y
    self.nextDistance = nextDistance
    self.resAngle = 0
    self.resCenterX = 0
    self.resCenterY = 0
end

function SnakeMass:setData(x, y, nextDistance)
    self.x = x
    self.y = y
    if nextDistance ~= nil then
        self.nextDistance = nextDistance
    end
end

local SnakeModel = class("SnakeModel")

function SnakeModel:__init()
    self.m_masses = {}
end

function SnakeModel:clear()
    self.m_masses = {}
end

function SnakeModel:addHead(centerX, centerY, angle, jointLength)
    if #self.m_masses ~= 0 then
        return
    end
    table.insert(self.m_masses, SnakeMass.new(0, 0, 0))
    table.insert(self.m_masses, SnakeMass.new(0, 0, 0))
    self:setHead(centerX, centerY, angle, jointLength)
end

function SnakeModel:setHead(centerX, centerY, angle, jointLength)
    if #self.m_masses < 2 then
        return
    end
    local headLength = jointLength
    if headLength == nil then
        headLength = self.m_masses[1].nextDistance
    end
    local c = math.cos(angle + math.pi) * headLength * 0.5
    local s = math.sin(angle + math.pi) * headLength * 0.5
    if jointLength == nil then
        self.m_masses[1]:setData(centerX - c, centerY - s)
        self.m_masses[2]:setData(centerX + c, centerY + s)
    else
        self.m_masses[1]:setData(centerX - c, centerY - s, jointLength)
        self.m_masses[2]:setData(centerX + c, centerY + s, 0)
    end
end

function SnakeModel:addBody(angle, jointLength)
    if #self.m_masses < 2 then
        return
    end
    local lastMass = self.m_masses[#self.m_masses]
    lastMass.nextDistance = jointLength
    table.insert(self.m_masses, SnakeMass.new(
            lastMass.x + math.cos(angle) * jointLength,
            lastMass.y + math.sin(angle) * jointLength,
            0
    ))
end

function SnakeModel:getRes(index)
    if not (index >= 1 and index < #self.m_masses) then
        return 0.0, 0.0, 0.0
    end
    local mass = self.m_masses[index]
    return mass.resCenterX, mass.resCenterY, mass.resAngle
end

function SnakeModel:update(headX, headY, headSpx, headSpy, headAngle)
    if #self.m_masses > 0 then
        self:setHead(headX, headY, headAngle)
    end
    local sqrt = math.sqrt
    local sin = math.sin
    local cos = math.cos
    local total = #self.m_masses
    local spx, spy = headSpx, headSpy

    for i = 1, total do
        local mass = self.m_masses[i]
        mass.x = mass.x + spx
        mass.y = mass.y + spy
        if i < total then
            local nextMass = self.m_masses[i + 1]
            local dx = nextMass.x - mass.x
            local dy = nextMass.y - mass.y
            local newDistance = sqrt(dx * dx + dy * dy)
            local newAngle = Utils.GetAngle(mass.x - nextMass.x, mass.y - nextMass.y)
            local moveDistance = newDistance - mass.nextDistance
            spx = cos(newAngle) * moveDistance
            spy = sin(newAngle) * moveDistance
        end
    end
    for i = 1, total - 1 do
        local mass = self.m_masses[i]
        local nextMass = self.m_masses[i + 1]
        mass.resAngle = Utils.FixAngle(Utils.GetAngle(nextMass.x - mass.x, nextMass.y - mass.y) + math.pi)
        mass.resCenterX = (mass.x + nextMass.x) * 0.5
        mass.resCenterY = (mass.y + nextMass.y) * 0.5
    end
end

return SnakeModel