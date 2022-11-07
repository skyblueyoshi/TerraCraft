---@class Utils Util Module (通用模块)
---@field netMode int
---@field E double
---@field LOG2E double
---@field LOG10E double
---@field PI double
---@field TWO_PI double
---@field PI_OVER_2 double
---@field PI_OVER_4 double
local Utils = {}

---If n is greater than 0, return a random integer of [0, n), otherwise return 0.
---
---若n大于0，返回[0, n)的随机整数，否则返回0。
---@param n int
---@return int
function Utils.RandInt(n)
end

---If len is greater than 0, return a random integer of [begin, begin + len), otherwise return begin.
---
---若len大于0，返回[begin, begin + len)的随机整数，否则返回begin。
---@param begin int
---@param len int
---@return int
function Utils.RandIntArea(begin, len)
end

---
---
---若value大于0，返回[0, value)的随机浮点数，否则返回0。
---@param value double
---@return double
function Utils.RandDouble(value)
end

---
---
---若len大于0，返回[begin, begin + len)的随机浮点数，否则返回begin。
---@param begin double
---@param len double
---@return double
function Utils.RandDoubleArea(begin, len)
end

---
---
---返回(-value, value)的随机浮点数。
---@param value double
---@return double
function Utils.RandSym(value)
end

---
---
---当n为正数时1/n概率返回true，否则始终返回false。
---
---例1：Utils.RandTry(3)有1/3概率返回true。
---
---例2：Utils.RandTry(2)有一半概率返回true。
---@param n int
---@return boolean
function Utils.RandTry(n)
end

---
---
---返回实际横/纵坐标对应的格子横/纵坐标。注意每个格子为16像素，实际结果为除以16后向下取整。
---@param a double
---@return int
function Utils.Cell(a)
end

---
---
---返回a与b求余的非负数结果。
---
---例1：Utils.PositiveMod(5, 3)返回2。
---
---例2：Utils.PositiveMod(-5, 3)返回1。
---
---`int c = a % b;`
---
---`if (c < 0) c += b;`
---
---`return c;`
---@param a int
---@param b int
---@return int
function Utils.PositiveMod(a, b)
end

---
---
---若b非0，返回a向下取整整除b的结果，否则返回0。
---
---例1：Utils.FloorDivide(10, 3)返回3。
---
---例2：Utils.FloorDivide(-4, 3)返回-2。
---
---`return a / b - ((a < 0 && a % b != 0) ? 1 : 0);`
---@param a int
---@param b int
---@return int
function Utils.FloorDivide(a, b)
end

---
---
---返回以period为周期、以begin为初相位的正弦波在相位phase的值。
---
---`return sin(begin + 2 * PI * float(phase % period) / period);`
---@overload fun(phase:int,period:int):int
---@param phase int
---@param period int
---@param begin int @[ default `0` ]
---@return double
function Utils.SinValue(phase, period, begin)
end

---
---
---返回以period为周期、以begin为初相位的余弦波在相位phase的值。
---
---`return cos(begin + 2 * PI * float(phase % period) / period);`
---@overload fun(phase:int,period:int):int
---@param phase int
---@param period int
---@param begin int @[ default `0` ]
---@return double
function Utils.CosValue(phase, period, begin)
end

---
---
---返回start值往target值方向移动step长度的结果，若到达target值，则返回target值。
---
---例1：Utils.ToTargetValue(1, 10, 5)返回6。
---
---例2：Utils.ToTargetValue(6, 10, 5)返回10。
---@param start int
---@param target int
---@param step int
---@return int
function Utils.ToTargetValue(start, target, step)
end

---Returns the distance from point (x1, y1) to point (x2, y2).
---
---返回点(x1, y1)到点(x2, y2)的距离。
---
---例：Utils.GetPointsDistance(1.0,0.0,4.0,4.0)返回5.0。
---@param x1 double
---@param y1 double
---@param x2 double
---@param y2 double
---@return double
function Utils.GetPointsDistance(x1, y1, x2, y2)
end

---
---
---返回点(x, y)到原点(0, 0)的距离。
---
---例：Utils.GetDistance(3.0, 4.0)返回5.0。
---@param x double
---@param y double
---@return double
function Utils.GetDistance(x, y)
end

---
---
---返回点(x, y)到以点(x1, y1)和点(x2, y2)为两端点的线段的距离。
---@param x double
---@param y double
---@param x1 double
---@param y1 double
---@param x2 double
---@param y2 double
---@return double
function Utils.GetPointSegmentDistance(x, y, x1, y1, x2, y2)
end

---
---
---返回向量(x, y)与横坐标的夹角。
---
---例1：Utils.GetAngle(1, 1)返回π/4。
---
---例2：Utils.GetAngle(0, 1)返回π/2。
---@param x double
---@param y double
---@return double
function Utils.GetAngle(x, y)
end

---
---
---将角度按2π周期增加或减少，返回最终限定在区间(-π, π]内的结果。
---
---@param angle double
---@return double
function Utils.FixAngle(angle)
end

---
---
---将极坐标转换为直角坐标，返回横坐标和纵坐标。
---
---`x = length * cos(angle);`
---
---`y = length * sin(angle);`
---
---@param length double
---@param angle double
---@return double,double
function Utils.GetXYFromPolar(length, angle)
end

---
---
---将点(x, y)绕原点旋转指定角度，返回旋转后的横坐标和纵坐标。
---
---`double dx = x, dy = y;`
---
---`x = dx * cos(angle) - dy * sin(angle);`
---
---`y = dx * sin(angle) + dy * cos(angle);`
---
---@param x double
---@param y double
---@param angle double
---@return double,double
function Utils.RotateXY(x, y, angle)
end

---
---
---将一个二维速度(speedX, speedY)以恒定速度(dec)降低，返回新的横速度和纵速度。
---@param speedX double
---@param speedY double
---@param dec double
---@return double,double
function Utils.SlowSpeed2D(speedX, speedY, dec)
end

---
---
---将一个速度以恒定速度(dec)降低，返回新的速度。
---@param speed double
---@param dec double
---@return double
function Utils.SlowSpeed1D(speed, dec)
end

---
---
---将一个二维速度(speedX, speedY)进行受力，返回新的横速度和纵速度。
---@param speedX double
---@param speedY double
---@param force double
---@param forceAngle double
---@param maxSpeed double
---@return double,double
function Utils.ForceSpeed2D(speedX, speedY, force, forceAngle, maxSpeed)
end

return Utils