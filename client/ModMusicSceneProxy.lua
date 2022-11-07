---@class TC.ModMusicSceneProxy
local ModMusicSceneProxy = class("ModMusicSceneProxy")

---@type TC.ModMusicSceneProxy[]
local s_proxy = {}

---__init
---@param proxy TC.MusicSceneProxy
function ModMusicSceneProxy:__init(proxy)
    self._proxy = proxy
end

function ModMusicSceneProxy.getProxy()
    return s_proxy
end

function ModMusicSceneProxy.register(modProxyClass)
    table.insert(s_proxy, modProxyClass)
end

function ModMusicSceneProxy:onRegisterAllScenes()
end


return ModMusicSceneProxy