---@class TC.EnchantUI:GuiContainer
local EnchantUI = class("EnchantUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local GuiID = require("ui.GuiID")
local UISpritePool = require("ui.UISpritePool")
local StringUtil = require("util.StringUtil")
local UIData = require("EnchantUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.EnchantContainerClient
function EnchantUI:__init(container)
    EnchantUI.super.__init(self, container)
    self.enchantContainer = container
    self.enchantContainer.dataChangedCallback = { self._OnDataChanged, self }
    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getEnchantmentUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")
    self._panelButtons = {
        UIPanel.cast(self.rootLayer:getChild("panel_btn_1")),
        UIPanel.cast(self.rootLayer:getChild("panel_btn_2")),
        UIPanel.cast(self.rootLayer:getChild("panel_btn_3")),
    }

    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Enchantment)
    self:_initContent()
end

function EnchantUI:_initContent()
    local maxSlots = self.container:GetSlotCount()
    for i = 1, maxSlots do
        local tag = i - 1
        UIUtil.hookSlot(self.rootLayer:getChildByTag(tag), self, tag)
    end
    self.ui.root:addTouchUpListener({ self.OnBgClicked, self })

    ---@param panelBtn UIPanel
    for i, panelBtn in ipairs(self._panelButtons) do
        panelBtn:addTouchUpListener({ self._OnBtnClicked, self, i })
    end

    self:_FlushButtons()
end

function EnchantUI:_OnBtnClicked(index)
    self:TriggerServerEvent(UIData.EventID.ClickBtn, tostring(index))
end

function EnchantUI:_OnDataChanged()
    self:_FlushButtons()
end

function EnchantUI:_FlushButtons()
    local btnData = self.enchantContainer.btnData
    for i, data in ipairs(btnData) do
        ---@type UIPanel
        local panelBtn = self._panelButtons[i]
        local visible = data.needExp ~= 0

        panelBtn:getChild("img_exp").visible = visible
        panelBtn:getChild("lb_exp").visible = visible
        panelBtn:getChild("lb_cost").visible = visible
        panelBtn:getChild("lb_preview").visible = visible

        if data.needExp <= 0 then
            panelBtn.sprite = UISpritePool.getInstance():get("tc:base_list_cell")
        else
            panelBtn.sprite = UISpritePool.getInstance():get("tc:base_list_cell_highlight_2")
        end

        if visible then
            local previewText = "..."
            if data.firstEnchantmentID > 0 and data.cost <= 20 then
                previewText = string.format("%s %s ...",
                        LangUtils.EnchantmentName(data.firstEnchantmentID),
                        StringUtil.NumberToRoman(data.firstEnchantmentLevel)
                )
            end
            local displayNeedExp = math.abs(data.needExp)
            local cost = data.cost
            if cost >= 1 and cost <= 3 then
                UIImage.cast(panelBtn:getChild("img_exp")).sprite = UISpritePool.getInstance():get(
                        string.format("tc:enchantment_exp_%d", cost))
            end
            UIText.cast(panelBtn:getChild("lb_preview")).text = previewText
            UIText.cast(panelBtn:getChild("lb_exp")).text = tostring(displayNeedExp)
            UIText.cast(panelBtn:getChild("lb_cost")).text = tostring(cost)
        end
    end
end

function EnchantUI:OnBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(Mod.current, GuiID.Enchantment)
    end
end

function EnchantUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
end

---checkSlotShiftMove
---@param slotIndex int
---@param itemStack ItemStack
function EnchantUI:checkSlotShiftMove(slotIndex, itemStack)
    if slotIndex ~= 51 then
        if itemStack:GetItem().id == Reg.ItemID("lapis_lazuli") then
            return self.container, 51, 1
        end
    else
        return self.container, 0, 50
    end
    if slotIndex < 10 then
        -- shortcut to backpack
        return self.container, 10, 40
    elseif slotIndex < 50 then
        -- backpack to shortcut
        return self.container, 0, 10
    end
end

return EnchantUI