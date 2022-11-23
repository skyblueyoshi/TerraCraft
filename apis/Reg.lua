---@API

---@class Reg 描述游戏内的注册信息。
local Reg = {}

---根据物品名返回注册的动态ID。
---@param name string
---@return int
function Reg.ItemID(name)
end

---根据动态ID返回物品的全局ID名称。
---@param id int
---@return string
function Reg.ItemIDName(id)
end

---返回最大物品ID。
---@return int
function Reg.MaxItemID()
end

---根据方块名返回注册的动态ID。
---@param name string
---@return int
function Reg.BlockID(name)
end

---根据动态ID返回方块的全局ID名称。
---@param id int
---@return string
function Reg.BlockIDName(id)
end

---根据方块组名返回注册的动态ID。
---@param name string
---@return int
function Reg.BlockGroupID(name)
end

---根据动态ID返回方块组的全局ID名称。
---@param id int
---@return string
function Reg.BlockGroupIDName(id)
end

---根据方块子组名返回注册的动态ID。
---@param name string
---@return int
function Reg.BlockSubGroupID(name)
end

---根据动态ID返回方块子组的全局ID名称。
---@param id int
---@return string
function Reg.BlockSubGroupIDName(id)
end

---根据方块实体名返回注册的动态ID。
---@param name string
---@return int
function Reg.BlockEntityID(name)
end

---根据动态ID返回方块实体的全局ID名称。
---@param id int
---@return string
function Reg.BlockEntityIDName(id)
end

---根据特效名返回注册的动态ID。
---@param name string
---@return int
function Reg.EffectID(name)
end

---根据动态ID返回特效的全局ID名称。
---@param id int
---@return string
function Reg.EffectIDName(id)
end

---根据BUFF名返回注册的动态ID。
---@param name string
---@return int
function Reg.BuffID(name)
end

---根据动态ID返回BUFF的全局ID名称。
---@param id int
---@return string
function Reg.BuffIDName(id)
end

---根据附魔名返回注册的动态ID。
---@param name string
---@return int
function Reg.EnchantmentID(name)
end

---根据动态ID返回附魔的全局ID名称。
---@param id int
---@return string
function Reg.EnchantmentIDName(id)
end

---返回附魔的最大ID。
---@return int
function Reg.MaxEnchantmentID()
end

---根据NPC名返回注册的动态ID。
---@param name string
---@return int
function Reg.NpcID(name)
end

---根据动态ID返回NPC的全局ID名称。
---@param id int
---@return string
function Reg.NpcIDName(id)
end

---根据抛射物名返回注册的动态ID。
---@param name string
---@return int
function Reg.ProjectileID(name)
end

---根据动态ID返回抛射物的全局ID名称。
---@param id int
---@return string
function Reg.ProjectileIDName(id)
end

---根据音效名返回注册的动态ID。
---@param name string
---@return int
function Reg.SoundID(name)
end

---根据动态ID返回音效的全局ID名称。
---@param id int
---@return string
function Reg.SoundIDName(id)
end

---根据音效组名返回注册的动态ID。
---@param name string
---@return int
function Reg.SoundGroupID(name)
end

---根据动态ID返回音效组的全局ID名称。
---@param id int
---@return string
function Reg.SoundGroupIDName(id)
end

---根据流体名返回注册的动态ID。
---@param name string
---@return int
function Reg.LiquidID(name)
end

---根据动态ID返回流体的全局ID名称。
---@param id int
---@return string
function Reg.LiquidIDName(id)
end

---根据生物群系名返回注册的动态ID。
---@param name string
---@return int
function Reg.BiomeID(name)
end

---根据动态ID返回生物群系的全局ID名称。
---@param id int
---@return string
function Reg.BiomeIDName(id)
end

---返回最大生物群系ID。
---@return int
function Reg.MaxBiomeID()
end

---根据生物群系类型名返回注册的动态ID。
---@param name string
---@return int
function Reg.BiomeTypeID(name)
end

---根据动态ID返回生物群系类型的全局ID名称。
---@param id int
---@return string
function Reg.BiomeTypeIDName(id)
end

---返回最大生物群系类型ID。
---@return int
function Reg.MaxBiomeTypeID()
end

---根据配方配置名返回注册的动态ID。
---@param name string
---@return int
function Reg.RecipeConfigID(name)
end

---根据动态ID返回配方配置的全局ID名称。
---@param id int
---@return string
function Reg.RecipeConfigIDName(id)
end

---返回最大配方配置ID。
---@return int
function Reg.MaxRecipeConfigID()
end

---返回最大配方ID。
---@return int
function Reg.MaxRecipeID()
end

---根据动态ID返回矿物字典的全局ID名称。
---@param id int
---@return string
function Reg.OreDictionaryIDName(id)
end

---根据矿物字典名返回注册的动态ID。
---@param name string
---@return int
function Reg.OreDictionaryID(name)
end

---根据工具优先级名返回注册的动态ID。
---@param gradeName string
---@return int
function Reg.ToolGradePriority(gradeName)
end

---根据弹药名返回注册的动态ID。
---@param name string
---@return int
function Reg.AmmoID(name)
end

---根据动态ID返回弹药的全局ID名称。
---@param id int
---@return string
function Reg.AmmoIDName(id)
end

---根据成就名返回注册的动态ID。
---@param name string
---@return int
function Reg.AdvancementID(name)
end

---根据动态ID返回成就的全局ID名称。
---@param id int
---@return string
function Reg.AdvancementIDName(id)
end

---返回最大成就ID。
---@return int
function Reg.MaxAdvancementID()
end

---@param name string
---@return int
function Reg.ModTextureID(name)
end

---@param id int
---@return string
function Reg.ModTextureIDName(id)
end

---根据建筑名返回注册的动态ID。
---@param name string
---@return int
function Reg.BuildingID(name)
end

---根据动态ID返回建筑的全局ID名称。
---@param id int
---@return string
function Reg.BuildingIDName(id)
end

return Reg