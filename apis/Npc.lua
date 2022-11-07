---@class Npc:Entity NPC class (NPC类)
---@field entityIndex EntityIndex
---@field id int The dynamic ID of the current NPC. (当前NPC的动态ID)
---@field dataWatcher DataWatcher
---@field data table
---@field texture TextureLocation
---@field baseAttack Attack The basic attack property of the current NPC. (当前NPC的基础攻击属性)
---@field maxSpeed double The current maximum movement speed of the NPC. Each update tick is reset to the maximum movement speed determined by the environment (fluid, air, etc.) (当前NPC的最大横向移动速度。每帧重置为所在环境（流体黏性等）决定的最大移动速度)
---@field defaultGravity double @[ Read-only ] The current NPC's default acceleration of gravity. (当前NPC的默认重力加速度)
---@field gravity double The gravity acceleration of the current NPC. Each update tick is reset to the longitudinal acceleration of the environment where the longitudinal force and gravity are applied. (当前NPC的纵向加速度。每帧重置为作用了所在环境纵向受力以及重力后的纵向加速度)
---@field defaultMaxFallSpeed double @[ Read-only ] The default maximum falling speed of the current NPC. (当前NPC的默认最大下落速度)
---@field maxFallSpeed double The current maximum falling speed of the NPC. Each update tick is reset to the maximum falling speed after the longitudinal resistance of the environment is applied. (当前NPC的最大下落速度。每帧重置为作用了所在环境纵向阻力后的最大下落速度)
---@field jumpForce double The jumping strength of the current NPC. Each update tick is reset to the jumping strength after the longitudinal resistance of the environment is applied. (当前NPC的跳跃力度。每帧重置为作用了所在环境纵向阻力后的跳跃力度)
---@field noMove boolean Decide whether the current NPC stops walking. (决定当前NPC是否停止行走)
---@field inLiquid boolean @[ Read-only ] Whether the current NPC is in a fluid environment. (当前NPC是否处在流体环境中)
---@field oldInLiquid boolean @[ Read-only ] Whether the NPC in the previous update tick is in a fluid environment. (上一帧的NPC是否处在流体环境中)
---@field isEnemy boolean @[ Read-only ] Whether the current NPC will hurt the player. (当前NPC是否会伤害玩家)
---@field state int The current state of the NPC in a simple finite state machine. (NPC当前在简单有限状态机中的状态)
---@field stateTimer int The timer use for state machine. (NPC的状态机计时器)
---@field hurry boolean Whether the current NPC is in a hurry. Walking will not stop in a hurry. (当前NPC是否为匆忙状态。匆忙状态下随机走模板不会停下来)
---@field maxHealth int The current upper limit of the NPC's health. (当前NPC的生命值上限)
---@field health int The current health of the NPC. (当前NPC的生命值)
---@field angry boolean Whether the current NPC is in an angry state. An angry NPC will treat the player as a target after being hit by the player, and set the `angry` state to true. (当前NPC是否为愤怒状态。易怒的NPC在被玩家击中后会将该玩家视为目标，并置愤怒状态为true)
---@field animation int The animation state currently executed by the NPC. Usually used to represent the animation state of a skeleton model. (NPC当前执行的动画状态。通常用于表示骨骼模型的动画状态)
---@field animationTickTime int The elapsed time of the NPC in the current animation index. Automatically increment by 1 every update tick, and reset to 0 automatically when the animation state switches. (NPC在当前动画索引所经过的时间。每帧自动自增1，当动画状态切换时自动重置为0)
---@field watchAngle double @[ Read-only ] The NPC's look at angle. If the target exists, npc always look at the target. Otherwise, always look at left or right according to the facing direction. (NPC的目视角度。若NPC目标存在，则总是目视目标。否则总是根据朝向水平目视)
---@field type NpcType @[ Read-only ] The type of NPC. (Enum Format: NPC_TYPE_XXX) (NPC类型)
---@field spawnCount double XXX (占用生成量)
---@field defaultKnockBackDefenseValue double The knock back defense value. (击退抗性)
---@field toolUseRate double The probability of using the tool. (工具使用概率)
---@field maxDisappearTime int The maximum disappearance time when is out of all active areas. (最大消失时间)
---@field defaultDefenseValue int The defense value. (防御力)
---@field defaultAttackValue int How much damage cause when attacking. (攻击力)
---@field defaultCritValue int The percentage of probability that double damage will cause. (双倍暴击率百分比)
---@field defaultKnockBackValue int The knockback force. (击退力)
---@field movement int The movement style. (运动方式)
---@field gfxOffsetX int The texture offset X. (贴图偏移量X)
---@field gfxOffsetY int The texture offset Y. (贴图偏移量Y)
---@field gfxWidth int The texture width. (贴图宽度)
---@field gfxHeight int The texture height. (贴图高度)
---@field frameStyle int Frame style, 0 means no direction, 1 means use left-right direction. (贴图方式 0-不分左右 1-分左右)
---@field exps int The experience value. (经验值)
---@field checkTargetDistance int The radius of detecting targets. (检测目标的半径)
---@field special int The special value for any use. (特殊值)
---@field magicRate int The inverse ratio of the probability of dropping magic fragments. (产生魔法碎片概率的反比)
---@field friendly boolean Is it friendly? (是否友好)
---@field hasGravity boolean Is it affected by gravity? (是否受重力)
---@field canClimbWall boolean Can It climb the wall? (是否能爬墙)
---@field isForeground boolean Is it to the front? (是否置前)
---@field isAntiLava boolean Does it resist lava? (是否抵抗岩浆)
---@field noFixByBlock boolean Does it not fix position when is collided with map? (是否不根据方块修正位置)
---@field willBurnUnderSun boolean Does it burn by itself during the day? (是否白天自燃)
---@field defaultAngry boolean Is it easy to get angry? (是否易怒)
---@field isBoss boolean Is it a BOSS? (是否作为BOSS)
---@field noShowHp boolean Is there no health bar to show? (是否不显示血条)
---@field noBurnSound boolean Does it not play the burning sound effect? (是否不播放燃烧音效)
---@field usingBoneModule boolean @[ Read-only ] Does it use skeleton module? (是否使用骨骼模型)
---@field isCheckPlayerTarget boolean Does it automatically detect player targets? (是否自动检测玩家目标)
---@field isVisionNoCrossTile boolean Can it see through the wall? (是否视野不穿墙)
---@field isAutoSave boolean Can it be saved to the saver? (是否保存到存档)
---@field noHurt boolean
---@field noCollisionByWeapon boolean
---@field noLooting boolean
---@field isWatchAngleForTarget boolean
---@field netUpdate boolean Does it use logical network synchronization? (是否使用逻辑网络同步)
local Npc = {}

