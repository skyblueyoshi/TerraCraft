---@class TC.Sword:TC.BaseTool
local Sword = class("Sword", require("BaseTool"))
local GPlayer = require("player.GPlayer")

local USE_DECREASE_DURABLE = 0.5

function Sword:Init()
    self.wasSwingAtCenter = false
end

function Sword:OnHeld(player)

end

function Sword:IsKilledAfterUsed()
    return self.itemStack.durable <= 0
end

function Sword:OnKilledAfterUsed(player)
    SoundUtils.PlaySound(Reg.SoundID("broken"), player.centerXi, player.centerYi)
end

function Sword:OnUsedByNpc(npc)
    local modNpc = npc:GetModNpc()
    if modNpc == nil or modNpc.GetHeldItemJoint == nil then
        return
    end
    local itemJoint = modNpc:GetHeldItemJoint()

    local attack = npc.baseAttack
    local resPlayerIndex = EntityIndex.new()
    local isHitPlayer = PlayerUtils.WeaponCollide(self.itemStack, 0, itemJoint:getWorldObb(), attack, resPlayerIndex)

    if isHitPlayer then
        local player = PlayerUtils.Get(resPlayerIndex)
        local hitAngle = 0.0
        if not npc.direction then
            hitAngle = math.pi
        end
        player:StrikeFromNpc(npc, attack, hitAngle, true)
    end
end

function Sword:OnUsed(player)
    local item = self.itemStack:GetItem()
    local globalPlayer = GPlayer.GetInstance(player)
    local itemJoint = globalPlayer:GetHeldItemJoint()
    if globalPlayer.currentActionTick == 0 then
        self.wasSwingAtCenter = false
        SoundUtils.PlaySound(Reg.SoundID("weapon"), player.centerXi, player.centerYi)
    elseif globalPlayer.currentActionTick > 0.05 then
        -- destroy the map block
        local hitSolid, hasBlockDestroyed = MapUtils.WeaponCollideWithMap(itemJoint:getWorldObb(), true)
        if not hitSolid then
            local attack = player.baseAttack
            local resNpcIndex = EntityIndex.new()
            local hitNpc = NpcUtils.WeaponCollide(self.itemStack, 0,
                    itemJoint:getWorldObb(), attack, resNpcIndex)

            if hitNpc then
                local npc = NpcUtils.Get(resNpcIndex)
                local hitAngle = 0.0
                if not player.direction then
                    hitAngle = math.pi
                end
                local looting = self.itemStack:GetEnchantmentLevel(Reg.EnchantmentID("looting"))
                npc:StrikeFromPlayer(player, attack, hitAngle, true, true, looting)

                if NetMode.current == NetMode.Server then
                    -- TODO 耐久在创造模式不减
                    if USE_DECREASE_DURABLE > 0 then
                        self.itemStack:LoseDurable(USE_DECREASE_DURABLE)
                    end
                end
            end

            if not self.wasSwingAtCenter and globalPlayer.currentActionTick > 0.5 then
                self.wasSwingAtCenter = true
                if item.consumeMana > 0 and item.shootProjectileID > 0 then
                    if player.mana >= item.consumeMana then
                        player.mana = math.max(0, player.mana - item.consumeMana)
                        local cx, cy = player.centerX, player.centerY
                        local realShootAngle = not player.direction and math.pi or 0
                        local proj = ProjectileUtils.CreateFromPlayer(player, item.shootProjectileID,
                                cx, cy,
                                math.cos(realShootAngle) * item.speed,
                                math.sin(realShootAngle) * item.speed,
                                attack)
                        proj.isCheckNpc = true
                    end
                end
            end
        end

        -- test
        if false and NetMode.current == NetMode.Client then
            local tp = itemJoint.transform.worldMatrix:transformVector2(self.itemStack:GetItem():GetFirePoint(0))
            local effect = EffectUtils.Create(Reg.EffectID("circle"), tp.x, tp.y,
                    0, 0,
                    0, 0.2)

        end
    end

end

function Sword:DrawIcon(position, color, spriteExData)
    self:_DrawIconRotated(position, color, spriteExData)
end

--function Sword:Save()
--    return {
--        test = 123,
--        word = "hello world"
--    }
--end
--
--function Sword:Load(tagTable)
--    --print(tagTable.test, tagTable.word)
--end

return Sword