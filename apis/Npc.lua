---@API

---@class Npc:Entity 描述一个NPC实体。
---@field entityIndex EntityIndex
---@field id int 当前NPC的动态ID。
---@field dataWatcher DataWatcher
---@field data table
---@field texture TextureLocation
---@field baseAttack Attack 当前NPC的基础攻击属性。
---@field maxSpeed double 当前NPC的最大横向移动速度。每帧重置为所在环境（流体黏性等）决定的最大移动速度。
---@field defaultGravity double Read-only 当前NPC的默认重力加速度。
---@field gravity double 当前NPC的纵向加速度。每帧重置为作用了所在环境纵向受力以及重力后的纵向加速度。
---@field defaultMaxFallSpeed double Read-only 当前NPC的默认最大下落速度。
---@field maxFallSpeed double 当前NPC的最大下落速度。每帧重置为作用了所在环境纵向阻力后的最大下落速度。
---@field jumpForce double 当前NPC的跳跃力度。每帧重置为作用了所在环境纵向阻力后的跳跃力度。
---@field noMove boolean 决定当前NPC是否停止行走。
---@field inLiquid boolean Read-only 当前NPC是否处在流体环境中。
---@field oldInLiquid boolean Read-only 上一帧的NPC是否处在流体环境中。
---@field isEnemy boolean Read-only 当前NPC是否会伤害玩家。
---@field state int NPC当前在简单有限状态机中的状态。
---@field stateTimer int NPC的状态机计时器。
---@field hurry boolean 当前NPC是否为匆忙状态。匆忙状态下随机走模板不会停下来。
---@field maxHealth int 当前NPC的生命值上限。
---@field health int 当前NPC的生命值。
---@field angry boolean 当前NPC是否为愤怒状态。易怒的NPC在被玩家击中后会将该玩家视为目标，并置愤怒状态为true。
---@field animation int NPC当前执行的动画状态。通常用于表示骨骼模型的动画状态。
---@field animationTickTime int NPC在当前动画索引所经过的时间。每帧自动自增1，当动画状态切换时自动重置为0。
---@field watchAngle double Read-only NPC的目视角度。若NPC目标存在，则总是目视目标。否则总是根据朝向水平目视。
---@field type NpcType Read-only NPC类型。
---@field spawnCount double 占用生成量。
---@field defaultKnockBackDefenseValue double 击退抗性。
---@field toolUseRate double 工具使用概率。
---@field maxDisappearTime int 最大消失时间。
---@field defaultDefenseValue int 防御力。
---@field defaultAttackValue int 攻击力。
---@field defaultCritValue int 双倍暴击率百分比。
---@field defaultKnockBackValue int 击退力。
---@field movement int 运动方式。
---@field gfxOffsetX int 贴图偏移量X。
---@field gfxOffsetY int 贴图偏移量Y。
---@field gfxWidth int 贴图宽度。
---@field gfxHeight int 贴图高度。
---@field frameStyle int 贴图方式 0-不分左右 1-分左右。
---@field exps int 经验值。
---@field checkTargetDistance int 检测目标的半径。
---@field special int 特殊值。
---@field magicRate int 产生魔法碎片概率的反比。
---@field friendly boolean 是否友好。
---@field hasGravity boolean 是否受重力。
---@field canClimbWall boolean 是否能爬墙。
---@field isForeground boolean 是否置前。
---@field isAntiLava boolean 是否抵抗岩浆。
---@field noFixByBlock boolean 是否不根据方块修正位置。
---@field willBurnUnderSun boolean 是否白天自燃。
---@field defaultAngry boolean 是否易怒。
---@field isBoss boolean 是否作为BOSS。
---@field noShowHp boolean 是否不显示血条。
---@field noBurnSound boolean 是否不播放燃烧音效。
---@field usingBoneModule boolean Read-only 是否使用骨骼模型。
---@field isCheckPlayerTarget boolean 是否自动检测玩家目标。
---@field isVisionNoCrossTile boolean 是否视野不穿墙。
---@field isAutoSave boolean 是否保存到存档。
---@field noHurt boolean
---@field noCollisionByWeapon boolean
---@field noLooting boolean
---@field isWatchAngleForTarget boolean
---@field netUpdate boolean 是否使用逻辑网络同步。
local Npc = {}

--- 不掉落物品直接清除当前NPC对象。
function Npc:Kill()
end

---KillByStrike
---@overload fun(hitAngle:double)
---@overload fun(hitAngle:double,hurtSound:boolean)
---@param hitAngle double
---@param hurtSound boolean
---@param lootingLevel int
function Npc:KillByStrike(hitAngle, hurtSound, lootingLevel)
end

--- 制造一个对当前NPC的伤害。
---@overload fun(attack:Attack)
---@overload fun(attack:Attack,hitAngle:double)
---@overload fun(attack:Attack,hitAngle:double,immune:boolean)
---@overload fun(attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean)
---@overload fun(attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean,lootingLevel:int)
---@param attack Attack 当前伤害属性。
---@param hitAngle double @[ default `0.0` ] 产生伤害的角度。
---@param immune boolean @[ default `true` ] 产生当前伤害后是否让NPC处于无敌帧状态。
---@param hurtSound boolean @[ default `true` ] 是否播放NPC受伤音效。
---@param lootingLevel int @[ default `0` ] 掠夺等级。
function Npc:Strike(attack, hitAngle, immune, hurtSound, lootingLevel)
end

