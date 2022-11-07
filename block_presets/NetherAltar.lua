---@class TC.NetherAltar:ModBlock
local NetherAltar = class("NetherAltar", ModBlock)

function NetherAltar.OnDestroy(xi, yi, parameterDestroy)
    NpcUtils.Create(Reg.NpcID("worm_head"), xi * 16 - 1000, yi * 16)
    SoundUtils.PlaySound(Reg.SoundID("monster"), xi, yi)
end

return NetherAltar