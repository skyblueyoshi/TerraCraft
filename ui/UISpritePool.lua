---@class TC.UISpritePool
local UISpritePool = class("UISpritePool")

local s_uiSpritePool = nil
---@return TC.UISpritePool
function UISpritePool.getInstance()
    if s_uiSpritePool == nil then
        s_uiSpritePool = UISpritePool.new()
    end
    return s_uiSpritePool
end

function UISpritePool:__init()
    self._pool = {}
end

---add
---@param name string
---@param sprite UISprite
function UISpritePool:add(name, sprite)
    self._pool[name] = sprite:clone()
end

---@param name string
---@return boolean
function UISpritePool:has(name)
    return self._pool[name] ~= nil
end

---get
---@param name string
---@return UISprite
function UISpritePool:get(name)
    local sprite = self._pool[name]
    assert(sprite ~= nil, "cannot find " .. name .. " in UISpritePool.")
    return sprite:clone()
end

function UISpritePool:clear()
    for k in pairs(self._pool) do
        self._pool[k] = nil
    end
end

return UISpritePool