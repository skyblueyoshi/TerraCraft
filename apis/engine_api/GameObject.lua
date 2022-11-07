---@class GameObject
---@field transform TransformComponentWrapper
---@field camera CameraComponentWrapper
---@field meshFilter MeshFilterComponentWrapper
---@field meshRenderer MeshRendererComponentWrapper
---@field canvas CanvasComponentWrapper
---@field rigidbody Rigidbody
---@field children table
local GameObject = {}

---
---@return GameObject
function GameObject.instantiate(gameObject)
end

---
---@param gameObject GameObject
function GameObject.destroy(gameObject)
end

function GameObject.flush()
end

---
---@param componentID ComponentID_Value
function GameObject:addComponent(componentID)
end

---
---@param componentID ComponentID_Value
function GameObject:removeComponent(componentID)
end

---
---@param gameObject GameObject
function GameObject:addChild(gameObject)
end

return GameObject