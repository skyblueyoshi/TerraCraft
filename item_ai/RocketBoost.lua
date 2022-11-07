---@class TC.RocketBoost:TC.BaseAccessory
local RocketBoost = class("RocketBoost", require("BaseAccessory"))
local GPlayer = require("player.GPlayer")
local PlayerConstants = require("player.PlayerConstants")

function RocketBoost:Init()
    self.flying = false
    self.flyingTime = 0
    self.flyingTimeMax = 128
end

---OnAccessory
---@param player Player
function RocketBoost:OnAccessoryUpdate(player)
    if NetMode.current == NetMode.Client then
        local gPlayer = GPlayer.GetInstance(player)
        self.flyingTimeMax = 128
        self:FlyMove(player)

        if self.flying then
            local fts = {
                gPlayer.bone.joints:getJoint("base.body.front_leg.front_feet"),
                gPlayer.bone.joints:getJoint("base.body.back_leg.back_feet")
            }

            for i = 1, 2 do
                local c = fts[i].transform.worldMatrix:transformVector2(Vector2.new(4, 16))

                local effect = EffectUtils.Create(
                        Reg.EffectID("fire_smoke"),
                        c.x,
                        c.y,
                        Utils.RandSym(0.5),
                        1 + Utils.RandSym(0.5),
                        Utils.RandSym(0.5),
                        Utils.RandDoubleArea(0.55, 0.15),
                        1.0,
                        Color.new(255, 255, 255)
                )
                effect:SetDisappearTime(50)

                if player.tickTime % 4 == 0 then
                    EffectUtils.Create(
                            Reg.EffectID("fire_flame"),
                            c.x,
                            c.y,
                            Utils.RandSym(0.5),
                            0.5 + Utils.RandSym(0.5),
                            Utils.RandSym(0.5),
                            Utils.RandDoubleArea(0.55, 0.15),
                            1.0,
                            Color.new(255, 255, 255)
                    )
                end
            end
        end
    end
end

function RocketBoost:FlyMove(player)
    local gPlayer = GPlayer.GetInstance(player)
    if not gPlayer.jump then
        self.flying = false
    end
    if player.stand then
        self.flying = false
        self.flyingTime = 0
        return
    end
    if player.speedY > 0.5 then
        if gPlayer.jump then
            self.flying = true
        end
    end
    if self.flying then
        self.flyingTime = self.flyingTime + 1
        if self.flyingTime > self.flyingTimeMax then
            self.flying = false
            return
        end
        player.speedY = player.speedY - 0.8
        if player.speedY < -PlayerConstants.MAX_SPEED_UP / 2 then
            player.speedY = -PlayerConstants.MAX_SPEED_UP / 2
        end
    end
end

return RocketBoost