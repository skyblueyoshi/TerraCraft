---@class InfBow:TC.BaseRangedWeapon
local InfBow = class("InfBow", require("BaseRangedWeapon"))

function InfBow:IsCheckingConsume(player)
    return false
end

function InfBow:NeedAttachItemToProjectile(player)
    return false
end

return InfBow