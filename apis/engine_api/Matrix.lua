---@API

---@class Matrix 描述一个4x4矩阵。
---@field m11 number
---@field m12 number
---@field m13 number
---@field m14 number
---@field m21 number
---@field m22 number
---@field m23 number
---@field m24 number
---@field m31 number
---@field m32 number
---@field m33 number
---@field m34 number
---@field m41 number
---@field m42 number
---@field m43 number
---@field m44 number
---@field up Vector3 上向量{M21, M22, M23}。
---@field down Vector3 下向量{-M21, -M22, -M23}。
---@field left Vector3 左向量{-M11, -M12, -M13}。
---@field right Vector3 右向量{M11, M12, M13}。
---@field forward Vector3 前向量{-M31, -M32, -M33}。
---@field backward Vector3 前向量{-M31, -M32, -M33}。
---@field translation Vector3 存储坐标{M41, M42, M43}。
---@field identity Matrix 返回单位矩阵。
local Matrix = {}

---
---@overload fun():Matrix
---@overload fun(row1:Vector4,row2:Vector4,row3:Vector4,row4:Vector4):Matrix
---@param m11 number
---@param m12 number
---@param m13 number
---@param m14 number
---@param m21 number
---@param m22 number
---@param m23 number
---@param m24 number
---@param m31 number
---@param m32 number
---@param m33 number
---@param m34 number
---@param m41 number
---@param m42 number
---@param m43 number
---@param m44 number
---@return Matrix
function Matrix.new(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
end

---@param value Matrix
---@return Matrix
function Matrix.clone(value)
end

---转置矩阵，即行列交换。
---@return Matrix
function Matrix:transpose()
end

---返回包含指定矩阵中值的线性插值矩阵。
---@param matrix Matrix 原始矩阵。
---@param amount number 插值。
---@return Matrix
function Matrix:lerp(matrix, amount)
end

---矩阵逆变换。
---@return Matrix
function Matrix:invert()
end

---求矩阵行列式。
---@return number
function Matrix:determinant()
end

---
---@param position Vector2
---@return Vector2
function Matrix:transformVector2(position)
end

---
---@param position Vector3
---@return Vector3
function Matrix:transformVector3(position)
end

---
---@param vector4 Vector4
---@return Vector4
function Matrix:transformVector4(vector4)
end

---
---@param vector3 Vector3
---@return Vector4
function Matrix:transformVector4(vector3)
end

---
---@param vector2 Vector2
---@return Vector4
function Matrix:transformVector4(vector2)
end

---构造一个View矩阵。
---@param cameraPosition Vector3 摄像机坐标。
---@param cameraTarget Vector3 摄像机目标向量。
---@param cameraUpVector Vector3 摄像机上边缘方向。
---@return Matrix
function Matrix.createLookAt(cameraPosition, cameraTarget, cameraUpVector)
end

---构造一个透视投影矩阵。
---@param fieldOfView number y轴方向上的视场角度（弧度制）。
---@param aspectRatio number 视景体的宽度与高度之比。
---@param nearPlaneDistance number 沿z轴方向的两截面之间距离的近处。
---@param farPlaneDistance number 沿z轴方向的两截面之间距离的远处。
---@return Matrix
function Matrix.createPerspectiveFOV(fieldOfView, aspectRatio, nearPlaneDistance, farPlaneDistance)
end

---构造一个正视投影矩阵。
---@param width number 视图宽度。
---@param height number 视图高度。
---@param zNearPlane number 近平面深度。
---@param zFarPlane number 远平面深度
---@return Matrix
function Matrix.createOrthographicRH(width, height, zNearPlane, zFarPlane)
end

---构造一个正视投影矩阵。
---@param left number 投影区域最小x坐标。
---@param right number 投影区域最大x坐标。
---@param bottom number 投影区域最大y坐标。
---@param top number 投影区域最小y坐标。
---@param zNearPlane number 近平面深度。
---@param zFarPlane number 远平面深度。
---@return Matrix
function Matrix.createOrthographicRH(left, right, bottom, top, zNearPlane, zFarPlane)
end

---构造一个正视投影矩阵。
---@param width number 视图宽度。
---@param height number 视图高度。
---@param zNearPlane number 近平面深度。
---@param zFarPlane number 远平面深度。
---@return Matrix
function Matrix.createOrthographicLH(width, height, zNearPlane, zFarPlane)
end

---构造一个正视投影矩阵。
---@param left number 投影区域最小x坐标。
---@param right number 投影区域最大x坐标。
---@param bottom number 投影区域最大y坐标。
---@param top number 投影区域最小y坐标。
---@param zNearPlane number 近平面深度。
---@param zFarPlane number 远平面深度。
---@return Matrix
function Matrix.createOrthographicLH(left, right, bottom, top, zNearPlane, zFarPlane)
end

---构造一个绕X轴旋转的矩阵。
---@param radians number 旋转弧度。
---@return Matrix
function Matrix.createRotationX(radians)
end

---构造一个绕Y轴旋转的矩阵。
---@param radians number 旋转弧度。
---@return Matrix
function Matrix.createRotationY(radians)
end

---构造一个绕Z轴旋转的矩阵。
---@param radians number 旋转弧度。
---@return Matrix
function Matrix.createRotationZ(radians)
end

---构造一个放缩矩阵。
---@param scale number XYZ轴的放缩大小。
---@return Matrix
function Matrix.createScale(scale)
end

---构造一个放缩矩阵。
---@param scaleX number X轴的放缩大小。
---@param scaleY number Y轴的放缩大小。
---@param scaleZ number Z轴的放缩大小。
---@return Matrix
function Matrix.createScale(scaleX, scaleY, scaleZ)
end

---构造一个放缩矩阵。
---@param scales Vector3 XYZ轴的放缩向量。
---@return Matrix
function Matrix.createScale(scales)
end

return Matrix