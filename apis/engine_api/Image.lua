---@class Image
local Image = {}

---loadPngFromMemory
---@param bytes Bytes
---@param offset number
---@param size number
---@param flip boolean
---@return ImageInfo
function Image.loadPngFromMemory(bytes, offset, size, flip)
end

---loadPngFromFileSystem
---@param filePath string
---@param flip boolean
---@return ImageInfo
function Image.loadPngFromFileSystem(filePath, flip)
end

---loadPngFromAssetBundle
---@param assetBundle AssetBundle
---@param filePath string
---@param flip boolean
---@return ImageInfo
function Image.loadPngFromAssetBundle(assetBundle, filePath, flip)
end

---saveAsPngToMemory
---@param imageInfo ImageInfo
---@param bytes Bytes
function Image.saveAsPngToMemory(imageInfo, bytes)
end

---saveAsPngToFileSystem
---@param imageInfo ImageInfo
---@param filePath string
function Image.saveAsPngToFileSystem(imageInfo, filePath)
end

---saveAsPngToAssetBundle
---@param imageInfo ImageInfo
---@param assetBundle AssetBundle
---@param filePath string
function Image.saveAsPngToAssetBundle(imageInfo, assetBundle, filePath)
end

return Image