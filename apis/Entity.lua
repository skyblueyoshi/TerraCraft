---@class Entity @Entity class(实体类)
---@field public x double @The x coordinate of the upper left corner of the entity. (实体左上角x坐标)
---@field public y double @The y coordinate of the upper left corner of the entity. (实体左上角y坐标)
---@field public centerX double @[ Read-only ] Returns the center x coordinate of the entity. (返回实体正中间x坐标)
---@field public centerY double @[ Read-only ] Returns the center y coordinate of the entity. (返回实体正中间y坐标)
---@field public centerXi int @[ Read-only ] Returns the center grid x index of the entity. (返回实体正中间格子横坐标)
---@field public centerYi int @[ Read-only ] Returns the center grid y index of the entity. (返回实体正中间格子纵坐标)
---@field public rightX double @[ Read-only ] Returns the x coordinate of the right border of entity. (返回实体最右侧x坐标)
---@field public bottomY double @[ Read-only ] Returns the y coordinate of the bottom border of entity. (返回实体最底部y坐标)
---@field public speedX double @The horizontal speed of the entity. (实体横向速度)
---@field public speedY double @The vertical speed of the entity. (实体纵向速度)
---@field public gravity double @The gravitational acceleration of the entity. (实体的重力加速度)
---@field public width int @[ Read-only ] Returns the width of the hitbox. (返回实体碰撞箱宽度)
---@field public height int @[ Read-only ] Returns the height of the hitbox. (返回实体碰撞箱高度)
---@field public direction boolean @Facing right if true, otherwise facing left. (实体面朝右侧为true,面朝左侧为false)
---@field public rotateAngle double @The rotation angle of the hitbox. (实体碰撞箱的旋转角度)
---@field public speedAngle double @[ Read-only ] Returns the vector angle of the current speed. (返回当前实体运动速度的向量夹角)
---@field public randX double @[ Read-only ] Return the random coordinates of the entity on the x-axis projection. (返回实体在x轴投影上的随机坐标)
---@field public randY double @[ Read-only ] Return the random coordinates of the entity on the y-axis projection. (返回实体在y轴投影上的随机坐标)
---@field public shape Shape @[ Read-only ] Returns the shape of the hitbox. (Enum format: `SHAPE_XXX`) (返回实体碰撞箱形状)
---@field public stand boolean @[ Read-only ] Returns whether the entity is standing. (返回实体是否为站立状态)
---@field public isCollisionTop boolean @[ Read-only ] Returns whether the top of the entity collides with the map. (返回实体是否顶部发生碰撞)
---@field public isCollisionLeft boolean @[ Read-only ] Returns whether the left of the entity collides with the map. (返回实体是否左侧发生碰撞)
---@field public isCollisionRight boolean @[ Read-only ] Returns whether the right of the entity collides with the map. (返回实体是否右侧发生碰撞)
---@field public isCollisionStuck boolean @[ Read-only ] Returns whether the entity is stuck inside the block. (返回实体是否卡在方块内部)
---@field public isNoCollision boolean @[ Read-only ] Returns whether the entity has not collided in any form. (返回实体是否没有发生任何形式的碰撞)
---@field public onSlope boolean @[ Read-only ] Returns whether the entity is standing on the slope. (返回实体是否站在斜坡上)
---@field public hitbox Hitbox @[ Read-only ] If the entity is an axis-aligned rectangle, returns an axis-aligned hitbox, otherwise returns a rotating rectangular collision box. (若实体为轴对齐矩形，返回轴对齐碰撞箱，否则返回旋转矩形碰撞箱)
---@field public aabb Hitbox @[ Read-only ] The axis-aligned hitbox when rotation angle is 0. (实体旋转角度为0的轴对齐碰撞箱)
---@field public minAABB Hitbox @[ Read-only ] The smallest axis-aligned hitbox that completely wraps the entity. (完全包裹实体的最小轴对齐碰撞箱)
---@field public allowCheckCollision boolean @Decide whether to check collision detection with the map. (决定是否执行与方块的碰撞检测)
---@field public spriteDefaultWidth int @[ Read-only ] The default drawing width of the entity. (实体默认绘制宽度)
---@field public spriteDefaultHeight int @[ Read-only ] The default drawing height of the entity. (实体默认绘制高度)
---@field public spriteRect Rectangle Represents the clipping area of the target texture when the entity is drawn. (表示实体绘制时在目标贴图的剪裁区域)
---@field public spriteEx SpriteEx Sprite extension information when the entity is drawn. (实体绘制时的精灵拓展信息)
---@field public spriteOffsetX int @[ default `0.0` ] The horizontal offset of the entity drawing. (实体绘制的横向偏移量)
---@field public spriteOffsetY int @[ default `0.0` ] The vertical offset of the entity drawing. (实体绘制的纵向偏移量)
---@field public color Color @[ default `COLOR_WHITE` ] The color of the entity when it is drawn. (实体绘制时的颜色)
---@field public frameTickTime int The frame timer for entity drawing, increments by 1 every update tick. (实体绘制用的帧计时器，每帧自增1)
---@field public frameIndex int @[ Read-only ] The frame index. Which is `(frameTickTime / frameSpeed) % frames` in C++.  (当前实体帧索引)
---@field public frameStyles int @[ Read-only ] The total of entity frame styles. (实体样式数)
---@field public frames int @[ Read-only ] The total of entity frames in one loop. (实体总帧数)
---@field public frameSpeed int @[ Read-only ] How many ticks to switch frames. (实体帧切换周期)
---@field public tickTime int @[ Read-only ] The actual survival time of the entity, increments by 1 every update tick when survival. (实体的实际生存的时间)
---@field public randSeed int @[ Read-only ] The random seed of current entity. (实体的随机数种子)
local Entity = {}

--- Set the x coordinate of the center of the entity.
---
--- 将实体中心x坐标设为指定位置。
---@param newCenterX double
function Entity:SetCenterX(newCenterX)
end

--- Set the y coordinate of the center of the entity.
---
--- 将实体中心y坐标设为指定位置。
---@param newCenterY double
function Entity:SetCenterY(newCenterY)
end

--- Returns the angle from the center point of the entity to the target point.
---
--- 返回实体中心点到目标点的角度。
---@param desX double The x coordinate of the target point. (目标点x坐标)
---@param desY double The y coordinate of the target point. (目标点y坐标)
---@return double
function Entity:GetAngleTo(desX, desY)
end

--- Returns the angle from the source point to the center point of the entity.
---
--- 返回来源点到实体中心点的角度。
---@param srcX double The x coordinate of the source point. (来源点x坐标)
---@param srcY double The y coordinate of the source point. (来源点y坐标)
---@return double
function Entity:GetAngleFrom(srcX, srcY)
end

--- Returns the distance from the center of the entity to the specified point.
---
--- 返回实体中心到指定点的距离。
---@param otherX double The x coordinate of the specified point. (目标点x坐标)
---@param otherX double The y coordinate of the specified point. (目标点y坐标)
---@return double
function Entity:GetDistance(otherX, otherY)
end

--- Continue to rotate the specified angle based on the original angle.
---
--- 在原有角度基础上继续旋转指定角度。
---@param angle double The specified angle. (旋转的角度)
function Entity:Rotate(angle)
end

--- Continue to rotate the specified speed angle based on the original speed angle.
---
--- 在原有速度角度基础上继续旋转指定速度角度。
---@param angle double The specified angle. (旋转的角度)
function Entity:RotateSpeed(angle)
end

return Entity