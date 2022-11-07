local PlayerJoints = class("PlayerJoints")

---setSkin
---@param joints JointCollection2D
---@param textureTable table
function PlayerJoints.setSkin(joints, textureTable)
    if not textureTable then
        return
    end
    local body = joints:getJoint("base.body")
    local head = body:getChild("head")
    local back_arm = body:getChild("back_arm")
    local back_hand = back_arm:getChild("back_hand")
    local front_arm = body:getChild("front_arm")
    local front_hand = front_arm:getChild("front_hand")
    local back_leg = body:getChild("back_leg")
    local back_feet = back_leg:getChild("back_feet")
    local front_leg = body:getChild("front_leg")
    local front_feet = front_leg:getChild("front_feet")

    head:clearTexture("skin")
    head:clearTexture("hair")
    head:clearTexture("hat")

    if textureTable.head ~= nil then
        head:setTexture("skin", textureTable.head, Vector2.new(-16, -14),
                Rect.new(0, 0, 48, 48))
    end
    if textureTable.hair ~= nil then
        head:setTexture("hair", textureTable.hair, Vector2.new(-16, -14),
                Rect.new(0, 0, 48, 48))
    end
    if textureTable.hat ~= nil then
        head:setTexture("hat", textureTable.hat, Vector2.new(-16, -14),
                Rect.new(0, 0, 48, 48))
    end

    body:clearTexture("skin")
    body:clearTexture("cloth")

    if textureTable.body ~= nil then
        body:setTexture("skin", textureTable.body, Vector2.new(-16, -14),
                Rect.new(0, 0, 48, 48))

        back_arm:setTexture("skin", textureTable.body, Vector2.new(-22, -14),
                Rect.new(144, 0, 48, 48))

        back_hand:setTexture("skin", textureTable.body, Vector2.new(-22, -22),
                Rect.new(192, 0, 48, 48))

        front_arm:setTexture("skin", textureTable.body, Vector2.new(-12, -16),
                Rect.new(48, 0, 48, 48))

        front_hand:setTexture("skin", textureTable.body, Vector2.new(-14, -24),
                Rect.new(96, 0, 48, 48))
    end
    if textureTable.cloth ~= nil then
        body:setTexture("cloth", textureTable.cloth, Vector2.new(-16, -14),
                Rect.new(0, 0, 48, 48))

        back_arm:setTexture("cloth", textureTable.cloth, Vector2.new(-22, -14),
                Rect.new(144, 0, 48, 48))

        back_hand:setTexture("cloth", textureTable.cloth, Vector2.new(-22, -22),
                Rect.new(192, 0, 48, 48))

        front_arm:setTexture("cloth", textureTable.cloth, Vector2.new(-12, -16),
                Rect.new(48, 0, 48, 48))

        front_hand:setTexture("cloth", textureTable.cloth, Vector2.new(-14, -24),
                Rect.new(96, 0, 48, 48))
    end

    back_leg:clearTexture("skin")
    back_leg:clearTexture("pant")

    front_leg:clearTexture("skin")
    front_leg:clearTexture("pant")

    back_feet:clearTexture("skin")
    back_feet:clearTexture("shoe")

    front_feet:clearTexture("skin")
    front_feet:clearTexture("shoe")

    if textureTable.leg ~= nil then
        back_leg:setTexture("skin", textureTable.leg, Vector2.new(-20, -16),
                Rect.new(0, 0, 48, 48))

        back_feet:setTexture("skin", textureTable.leg, Vector2.new(-20, -22),
                Rect.new(48, 0, 48, 48))

        front_leg:setTexture("skin", textureTable.leg, Vector2.new(-20, -16),
                Rect.new(0, 0, 48, 48))

        front_feet:setTexture("skin", textureTable.leg, Vector2.new(-20, -22),
                Rect.new(48, 0, 48, 48))
    end
    if textureTable.pant ~= nil then
        back_leg:setTexture("pant", textureTable.pant, Vector2.new(-20, -16),
                Rect.new(0, 0, 48, 48))

        back_feet:setTexture("shoe", textureTable.pant, Vector2.new(-20, -22),
                Rect.new(48, 0, 48, 48))

        front_leg:setTexture("pant", textureTable.pant, Vector2.new(-20, -16),
                Rect.new(0, 0, 48, 48))

        front_feet:setTexture("shoe", textureTable.pant, Vector2.new(-20, -22),
                Rect.new(48, 0, 48, 48))
    end
end

function PlayerJoints.create(textureTable)
    local joints = JointCollection2D.new()

    joints.root = Joint2D.new("base",
            Vector2.new(8, 48),
            Size.new(16, 48))

    local body = Joint2D.new("body",
            Vector2.new(6, 15),
            Size.new(12, 16))

    joints.root:addChild(Vector2.new(8, 29), body)

    local backpack = Joint2D.new("backpack",
            Vector2.new(8, 8),
            Size.new(16, 16))
    body:addChild(Vector2.new(0, 8), backpack, false)

    local back_arm = Joint2D.new("back_arm",
            Vector2.new(4, 4),
            Size.new(8, 10))
    body:addChild(Vector2.new(10, 6), back_arm, false)

    local back_hand = Joint2D.new("back_hand",
            Vector2.new(3, 1),
            Size.new(8, 14))
    back_arm:addChild(Vector2.new(3, 7), back_hand, false)

    local back_item = Joint2D.new("back_item",
            Vector2.new(8, 4),
            Size.new(32, 8))
    back_hand:addChild(Vector2.new(4, 10), back_item, true)
    back_item.visible = false

    local head = Joint2D.new("head",
            Vector2.new(8, 13),
            Size.new(16, 16))
    body:addChild(Vector2.new(6, -3), head, false)

    local back_leg = Joint2D.new("back_leg",
            Vector2.new(3, -1),
            Size.new(8, 8))
    body:addChild(Vector2.new(7, 15), back_leg, false)

    local back_feet = Joint2D.new("back_feet",
            Vector2.new(7, 0),
            Size.new(10, 12))
    back_leg:addChild(Vector2.new(7, 6), back_feet)

    local front_leg = Joint2D.new("front_leg",
            Vector2.new(3, -1),
            Size.new(8, 8))
    body:addChild(Vector2.new(3, 15), front_leg, false)

    local front_feet = Joint2D.new("front_feet",
            Vector2.new(7, 0),
            Size.new(10, 12))
    front_leg:addChild(Vector2.new(7, 6), front_feet)

    local front_arm = Joint2D.new("front_arm",
            Vector2.new(5, 4),
            Size.new(8, 10))
    body:addChild(Vector2.new(1, 6), front_arm)

    local front_hand = Joint2D.new("front_hand",
            Vector2.new(3, 1),
            Size.new(8, 14))
    front_arm:addChild(Vector2.new(5, 7), front_hand, false)

    local front_item = Joint2D.new("front_item",
            Vector2.new(8, 4),
            Size.new(32, 8))
    front_hand:addChild(Vector2.new(4, 10), front_item, false)
    front_item.visible = false

    PlayerJoints.setSkin(joints, textureTable)

    return joints
end

return PlayerJoints