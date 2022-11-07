local NpcHumanJointsTall = class("NpcHumanJointsTall")

---setSkin
---@param joints JointCollection2D
---@param textureLocation TextureLocation
function NpcHumanJointsTall.setSkin(joints, textureLocation)
    if not textureLocation then
        return
    end
    local body = joints:getJoint("base.body")
    body:setTexture("skin", textureLocation, Vector2.new(-16, -18),
                Rect.new(48, 0, 48, 48))
    local head = body:getChild("head")
    head:setTexture("skin", textureLocation, Vector2.new(-14, -14),
                Rect.new(0, 0, 48, 48))
    local front_arm = body:getChild("front_arm")
    front_arm:setTexture("skin", textureLocation, Vector2.new(-20, -12),
                Rect.new(96, 0, 48, 48))
    local back_arm = body:getChild("back_arm")
    back_arm:setTexture("skin", textureLocation, Vector2.new(-20, -12),
                Rect.new(96, 0, 48, 48))
    local front_leg = body:getChild("front_leg")
    front_leg:setTexture("skin", textureLocation, Vector2.new(-20, -20),
                Rect.new(144, 0, 48, 48))
    local back_leg = body:getChild("back_leg")
    back_leg:setTexture("skin", textureLocation, Vector2.new(-20, -20),
                Rect.new(144, 0, 48, 48))

end

function NpcHumanJointsTall.create(textureLocation)
    local joints = JointCollection2D.new()

    joints.root = Joint2D.new("base",
            Vector2.new(8, 48),
            Size.new(16, 48))

    local body = Joint2D.new("body",
            Vector2.new(6, 15),
            Size.new(16, 26))

    joints.root:addChild(Vector2.new(8, 10), body)

    local back_arm = Joint2D.new("back_arm",
            Vector2.new(4, 4),
            Size.new(8, 26))
    body:addChild(Vector2.new(14, 4), back_arm, false)

    local back_item = Joint2D.new("back_item",
            Vector2.new(0, 0),
            Size.new(32, 8))
    back_arm:addChild(Vector2.new(4, 28), back_item, true)
    back_item.visible = false

    local head = Joint2D.new("head",
            Vector2.new(12, 19),
            Size.new(24, 22))
    body:addChild(Vector2.new(8, -3), head, false)

    local back_leg = Joint2D.new("back_leg",
            Vector2.new(5, -1),
            Size.new(10, 28))
    body:addChild(Vector2.new(11, 24), back_leg, false)

    local front_leg = Joint2D.new("front_leg",
            Vector2.new(5, -1),
            Size.new(10, 28))
    body:addChild(Vector2.new(4, 24), front_leg, false)

    local front_arm = Joint2D.new("front_arm",
            Vector2.new(4, 4),
            Size.new(8, 26))
    body:addChild(Vector2.new(3, 4), front_arm)

    local front_item = Joint2D.new("front_item",
            Vector2.new(0, 0),
            Size.new(32, 8))
    front_arm:addChild(Vector2.new(4, 20), front_item, false)
    front_item.visible = false

    NpcHumanJointsTall.setSkin(joints, textureLocation)

    return joints
end

return NpcHumanJointsTall