local Drill = class("Drill", ModItem)

--local e_fire_smoke = Reg.EffectID("fire_smoke")
--
--function Drill:OnUseFromPlayer(itemSlot, player, hitbox, fireX, fireY)
--    if player.tickTime % 4 == 0 then
--        EffectUtils.Create(e_fire_smoke, fireX, fireY, Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(0.05),
--            Utils.RandDoubleArea(0.5, 0.5))
--    end
--end
--
--function Drill:OnUseFromNpc(itemSlot, npc, hitbox, fireX, fireY)
--    if npc.tickTime % 4 == 0 then
--        EffectUtils.Create(e_fire_smoke, fireX, fireY, Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(0.05),
--            Utils.RandDoubleArea(0.5, 0.5))
--    end
--end

return Drill