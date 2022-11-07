---@class Matrix
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
---@field up Vector3
---@field down Vector3
---@field left Vector3
---@field right Vector3
---@field forward Vector3
---@field backward Vector3
---@field translation Vector3
---@field identity Matrix
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

---clone
---@param value Matrix
---@return Matrix
function Matrix.clone(value)
end

---
---@return Matrix
function Matrix:transpose()
end

---
---@param matrix Matrix
---@param amount number
---@return Matrix
function Matrix:lerp(matrix, amount)
end

---
---@return Matrix
function Matrix:invert()
end

---
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

---
---@param cameraPosition Vector3
---@param cameraTarget Vector3
---@param cameraUpVector Vector3
---@return Matrix
function Matrix.createLookAt(cameraPosition, cameraTarget, cameraUpVector)
end

---
---@param fieldOfView number
---@param aspectRatio number
---@param nearPlaneDistance number
---@param farPlaneDistance number
---@return Matrix
function Matrix.createPerspectiveFOV(fieldOfView, aspectRatio, nearPlaneDistance, farPlaneDistance)
end

---
---@param width number
---@param height number
---@param zNearPlane number
---@param zFarPlane number
---@return Matrix
function Matrix.createOrthographicRH(width, height, zNearPlane, zFarPlane)
end

---
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param zNearPlane number
---@param zFarPlane number
---@return Matrix
function Matrix.createOrthographicRH(left, right, bottom, top, zNearPlane, zFarPlane)
end

---
---@param width number
---@param height number
---@param zNearPlane number
---@param zFarPlane number
---@return Matrix
function Matrix.createOrthographicLH(width, height, zNearPlane, zFarPlane)
end

---
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param zNearPlane number
---@param zFarPlane number
---@return Matrix
function Matrix.createOrthographicLH(left, right, bottom, top, zNearPlane, zFarPlane)
end

---
---@param radians number
---@return Matrix
function Matrix.createRotationX(radians)
end

---
---@param radians number
---@return Matrix
function Matrix.createRotationY(radians)
end

---
---@param radians number
---@return Matrix
function Matrix.createRotationZ(radians)
end

---
---@param scale number
---@return Matrix
function Matrix.createScale(scale)
end

---
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@return Matrix
function Matrix.createScale(scaleX, scaleY, scaleZ)
end

---
---@param scales Vector3
---@return Matrix
function Matrix.createScale(scales)
end

return Matrix