--- 制造一个某玩家对当前NPC的伤害。
---@overload fun(player:Player,attack:Attack)
---@overload fun(player:Player,attack:Attack,hitAngle:double)
---@overload fun(player:Player,attack:Attack,hitAngle:double,immune:boolean)
---@overload fun(player:Player,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean)
---@overload fun(player:Player,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean,lootingLevel:int)
---@param player Player 表示造成伤害的玩家。
---@param attack Attack 当前伤害属性。
---@param hitAngle double @[ default `0.0` ] 产生伤害的角度。
---@param immune boolean @[ default `true` ] 产生当前伤害后是否让NPC处于无敌帧状态。
---@param hurtSound boolean @[ default `true` ] 是否播放NPC受伤音效。
---@param lootingLevel int @[ default `0` ] 掠夺等级。
function Npc:StrikeFromPlayer(player, attack, hitAngle, immune, hurtSound, lootingLevel)
end

--- 制造一个某玩家对当前NPC的伤害。
---@overload fun(npc:Npc,attack:Attack)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double,immune:boolean)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean,lootingLevel:int)
---@param npc Npc 表示造成伤害的NPC。
---@param attack Attack 当前伤害属性。
---@param hitAngle double @[ default `0.0` ] 产生伤害的角度。
---@param immune boolean @[ default `true` ] 产生当前伤害后是否让NPC处于无敌帧状态。
---@param hurtSound boolean @[ default `true` ] 是否播放NPC受伤音效。
---@param lootingLevel int @[ default `0` ] 掠夺等级。
function Npc:StrikeFromNpc(npc, attack, hitAngle, immune, hurtSound, lootingLevel)
end

--- 为当前NPC添加一个状态效果。若原状态效果存在，以最长时间为新状态效果的持续时间。
---@param buffID int 状态效果ID。
---@param buffTime int 状态效果持续时间。
function Npc:AddBuff(buffID, buffTime)
end

--- 移除一个状态效果。
---@param buffID int
function Npc:RemoveBuff(buffID)
end

--- 移除全部状态效果。
function Npc:RemoveAllBuff()
end

--- 返回NPC是否拥有指定状态效果。
---@param buffID int 状态效果ID。
---@return boolean
function Npc:HasBuff(buffID)
end

--- 返回NPC是否存在状态效果。
---@return boolean
function Npc:HasAnyBuff()
end

--- NPC尝试发出平时声音。平均经过`tryTimes`次发出一次平时声音。
---@param tryTimes int
function Npc:TryMakeSound(tryTimes)
end

--- NPC发出平时声音。
function Npc:MakeSound()
end

--- 站立静止不动。
---@overload fun()
---@param faceToTarget boolean @[ default `true` ] 是否始终面朝玩家。
function Npc:Stand(faceToTarget)
end

--- 随机地朝一个方向行走或停下或转弯。
--- 停下时闲置`idleTime ± idleTimeOffset`范围内随机时间。
--- 朝一个方向行走时持续`walkTime ± walkTimeOffset`范围内随机时间。
--- 使用内置寻路逻辑，遇到墙壁会尝试跳跃3次。
---@overload fun()
---@overload fun(idleTime:int)
---@overload fun(idleTime:int,idleTimeOffset:int)
---@overload fun(idleTime:int,idleTimeOffset:int,walkTime:int)
---@param idleTime int @[ default `128` ]
---@param idleTimeOffset int @[ default `64` ]
---@param walkTime int @[ default `96` ]
---@param walkTimeOffset int @[ default `32` ]
function Npc:RandomWalk(idleTime, idleTimeOffset, walkTime, walkTimeOffset)
end

--- 持续行走而不停下。使用内置寻路逻辑，遇到墙壁会尝试跳跃3次。
---@overload fun()
---@param followTarget boolean @[ default `true` ] 表示在目标存在的情况下，尽可能靠近目标。
function Npc:KeepWalking(followTarget)
end

--- 目标存在时，调用`KeepWalking(followTarget)`，否则调用`RandomWalk()`。
---@overload fun()
---@param followTarget boolean @[ default `true` ] 表示在目标存在的情况下，尽可能靠近目标。
function Npc:Walk(followTarget)
end

--- 在流体中游泳，在空气中蹦跶。目标不存在时，在流体中随机运动。
---@overload fun()
---@param followTarget boolean @[ default `true` ] 表示在目标存在的情况下，尽可能靠近目标。
function Npc:Swim(followTarget)
end

--- 在空气中飞行。
---@overload fun()
---@overload fun(followTarget:boolean)
---@overload fun(followTarget:boolean,force:double)
---@param followTarget boolean @[ default `true` ] 表示在目标存在的情况下，尽可能靠近目标，否则随机飞行。
---@param force double @[ default '0.1' ] 表示飞向目标的力。
---@param gradientSpeed boolean @[ default `false` ] 表示是否使用渐变速度，否则运动速度的向量大小总是恒定的。
function Npc:Fly(followTarget, force, gradientSpeed)
end

--- 传送NPC自己到以自己为圆心的圆形区域随机位置。
---@overload fun(distance:int):boolean
---@overload fun(distance:int,noToAir:boolean):boolean
---@param distance int 圆形区域的半径。
---@param noToAir boolean @[ default `true` ] 表示是否传送到地面上。
---@param noToLiquid boolean @[ default  true` ] 表示是否不传送到流体内。
---@return boolean 成功传送返回true，失败返回false。
function Npc:RandomTeleport(distance, noToAir, noToLiquid)
end

---
---
---@return ModNpc
function Npc:GetModNpc()
end

---
---
---@param globalNpcName string
---@return GlobalNpc
function Npc:GetGlobalNpc(globalNpcName)
end

function Npc:SyncAll()
end

return Npc