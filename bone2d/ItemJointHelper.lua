local ItemJointHelper = class("ItemJointHelper")

---checkItemChanged
---@param itemSlot Slot
---@param cacheTable table
function ItemJointHelper.checkItemChanged(itemSlot, cacheTable)
    local checking = false
    if cacheTable.itemID == nil then
        checking = true
    else
        if itemSlot.hasStack then
            if cacheTable.itemID ~= itemSlot:GetStack():GetItem().id then
                checking = true
            end
        else
            if cacheTable.itemID ~= 0 then
                checking = true
            end
        end
    end

    return checking
end

---setItem
---@param itemJoint Joint2D
---@param itemStack ItemStack
function ItemJointHelper.setItem(itemJoint, itemStack)
    local holdX, holdY = 16, 16
    local jointWidth, jointHeight = 32, 32
    local item = itemStack:GetItem()
    local usingEntity = item.hasEntity
    if usingEntity then
        holdX, holdY = item.handX, item.handY
        jointWidth, jointHeight = item.entityWidth, item.entityHeight
    end
    itemJoint.transform.origin = Vector2.new(holdX, holdY)
    itemJoint.size = Size.new(jointWidth, jointHeight)
    itemJoint.visible = true
    if NetMode.current == NetMode.Client then
        local texOffsetX, texOffsetY, texWidth, texHeight = 0, 0, 32, 32
        local texture = usingEntity and item.entityTextureLocation or item.iconTextureLocation
        local scale = 1.0

        if texture.valid then
            local cut = TextureManager.getSourceRect(texture)
            texWidth, texHeight = cut.width, cut.height
            local modItem = itemStack:GetModItem()
            if modItem ~= nil and modItem.IsUseTex32 and modItem:IsUseTex32() then
                texWidth, texHeight = 32, 32
            end
            if usingEntity then
                texOffsetX, texOffsetY = item.entityOffsetX, item.entityOffsetY
                texWidth, texHeight = jointWidth, jointHeight
            else
                local maxTexSize = math.max(1, math.max(texWidth, texHeight))
                scale = 32 / maxTexSize
            end
            itemJoint:setTexture("item", texture,
                    Vector2.new(-texOffsetX, -texOffsetY),
                    Rect.new(0, 0, texWidth, texHeight))
        else
            itemJoint:setTexture("item", texture, Vector2.new(0, 0), Rect.new(0, 0, 32, 32))
        end

        itemJoint.transform.rotation = math.pi / 2
        itemJoint.transform.scale = Vector2.new(scale, scale)
    end
end

---checkItem
---@param itemJoint Joint2D
---@param itemSlot Slot
---@param cacheTable table
function ItemJointHelper.checkItem(itemJoint, itemSlot, cacheTable)
    local checking = ItemJointHelper.checkItemChanged(itemSlot, cacheTable)
    if not checking then
        return
    end

    if itemSlot.hasStack then
        local stack = itemSlot:GetStack()
        cacheTable.itemID = stack:GetItem().id
        ItemJointHelper.setItem(itemJoint, stack)
    else
        cacheTable.itemID = 0
        ItemJointHelper.clearItem(itemJoint)
    end
end

---@param itemJoint Joint2D
function ItemJointHelper.clearItem(itemJoint)
    itemJoint.visible = false
end

return ItemJointHelper