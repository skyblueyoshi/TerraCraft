local OrderedArray = class("OrderedArray")

function OrderedArray:__init()
    self.indices = {}

    self._elements = {}
    self._frees = {}
end

function OrderedArray:add(element)
    local index = 0
    if #self._frees ~= 0 then
        index = self._frees[#self._frees]
        table.remove(self._frees, #self._frees)
        self._elements[index] = element
    else
        table.insert(self._elements, element)
        index = #self._elements
    end
    table.insert(self.indices, index)
    return index
end

function OrderedArray:remove(index)
    table.insert(self._frees, index)
    self._elements[index] = false
    for i, ii in ipairs(self.indices) do
        if ii == index then
            table.remove(self.indices, i)
            break
        end
    end
end

function OrderedArray:get(index)
    return self._elements[index]
end

function OrderedArray:clear()
    self.indices = {}
    self._elements = {}
    self._frees = {}
end

return OrderedArray