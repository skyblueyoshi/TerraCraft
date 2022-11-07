local PortalEntity = class("PortalEntity")

function PortalEntity:__init(xi, yi)
    self.xi = xi
    self.yi = yi
end

local Portals = class("Portals")

function Portals:__init()
    self._dataList = {}
end

function Portals:Register(xi, yi)
    if self:IsExist(xi, yi) then
        return
    end
    table.insert(self._dataList, PortalEntity.new(xi, yi))
end

function Portals:IsExist(xi, yi)
    return self:GetData(xi, yi) ~= nil
end

function Portals:GetList()
    return self._dataList
end

function Portals:GetData(xi, yi)
    for _, e in ipairs(self._dataList) do
        if e.xi == xi and e.yi == yi then
            return e
        end
    end
    return nil
end

function Portals:Save()
    local resList = {}
    for _, e in ipairs(self._dataList) do
        local elementData = {
            xi = e.xi,
            yi = e.yi,
        }
        table.insert(resList, elementData)
    end
    return {
        list = resList
    }
end

function Portals:Load(data)
    if data.list ~= nil then
        local resList = data.list
        for _, e in ipairs(resList) do
            local xi, yi = e.xi, e.yi
            self:Register(xi, yi)
        end
    end
end

return Portals