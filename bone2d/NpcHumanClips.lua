local NpcHumanClips = class("NpcHumanClips")

---getClips
---@param joints JointCollection2D
---@return ClipCollection2D
function NpcHumanClips.create(joints)
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
        name = "Jump",
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
                jointName = "base.body.front_leg",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, interpolation = "SineInOut", value = 0.75 },
                            { time = 0.5, value = 0.85 },
                            { time = 1.0, value = 0.75 },
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
                            { time = 0.0, interpolation = "SineInOut", value = -1.0 },
                            { time = 0.5, value = -0.9 },
                            { time = 1.0, value = -1.0 },
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
                            { time = 0.0, interpolation = "SineInOut", value = 1.0 },
                            { time = 0.5, value = 0.9 },
                            { time = 1.0, value = 1.0 },
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
                            { time = 0.0, interpolation = "SineInOut", value = -0.02 },
                            { time = 0.5, value = -0.05 },
                            { time = 1.0, value = -0.02 },
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
                            { time = 0.0, interpolation = "SineInOut", value = -0.00 },
                            { time = 0.5, value = -0.03 },
                            { time = 1.0, value = -0.00 },
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
                jointName = "base.body.back_arm.back_item",
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
                jointName = "base.body.back_arm",
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
                jointName = "base.body.back_arm.back_item",
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
                jointName = "base.body.front_arm",
                data = {
                    {
                        variable = "Angle",
                        samples = {
                            { time = 0.0, value = -0.5 },
                        }
                    }
                }
            },
        }
    })

    clips:addClip({
        name = "Standard",
        time = 1.0,
        loop = true,
        jointClips = {
            {
                jointName = "base.body.back_arm.back_item",
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

return NpcHumanClips