--- Destroy current NPC entity without dropping items.
---
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

--- Create a damage to the current NPC.
---
--- 制造一个对当前NPC的伤害。
---@overload fun(attack:Attack)
---@overload fun(attack:Attack,hitAngle:double)
---@overload fun(attack:Attack,hitAngle:double,immune:boolean)
---@overload fun(attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean)
---@overload fun(attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean,lootingLevel:int)
---@param attack Attack The current damage attribute. (当前伤害属性)
---@param hitAngle double @[ default `0.0` ] The angle at which the damage is generated. (产生伤害的角度)
---@param immune boolean @[ default `true` ] Whether the NPC is in an invincible frame state after the current damage is generated. (产生当前伤害后是否让NPC处于无敌帧状态)
---@param hurtSound boolean @[ default `true` ] Whether to play the NPC injury sound effect. (是否播放NPC受伤音效)
---@param lootingLevel int @[ default `0` ] The looting level. (掠夺等级)
function Npc:Strike(attack, hitAngle, immune, hurtSound, lootingLevel)
end

--- Create a damage to the current NPC from player.
---
--- 制造一个某玩家对当前NPC的伤害。
---@overload fun(player:Player,attack:Attack)
---@overload fun(player:Player,attack:Attack,hitAngle:double)
---@overload fun(player:Player,attack:Attack,hitAngle:double,immune:boolean)
---@overload fun(player:Player,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean)
---@overload fun(player:Player,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean,lootingLevel:int)
---@param player Player Represents the player who caused the damage. (表示造成伤害的玩家)
---@param attack Attack The current damage attribute. (当前伤害属性)
---@param hitAngle double @[ default `0.0` ] The angle at which the damage is generated. (产生伤害的角度)
---@param immune boolean @[ default `true` ] Whether the NPC is in an invincible frame state after the current damage is generated. (产生当前伤害后是否让NPC处于无敌帧状态)
---@param hurtSound boolean @[ default `true` ] Whether to play the NPC injury sound effect. (是否播放NPC受伤音效)
---@param lootingLevel int @[ default `0` ] The looting level. (掠夺等级)
function Npc:StrikeFromPlayer(player, attack, hitAngle, immune, hurtSound, lootingLevel)
end

--- Create a damage to the current NPC from other NPC.
---
--- 制造一个某玩家对当前NPC的伤害。
---@overload fun(npc:Npc,attack:Attack)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double,immune:boolean)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean)
---@overload fun(npc:Npc,attack:Attack,hitAngle:double,immune:boolean,hurtSound:boolean,lootingLevel:int)
---@param npc Npc Represents the NPC who caused the damage. (表示造成伤害的NPC)
---@param attack Attack The current damage attribute. (当前伤害属性)
---@param hitAngle double @[ default `0.0` ] The angle at which the damage is generated. (产生伤害的角度)
---@param immune boolean @[ default `true` ] Whether the NPC is in an invincible frame state after the current damage is generated. (产生当前伤害后是否让NPC处于无敌帧状态)
---@param hurtSound boolean @[ default `true` ] Whether to play the NPC injury sound effect. (是否播放NPC受伤音效)
---@param lootingLevel int @[ default `0` ] The looting level. (掠夺等级)
function Npc:StrikeFromNpc(npc, attack, hitAngle, immune, hurtSound, lootingLevel)
end

