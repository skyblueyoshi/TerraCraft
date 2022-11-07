local NpcHumanAnimator = class("NpcHumanAnimator")

function NpcHumanAnimator.create()
    local asm = {
        parameters = {
            "Float Speed 0.0",
            "Bool OnGround False",
            "Float AirSpeed 0.0",
            "Bool Standard False",
            "Trigger SwordAttacking False",
            "Bool HoldingItem False",
            "Trigger StopAction False"
        },
        layers = {
            {
                name = "Base Layer",
                weight = 1.0,
                blending = "Override",
                mask = {
                    disabledJoints = {}
                },
                states = {
                    {
                        name = "StandardIdle",
                        isDefault = true,
                        clipName = "Standard",
                        transitions = {
                            {
                                nextState = "Stand", offset = 0, duration = 0.5,
                                conditions = { "Standard == false" }
                            }
                        }
                    },
                    {
                        name = "Stand",
                        blendTree = {
                            parameter = "Speed",
                            motions = {
                                { clipName = "Idle", threshold = 0.0 },
                                { clipName = "Walk", threshold = 1.0 },
                            }
                        },
                        transitions = {
                            {
                                nextState = "Jump", offset = 0.0, duration = 0.15,
                                conditions = { "OnGround == false" }
                            },
                        }
                    },
                    {
                        name = "Jump",
                        clipName = "Jump",
                        transitions = {
                            {
                                nextState = "Stand", offset = 0, duration = 0.25,
                                hasExitTime = false,
                                conditions = { "OnGround == true" }
                            },
                        }
                    },
                }
            },
            {
                name = "Body Action Layer",
                weight = 1.0,
                blending = "Override",
                --mask = {
                    --disabledJoints = { "base.body.front_leg", "base.body.back_leg" }
                --},
                states = {
                    {
                        name = "StandardIdle",
                        isDefault = true,
                        clipName = "Standard",
                        transitions = {
                            {
                                nextState = "HoldingItem", offset = 0, duration = 0.2,
                                conditions = { "HoldingItem == true" }
                            },
                            {
                                nextState = "SwordAttacking", offset = 0, duration = 0,
                                conditions = { "SwordAttacking == true" }
                            }
                        }
                    },
                    {
                        name = "HoldingItem",
                        clipName = "HoldingItem",
                        transitions = {
                            {
                                nextState = "StandardIdle", offset = 0, duration = 0.2,
                                conditions = { "HoldingItem == false" }
                            },
                        }
                    },
                    {
                        name = "SwordAttacking",
                        clipName = "SwordAttacking",
                        transitions = {
                            {
                                nextState = "StandardIdle", offset = 0.99, duration = 0,
                                hasExitTime = false,
                            },
                            {
                                nextState = "StandardIdle", offset = 0, duration = 0,
                                conditions = { "StopAction == true" }
                            }
                        }
                    },
                }
            }
        }
    }
    return AnimatorData2D.new(asm)
end

return NpcHumanAnimator