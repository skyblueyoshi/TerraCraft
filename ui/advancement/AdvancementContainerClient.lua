---@class TC.AdvancementContainerClient:Container
local AdvancementContainerClient = class("AdvancementContainerClient", Container)
local AdvancementTree = require("AdvancementTree")
local UIData = require("AdvancementUIData")

---@param player Player
function AdvancementContainerClient:__init(player)
    AdvancementContainerClient.super.__init(self)
    local source = self:_BuildTreeSource()
    self.tree = AdvancementTree.new(source)
    self:_ProcessData(player)
end

---_ProcessData
---@param player Player
function AdvancementContainerClient:_ProcessData(player)
    ---_DFS
    ---@param node TC.AdvancementTreeNode
    local function _DFS(node, state)
        local id = node.data
        local advancement = AdvancementUtils.Get(id)

        if player:IsAdvancementFinished(id) then
            print("advancement finish id", id, Reg.AdvancementIDName(id))
            state = UIData.FINISH
        end
        node.displayState = state
        if state ~= UIData.FULL_LOCK then
            node.itemStack = ItemStack.new(ItemRegistry.GetItemByID(advancement.itemID))
        end
        if state == UIData.FINISH then
            state = UIData.UNLOCK
        elseif state == UIData.UNLOCK then
            state = UIData.NEXT_UNLOCK
        else
            --state = UIData.FULL_LOCK
            state = UIData.NEXT_UNLOCK
        end
        for _, child in ipairs(node.children) do
            _DFS(child, state)
        end
    end
    --_DFS(self.tree.root, UIData.FULL_LOCK)
    _DFS(self.tree.root, UIData.NEXT_UNLOCK)
end

function AdvancementContainerClient:_BuildTreeSource()
    local maxID = Reg.MaxAdvancementID()
    local tempArray = {}
    local rootID = {}
    for id = 1, maxID do
        tempArray[id] = {}
    end
    for id = 1, maxID do
        local advancement = AdvancementUtils.Get(id)
        if advancement.parentID == 0 then
            rootID = id
        else
            table.insert(tempArray[advancement.parentID], id)
        end
    end
    local function dfs(curID)
        local tmp = { data = curID, nexts = {}, name = Reg.AdvancementIDName(curID) }
        for _, childID in ipairs(tempArray[curID]) do
            local child = dfs(childID)
            table.insert(tmp.nexts, child)
        end
        return tmp
    end
    return dfs(rootID)
end

function AdvancementContainerClient:OnEvent(eventId, eventString)

end

return AdvancementContainerClient