--- Add a buff to the current NPC.
--- If the buff exists and new buff time greater than old's, use new buff time.
---
--- 为当前NPC添加一个状态效果。若原状态效果存在，以最长时间为新状态效果的持续时间。
---@param buffID int The buff ID. (状态效果ID)
---@param buffTime int The buff duration. (状态效果持续时间)
function Npc:AddBuff(buffID, buffTime)
end

--- Remove a buff from current NPC.
---
--- 移除一个状态效果。
---@param buffID int The buff ID. (状态效果ID)
function Npc:RemoveBuff(buffID)
end

--- Remove all buffs from current NPC.
---
--- 移除全部状态效果。
function Npc:RemoveAllBuff()
end

--- Returns whether the NPC has the target buff.
---
--- 返回NPC是否拥有指定状态效果。
---@param buffID int The buff ID. (状态效果ID)
---@return boolean
function Npc:HasBuff(buffID)
end

--- Returns whether the NPC has a buff.
---
--- 返回NPC是否存在状态效果。
---@return boolean
function Npc:HasAnyBuff()
end

--- The NPC tries to make a normal voice randomly.
--- Sound is emitted once after trying `tryTimes` times on average.
---
--- NPC尝试发出平时声音。平均经过`tryTimes`次发出一次平时声音。
---@param tryTimes int The value.
function Npc:TryMakeSound(tryTimes)
end

--- The NPC makes a normal voice randomly.
---
--- NPC发出平时声音。
function Npc:MakeSound()
end

--- Just stand and no move.
---
--- 站立静止不动。
---@overload fun()
---@param faceToTarget boolean @[ default `true` ] Whether to always face the player. (是否始终面朝玩家)
function Npc:Stand(faceToTarget)
end

--- Randomly walk or stop or turn the direction.
--- Random time within the range of `idleTime ± idleTimeOffset` when it stops.
--- When walking in one direction, continue for a random time
--- within the range of `walkTime ± walkTimeOffset`.
--- This function will use the built-in pathfinding logic,
--- and it will try to jump 3 times when touch a wall.
---
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

--- Keep walking without stopping.
--- This function will use the built-in pathfinding logic,
--- and it will try to jump 3 times when touch a wall.
---
--- 持续行走而不停下。使用内置寻路逻辑，遇到墙壁会尝试跳跃3次。
---@overload fun()
---@param followTarget boolean @[ default `true` ] Represents that if the target exists, it will walk towards the target as possible. (表示在目标存在的情况下，尽可能靠近目标)
function Npc:KeepWalking(followTarget)
end

--- When the target exists, call `KeepWalking(followTarget)`, otherwise call `RandomWalk()`.
---
--- 目标存在时，调用`KeepWalking(followTarget)`，否则调用`RandomWalk()`。
---@overload fun()
---@param followTarget boolean @[ default `true` ] Represents that if the target exists, it will walk towards the target as possible. (表示在目标存在的情况下，尽可能靠近目标)
function Npc:Walk(followTarget)
end

--- Swim in the liquid, bouncing in the air.
--- When the target does not exist, it moves randomly in the liquid.
---
--- 在流体中游泳，在空气中蹦跶。目标不存在时，在流体中随机运动。
---@overload fun()
---@param followTarget boolean @[ default `true` ] Represents that if the target exists, it will walk towards the target as possible. (表示在目标存在的情况下，尽可能靠近目标)
function Npc:Swim(followTarget)
end

--- Flying in the air.
---
--- 在空气中飞行。
---@overload fun()
---@overload fun(followTarget:boolean)
---@overload fun(followTarget:boolean,force:double)
---@param followTarget boolean @[ default `true` ] Represents that if the target exists, it will walk towards the target as possible, otherwise flies randomly. (表示在目标存在的情况下，尽可能靠近目标，否则随机飞行)
---@param force double @[ default '0.1' ] Represents the force to fly towards the target. (表示飞向目标的力)
---@param gradientSpeed boolean @[ default `false` ] Indicates whether to use gradual speed, otherwise the vector length of the speed is always constant. (表示是否使用渐变速度，否则运动速度的向量大小总是恒定的)
function Npc:Fly(followTarget, force, gradientSpeed)
end

--- Send the NPC to a random location in a circular area centered on itself.
---
--- 传送NPC自己到以自己为圆心的圆形区域随机位置。
---@overload fun(distance:int):boolean
---@overload fun(distance:int,noToAir:boolean):boolean
---@param distance int @The radius of the circular area. (圆形区域的半径)
---@param noToAir boolean @[ default `true` ] Represents whether it will be teleported to the ground. (表示是否传送到地面上)
---@param noToLiquid boolean @[ default  true` ] Represents whether it will not be teleported into any liquid. (表示是否不传送到流体内)
---@return boolean Returns true if teleport success, otherwise returns false. (成功传送返回true，失败返回false)
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