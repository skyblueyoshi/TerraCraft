---@API

---@class Entity 描述一个基本实体类。
---@field x double 实体左上角x坐标。
---@field y double 实体左上角y坐标。
---@field centerX double Read-only 返回实体正中间x坐标。
---@field centerY double Read-only 返回实体正中间y坐标。
---@field centerXi int Read-only 返回实体正中间格子横坐标。
---@field centerYi int Read-only 返回实体正中间格子纵坐标。
---@field rightX double Read-only 返回实体最右侧x坐标。
---@field bottomY double Read-only 返回实体最底部y坐标。
---@field speedX double 实体横向速度。
---@field speedY double 实体纵向速度。
---@field gravity double 实体的重力加速度。
---@field width int Read-only 返回实体碰撞箱宽度。
---@field height int Read-only 返回实体碰撞箱高度。
---@field direction boolean 实体面朝右侧为true,面朝左侧为false。
---@field rotateAngle double 实体碰撞箱的旋转角度。
---@field speedAngle double Read-only 返回当前实体运动速度的向量夹角。
---@field randX double Read-only 返回实体在x轴投影上的随机坐标。
---@field randY double Read-only 返回实体在y轴投影上的随机坐标。
---@field shape Shape Read-only 返回实体碰撞箱形状。
---@field stand boolean Read-only 返回实体是否为站立状态。
---@field isCollisionTop boolean Read-only 返回实体是否顶部发生碰撞。
---@field isCollisionLeft boolean Read-only 返回实体是否左侧发生碰撞。
---@field isCollisionRight boolean Read-only 返回实体是否右侧发生碰撞。
---@field isCollisionStuck boolean Read-only 返回实体是否卡在方块内部。
---@field isNoCollision boolean Read-only 返回实体是否没有发生任何形式的碰撞。
---@field onSlope boolean Read-only 返回实体是否站在斜坡上。
---@field hitbox Hitbox Read-only 若实体为轴对齐矩形，返回轴对齐碰撞箱，否则返回旋转矩形碰撞箱。
---@field aabb Hitbox Read-only 实体旋转角度为0的轴对齐碰撞箱。
---@field minAABB Hitbox Read-only 完全包裹实体的最小轴对齐碰撞箱。
---@field allowCheckCollision boolean 决定是否执行与方块的碰撞检测。
---@field spriteDefaultWidth int Read-only 实体默认绘制宽度。
---@field spriteDefaultHeight int Read-only 实体默认绘制高度。
---@field spriteRect Rectangle 表示实体绘制时在目标贴图的剪裁区域。
---@field spriteEx SpriteEx 实体绘制时的精灵拓展信息。
---@field spriteOffsetX int @[ default `0.0` ] 实体绘制的横向偏移量。
---@field spriteOffsetY int @[ default `0.0` ] 实体绘制的纵向偏移量。
---@field color Color @[ default `COLOR_WHITE` ] 实体绘制时的颜色。
---@field frameTickTime int 实体绘制用的帧计时器，每帧自增1。
---@field frameIndex int Read-only 当前实体帧索引。
---@field frameStyles int Read-only 实体样式数。
---@field frames int Read-only 实体总帧数。
---@field frameSpeed int Read-only 实体帧切换周期。
---@field tickTime int Read-only 实体的实际生存的时间。
---@field randSeed int Read-only 实体的随机数种子。
local Entity = {}

--- 将实体中心x坐标设为指定位置。
---@param newCenterX double
function Entity:SetCenterX(newCenterX)
end

--- 将实体中心y坐标设为指定位置。
---@param newCenterY double
function Entity:SetCenterY(newCenterY)
end

--- 返回实体中心点到目标点的角度。
---@param desX double 目标点x坐标。
---@param desY double 目标点y坐标。
---@return double
function Entity:GetAngleTo(desX, desY)
end

--- 返回来源点到实体中心点的角度。
---@param srcX double 来源点x坐标。
---@param srcY double 来源点y坐标。
---@return double
function Entity:GetAngleFrom(srcX, srcY)
end

--- 返回实体中心到指定点的距离。
---@param otherX double 目标点x坐标。
---@param otherX double 目标点y坐标。
---@return double
function Entity:GetDistance(otherX, otherY)
end

--- 在原有角度基础上继续旋转指定角度。
---@param angle double 旋转的角度。
function Entity:Rotate(angle)
end

--- 在原有速度角度基础上继续旋转指定速度角度。
---@param angle double 旋转的角度。
function Entity:RotateSpeed(angle)
end

return Entity