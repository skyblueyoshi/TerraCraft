---@class TC.TipsOfTheDay
local TipsOfTheDay = class("TipsOfTheDay")

function TipsOfTheDay:__init()
    self.texts = {
        "你可以点击上方的\"?\"按钮查看接下来的目标。",
        "使用末影传送门快速移动到世界各地。",
        "拥有共享背包模式的世界可以与其他世界共享玩家背包信息。",
        "你可以使用铁砧来恢复工具的耐久值。",
        "要致富，先砍树！造一个庇护所来度过你的第一个晚上！",
        "PC端和手机端的存档支持互通！",
        "你可以通过挖掘生命水晶来增加你的生命值上限。",
        "死亡会损失20%的经验值。",
        "尝试制作一个红石电路系统！",
        "你可以使用酿造台来制作不同的药水。",
        "你可以点击上方的配方按钮来查看所有物品配方。",
        "点击灯泡按钮，试试智能光标模式！",
        "食用魔法碎片可以增加你的魔力值上限。",
        "远程武器使用对应子弹或弓箭，将额外拥有30%伤害加成。",
    }
end

function TipsOfTheDay:getRandomText()
    return self.texts[math.random(1, #self.texts)]
end

return TipsOfTheDay