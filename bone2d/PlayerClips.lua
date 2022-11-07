local PlayerClips = class("PlayerClips")

---getClips
---@param joints JointCollection2D
---@return ClipCollection2D
function PlayerClips.create(joints)
    local clips = ClipCollection2D.new(joints)
    
    clips:addClip({
        name = "Idle",
        time = 1.5,
        loop = true,
        jointClips = {
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.25, value = 0.0584 },
                            { time = 0.5, value = 0.0 },
                            { time = 0.7, value = -0.0425 },
                            { time = 0.9, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.25, value = -0.0584 },
                            { time = 0.5, value = 0.0 },
                            { time = 0.7, value = 0.0425 },
                            { time = 0.9, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.25, value = -0.0584 },
                            { time = 0.5, value = 0.0 },
                            { time = 0.7, value = 0.0425 },
                            { time = 0.9, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg.back_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.25, value = -0.0584 },
                            { time = 0.5, value = 0.0 },
                            { time = 0.7, value = 0.0425 },
                            { time = 0.9, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg.front_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = -0.15 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = 0.15 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "Walk",
        time = 0.6,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.75 },
                            { time = 0.5, value = 0.5 },
                            { time = 1.0, value = -0.75 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg.back_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.25 },
                            { time = 0.5, value = 0.75 },
                            { time = 1.0, value = 0.25 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.5 },
                            { time = 0.5, value = -0.85 },
                            { time = 1.0, value = 0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg.front_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.75 },
                            { time = 0.5, value = 0.25 },
                            { time = 1.0, value = 0.75 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.5 },
                            { time = 0.5, value = 0.5 },
                            { time = 1.0, value = -0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.5 },
                            { time = 0.5, value = 0.0 },
                            { time = 1.0, value = -0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.25 },
                            { time = 0.5, value = -0.5 },
                            { time = 1.0, value = 0.25 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = -0.5 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.015 },
                            { time = 0.5, value = -0.015 },
                            { time = 1.0, value = 0.015 },
                        }
                    }
                }
            },
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = 0.05 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
        }
    })


    clips:addClip({
        name = "Run",
        time = 0.69,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.85 },
                            { time = 0.5, value = 0.5 },
                            { time = 1.0, value = -0.85 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg.back_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.05 },
                            { time = 0.5, value = 0.95 },
                            { time = 1.0, value = 0.05 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.5 },
                            { time = 0.5, value = -0.85 },
                            { time = 1.0, value = 0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg.front_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.95 },
                            { time = 0.5, value = 0.05 },
                            { time = 1.0, value = 0.95 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.5 },
                            { time = 0.5, value = 0.75 },
                            { time = 1.0, value = -0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -1.25 },
                            { time = 0.5, value = -0.60 },
                            { time = 1.0, value = -1.25 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.25 },
                            { time = 0.5, value = -0.95 },
                            { time = 1.0, value = 0.25 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.4 },
                            { time = 0.5, value = -1.0 },
                            { time = 1.0, value = -0.4 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.015 },
                            { time = 0.5, value = -0.015 },
                            { time = 1.0, value = 0.015 },
                        }
                    }
                }
            },
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = 0.1 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "JumpUp",
        time = 1.79,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.75 },
                            { time = 0.5, value = -0.65 },
                            { time = 1.0, value = -0.75 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg.back_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.5 },
                            { time = 0.5, value = 0.6 },
                            { time = 1.0, value = 0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.15 },
                            { time = 0.5, value = 0.05 },
                            { time = 1.0, value = 0.15 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg.front_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.6 },
                            { time = 0.5, value = 0.5 },
                            { time = 1.0, value = 0.6 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -1.2 },
                            { time = 0.5, value = -1.1 },
                            { time = 1.0, value = -1.2 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.7 },
                            { time = 0.5, value = -0.8 },
                            { time = 1.0, value = -0.7 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 1.1 },
                            { time = 0.5, value = 1.0 },
                            { time = 1.0, value = 1.1 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.70 },
                            { time = 0.5, value = -0.60 },
                            { time = 1.0, value = -0.70 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.05 },
                            { time = 0.5, value = -0.1 },
                            { time = 1.0, value = -0.05 },
                        }
                    }
                }
            },
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.10 },
                            { time = 0.5, value = -0.08 },
                            { time = 1.0, value = -0.10 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "JumpDown",
        time = 1.79,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.95 },
                            { time = 0.5, value = -0.85 },
                            { time = 1.0, value = -0.95 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg.back_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.5 },
                            { time = 0.5, value = 0.6 },
                            { time = 1.0, value = 0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.15 },
                            { time = 0.5, value = -0.05 },
                            { time = 1.0, value = -0.15 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg.front_feet",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.16 },
                            { time = 0.5, value = 0.15 },
                            { time = 1.0, value = 0.16 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -2.4 },
                            { time = 0.5, value = -2.5 },
                            { time = 1.0, value = -2.4 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.0 },
                            { time = 0.5, value = -0.0 },
                            { time = 1.0, value = -0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 1.2 },
                            { time = 0.5, value = 1.1 },
                            { time = 1.0, value = 1.2 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.50 },
                            { time = 0.5, value = -0.40 },
                            { time = 1.0, value = -0.50 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.05 },
                            { time = 0.5, value = -0.1 },
                            { time = 1.0, value = -0.05 },
                        }
                    }
                }
            },
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.10 },
                            { time = 0.5, value = 0.08 },
                            { time = 1.0, value = 0.10 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "JustOnGround",
        time = 0.5,
        loop = false,
        jointClips = {
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = 0.284 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.25, value = -0.0584 },
                            { time = 0.5, value = 0.0 },
                            { time = 0.7, value = 0.0425 },
                            { time = 0.9, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -1.2 },
                            { time = 0.5, value = -1.1 },
                            { time = 1.0, value = -1.2 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.7 },
                            { time = 0.5, value = -0.8 },
                            { time = 1.0, value = -0.7 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 1.1 },
                            { time = 0.5, value = 1.0 },
                            { time = 1.0, value = 1.1 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.70 },
                            { time = 0.5, value = -0.60 },
                            { time = 1.0, value = -0.70 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = -0.284 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = -0.284 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "Death",
        time = 0.5,
        loop = false,
        jointClips = {
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineIn", value = 0.0 },
                            { time = 0.9, value = -1.57 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.head",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineIn", value = 0.0 },
                            { time = 0.5, value = 0.5 },
                            { time = 0.9, value = -0.2 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = -1.3284 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, value = -0.9284 },
                            { time = 0.9, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, interpolation = "SineIn", value = -1.9284 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 0.5, interpolation = "SineIn", value = -1.4284 },
                            { time = 1.0, value = 0.0 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "HoldingItem",
        time = 0.51,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -1.0 },
                            { time = 0.5, value = -1.02 },
                            { time = 1.0, value = -1.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand.back_item",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = math.pi / 2 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "SwordAttacking",
        time = 1.0,
        loop = false,
        jointClips = {
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -3.2 },
                            { time = 1.0, value = -0.3 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = 0.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.back_arm.back_hand.back_item",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = 2.4 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = 1.0 },
                        }
                    }
                }
            },
            {
                jointName = "base.body.front_arm.front_hand",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = -0.5 },
                        }
                    }
                }
            },
            {
                jointName = "base.body",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.0 },
                            { time = 1.0, value = 0.1 },
                        }
                    }
                }
            },
            --{
            --    jointName = "base.body.back_leg",
            --    data = {
            --        {
            --            variable = "Angle",
            --            samples = {
            --                { time = 0.0, interpolation = "SineInOut", value = 0.0 },
            --                { time = 0.5, value = -0.1 },
            --                { time = 1.0, value = 0.0 },
            --            }
            --        }
            --    }
            --},
            --{
            --    jointName = "base.body.front_leg",
            --    data = {
            --        {
            --            variable = "Angle",
            --            samples = {
            --                { time = 0.0, interpolation = "SineInOut", value = 0.0 },
            --                { time = 0.5, value = 0.1 },
            --                { time = 0.9, value = 0.0 },
            --            }
            --        }
            --    }
            --},
        }
    })

    clips:addClip({
        name = "Placing",
        time = 0.25,
        loop = false,
        jointClips = {
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -4.0 },
                            { time = 1.0, value = -0.8 },
                        }
                    }
                }
            }
        }
    })

    clips:addClip({
        name = "Eating",
        time = 0.25,
        loop = false,
        jointClips = {
            {
                jointName = "base.body.back_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = -0.8 },
                            { time = 1.0, value = -4.0 },
                        }
                    }
                }
            }
        }
    })

    clips:addClip({
        name = "Standard",
        time = 1.0,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_arm.back_hand.back_item",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = math.pi / 2 },
                        }
                    }
                }
            },
        }
    })

    return clips
end

return PlayerClips