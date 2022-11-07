---@class TC.EnchantContainerClient:Container
local EnchantContainerClient = class("EnchantContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

function EnchantContainerClient:__init(player, xi, yi)
    EnchantContainerClient.super.__init(self)

    self.TOTAL_SLOT = 50 + 2
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)

    self.dataChangedCallback = nil
    self.btnData = {}
    for _ = 1, 3 do
        table.insert(self.btnData, {
            needExp = 0,
            cost = 0,
            firstEnchantmentID = 0,
            firstEnchantmentLevel = 0,
        })
    end
end

function EnchantContainerClient:OnReceiveChange(id, value)
    if id == 0 then
        local tableData = JsonUtil.fromJson(value)
        for i, element in ipairs(tableData) do
            local data = self.btnData[i]
            data.needExp = element.needExp
            data.cost = element.cost
            data.firstEnchantmentID = element.firstEnchantmentID
            data.firstEnchantmentLevel = element.firstEnchantmentLevel
        end
        if self.dataChangedCallback ~= nil and #self.dataChangedCallback == 2 then
            self.dataChangedCallback[1](self.dataChangedCallback[2])
        end
    end
end

return EnchantContainerClient