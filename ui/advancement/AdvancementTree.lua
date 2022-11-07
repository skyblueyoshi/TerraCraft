---@class TC.AdvancementTreeNode
local AdvancementTreeNode = class("AdvancementTreeNode")
---@class TC.AdvancementTree
local AdvancementTree = class("AdvancementTree")
local UIData = require("AdvancementUIData")

local OFFSET_X = UIData.OFFSET_X
local NODE_WIDTH = UIData.NODE_WIDTH
local NODE_FULL_WIDTH = UIData.NODE_FULL_WIDTH
local LEVEL_OFFSET = UIData.LEVEL_OFFSET

function AdvancementTreeNode:__init()
    self.parent = nil  ---@type TC.AdvancementTreeNode
    self.children = {}  ---@type TC.AdvancementTreeNode[]
    self.level = 0
    self.left = 0
    self.right = 0
    self.moveOffset = 0
    self.data = 0
    self.cellArea = RectFloat.new()
    self.displayState = UIData.FULL_LOCK
    self.itemStack = nil  ---@type ItemStack
end

function AdvancementTreeNode:getArea()
    return RectFloat.new(self.left + OFFSET_X / 2, self.level * LEVEL_OFFSET, NODE_WIDTH, NODE_WIDTH)
end

function AdvancementTreeNode:renderDebug()
    local area = self:getArea()
    GraphicsDevice.drawRectHollow2D(area, Color.White)
    for _, child in ipairs(self.children) do
        child:renderDebug()
        local childArea = child:getArea()
        GraphicsDevice.drawLine2D(Vector2.new(area.centerX, area.bottomY),
                Vector2.new(childArea.centerX, childArea.y), Color.White)
    end
end

function AdvancementTree:__init(source)
    --source = self:randomGenSource(0)
    self.levelLastNodes = {}  ---@type TC.AdvancementTreeNode[]
    self.root = self:genFromTable(source, 0)
    self.width = 0
    self.height = 0
    self:dfs(self.root)
    self:adaptData()
end

function AdvancementTree:randomGenSource(level)
    local source = {}
    source.data = 0
    if level <= 5 and (level == 0 or math.random(0, 1) == 0) then
        local cnt = math.random(2, 4)
        source.nexts = {}
        for _ = 1, cnt do
            table.insert(source.nexts, self:randomGenSource(level + 1))
        end
    end
    return source
end

function AdvancementTree:adaptData()
    ---@param node TC.AdvancementTreeNode
    local function _dfs(node)
        node.cellArea = RectFloat.new(
                node.left + OFFSET_X / 2,
                node.level * LEVEL_OFFSET,
                NODE_WIDTH, NODE_WIDTH)
        self.width = math.max(self.width, node.cellArea.rightX)
        self.height = math.max(self.height, node.cellArea.bottomY)
        for _, child in ipairs(node.children) do
            _dfs(child)
        end
    end
    _dfs(self.root)
end

---genFromTable
---@param source table
---@param level number
function AdvancementTree:genFromTable(source, level)
    local node = AdvancementTreeNode.new()
    node.level = level
    node.data = source.data
    if source.nexts ~= nil then
        for _, childSource in ipairs(source.nexts) do
            local childNode = self:genFromTable(childSource, level + 1)
            childNode.parent = node
            table.insert(node.children, childNode)
        end
    end
    return node
end

---getLevelRightPos
---@param level number
function AdvancementTree:getLevelRightPos(level)
    local pos = 0
    local lastNode = self.levelLastNodes[level + 1]
    if lastNode ~= nil then
        pos = lastNode.right
    end
    return pos
end

---dfs
---@param node TC.AdvancementTreeNode
function AdvancementTree:dfs(node)
    if #node.children == 0 then
        node.left = self:getLevelRightPos(node.level)
        node.right = node.left + NODE_FULL_WIDTH
    else
        local cl, cr = 1000000000, -1000000000
        for _, child in ipairs(node.children) do
            self:dfs(child)
            cl = math.min(cl, child.left)
            cr = math.max(cr, child.right)
        end
        local l = self:getLevelRightPos(node.level)
        local cx = math.floor((cl + cr) / 2 - NODE_FULL_WIDTH / 2)
        node.moveOffset = math.max(cx, l) - cx
        node.left = cx
        node.right = cx + NODE_FULL_WIDTH
        self:sink(node, 0)
    end
    self.levelLastNodes[node.level + 1] = node
end

---sink
---@param node TC.AdvancementTreeNode
---@param move number
function AdvancementTree:sink(node, move)
    local moveAll = node.moveOffset + move
    for _, child in ipairs(node.children) do
        self:sink(child, moveAll)
    end
    node.moveOffset = 0
    node.left = node.left + moveAll
    node.right = node.right + moveAll
end

return AdvancementTree