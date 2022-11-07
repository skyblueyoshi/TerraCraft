local PlayerAnimator = class("PlayerAnimator")

function PlayerAnimator.create()
    local asm = {
        parameters = {
            "Float Speed 0.0",
            "Bool OnGround False",
            "Float AirSpeed 0.0",
            "Bool Death False",
            "Bool Standard False",
            "Trigger Placing False",
            "Trigger Eating False",
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
                        name = "Idle",
                        clipName = "Idle",
                        transitions = {
                            {
                                nextState = "Walk", offset = 0, duration = 0.95,
                                hasExitTime = false,
                                conditions = { "Speed > 0.5" }
                            }
                        }
                    },
                    {
                        name = "Walk",
                        clipName = "Walk",
                        transitions = {
                            {
                                nextState = "Idle", offset = 0.0, duration = 0.95,
                                conditions = { "Speed < 0.5" }
                            }
                        }
                    },
                    {
                        name = "Stand",
                        blendTree = {
                            parameter = "Speed",
                            motions = {
                                { clipName = "Idle", threshold = 0.0 },
                                { clipName = "Walk", threshold = 0.5 },
                                { clipName = "Run", threshold = 1.0 }
                            }
                        },
                        transitions = {
                            {
                                nextState = "JumpUp", offset = 0.0, duration = 0.15,
                                conditions = { "OnGround == false", "AirSpeed < 0.0" }
                            },
                            {
                                nextState = "JumpDown", offset = 0.0, duration = 0.15,
                                conditions = { "OnGround == false", "AirSpeed >= 0.0" }
                            },
                            {
                                nextState = "Death", offset = 0.0, duration = 0.55,
                                conditions = { "Death == true" }
                            }
                        }
                    },
                    {
                        name = "JumpUp",
                        clipName = "JumpUp",
                        transitions = {
                            {
                                nextState = "JumpDown", offset = 0, duration = 0.15,
                                hasExitTime = false,
                                conditions = { "AirSpeed >= 0.0" }
                            },
                            {
                                nextState = "JustOnGround", offset = 0, duration = 0.25,
                                hasExitTime = false,
                                conditions = { "OnGround == true" }
                            },
                            {
                                nextState = "Death", offset = 0.0, duration = 0.55,
                                conditions = { "Death == true" }
                            }
                        }
                    },
                    {
                        name = "JumpDown",
                        clipName = "JumpDown",
                        transitions = {
                            {
                                nextState = "JumpUp", offset = 0, duration = 0.15,
                                hasExitTime = false,
                                conditions = { "AirSpeed < 0.0" }
                            },
                            {
                                nextState = "JustOnGround", offset = 0, duration = 0.05,
                                hasExitTime = false,
                                conditions = { "OnGround == true" }
                            },
                            {
                                nextState = "Death", offset = 0.0, duration = 0.55,
                                conditions = { "Death == true" }
                            }
                        }
                    },
                    {
                        name = "JustOnGround",
                        clipName = "JustOnGround",
                        transitions = {
                            {
                                nextState = "Stand", offset = 0.0, duration = 0.15,
                                hasExitTime = false,
                            },
                            {
                                nextState = "Death", offset = 0.0, duration = 0.55,
                                conditions = { "Death == true" }
                            }
                        }
                    },
                    {
                        name = "Death",
                        clipName = "Death",
                        transitions = {
                            {
                                nextState = "Stand", offset = 0.0, duration = 0.15,
                                conditions = { "Death == false" }
                            }
                        }
                    },
                    --{
                    --    name = "Standard",
                    --    clipName = "Standard",
                    --    isDefault = true,
                    --    transitions = {
                    --    }
                    --},
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
                                nextState = "Placing", offset = 0, duration = 0,
                                conditions = { "Placing == true" }
                            },
                            {
                                nextState = "Eating", offset = 0, duration = 0,
                                conditions = { "Eating == true" }
                            },
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
                                nextState = "Placing", offset = 0, duration = 0,
                                conditions = { "Placing == true" }
                            },
                            {
                                nextState = "Eating", offset = 0, duration = 0,
                                conditions = { "Eating == true" }
                            },
                            {
                                nextState = "StandardIdle", offset = 0, duration = 0.2,
                                conditions = { "HoldingItem == false" }
                            },
                        }
                    },
                    {
                        name = "Placing",
                        clipName = "Placing",
                        transitions = {
                            {
                                nextState = "HoldingItem", offset = 0.2499, duration = 0,
                                conditions = { "HoldingItem == true" }
                            },
                            {
                                nextState = "StandardIdle", offset = 0.2499, duration = 0,
                            },
                            {
                                nextState = "StandardIdle", offset = 0, duration = 0,
                                conditions = { "StopAction == true" }
                            }
                        }
                    },
                    {
                        name = "Eating",
                        clipName = "Eating",
                        transitions = {
                            {
                                nextState = "HoldingItem", offset = 0.2499, duration = 0,
                                conditions = { "HoldingItem == true" }
                            },
                            {
                                nextState = "StandardIdle", offset = 0.2499, duration = 0,
                            },
                            {
                                nextState = "StandardIdle", offset = 0, duration = 0,
                                conditions = { "StopAction == true" }
                            }
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

return PlayerAnimator