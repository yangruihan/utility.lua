---浅拷贝 table
---@param source table
---@param destiny table
---@param overlay boolean 强制覆盖
---@return table
function table.copy(source, destiny, overlay)
    assert(source, "Table deep copy error, source table cannot be nil")

    overlay = overlay and overlay ~= false
    destiny = destiny or {}

    for key, value in pairs(source) do
        if overlay then
            destiny[key] = value
        elseif not destiny[key] then
            destiny[key] = value
        end
    end

    return destiny
end

---深拷贝 table
---@param source table
---@param destiny table
---@param overlay boolean 强制覆盖
---@return table
function table.deepCopy(source, destiny, overlay)
    assert(source, "Table deep copy error, source table cannot be nil")

    overlay = overlay and overlay ~= false
    destiny = destiny or {}

    for key, value in pairs(source) do
        if overlay then
            if type(value) == "table" then
                destiny[key] = table.deepCopy(value, nil, overlay)
            else
                destiny[key] = value
            end
        elseif not destiny[key] then
            if type(value) == "table" then
                destiny[key] = table.deepCopy(value, nil, overlay)
            else
                destiny[key] = value
            end
        end
    end
    return destiny
end

---清理 table
---@param tab table
---@return table
function table.clear(tab)
    if tab then
        local field = next(tab)
        while field do
            tab[field] = nil
            field = next(tab)
        end
    end

    return tab
end

---移除 value 那一项，会修改传入的 table
---@param tab table
---@param value any
---@return table
function table.removeValue(tab, value)
    if tab then
        if table.isArray(tab) then
            for i = #tab, 1, -1 do
                if tab[i] == value then
                    table.remove(tab, i)
                end
            end
        else
            for k, v in pairs(tab) do
                if v == value then
                    tab[k] = nil
                    break
                end
            end
        end
    end
    return tab
end

---移除 key 对应的那个 value
---@param tab table
---@param key any
---@return table
function table.removeKey(tab, key)
    if tab then
        for k, _ in pairs(tab) do
            if k == key then
                tab[k] = nil
                break
            end
        end
    end

    return tab
end

---查找 table 中所有满足指定条件的羡慕
---@param tab table
---@param filterFuc fun(key: string, value: any):boolean
function table.findAll(tab, filterFuc)
    if not tab then
        return nil
    end

    local ret = {}
    for k, v in pairs(tab) do
        if filterFuc(k, v) then
            ret[#ret + 1] = v
        end
    end

    return ret
end

---统计 table 中属性的数量
---@param tab table
---@return number
function table.size(tab)
    local size = 0

    if tab then
        for _, _ in pairs(tab) do
            size = size + 1
        end
    end

    return size
end

---排序迭代器
---@generic V
---@param tab table
---@param comparator fun(a:V, b:V):boolean
function table.sortIterator(tab, comparator)
    if tab then
        local index = 0
        local auxTable = {}
        local count = 0

        for k, _ in pairs(tab) do
            count = count + 1
            rawset(auxTable, count, k)
        end

        table.sort(auxTable, comparator)

        return function()
            index = index + 1
            if index <= count then
                local field = auxTable[index]
                return field, tab[field]
            end
        end
    else
        return nil
    end
end

---table 是否包含 value
---@param tab table
---@param value any
---@return boolean
function table.contains(tab, value)
    if tab and value then
        for _, v in pairs(tab) do
            if value == v then
                return true
            end
        end
    end

    return false
end

---table 是否包含 element，如果 element 是 table，则会遍历 element 的属性进行值判断
---@param tab table
---@param element any
---@return boolean
function table.include(tab, element)
    if not tab then
        return false
    end

    for _, v in pairs(tab) do
        local done = false

        if type(v) == "table" and type(element) == "table" then
            done = true

            if table.size(element) ~= table.size(v) then
                done = false
            end

            for k2, v2 in pairs(element) do
                if not v[k2] or v[k2] ~= v2 then
                    done = false
                    break
                end
            end
        elseif v == element then
            done = true
        end

        if done then
            return true
        end
    end

    return false
end

---table 是否是一个数组
---@param tab table
---@return boolean
function table.isArray(tab)
    if not tab then
        return false
    end

    local ret = true
    local idx = 1

    for k, _ in pairs(tab) do
        if type(k) == "number" then
            if k ~= idx then
                ret = false
            end
        else
            ret = false
        end

        if not ret then
            break
        end

        idx = idx + 1
    end

    return ret
end

---table 是否是一个表
---@param tab table
---@return boolean
function table.isMap(tab)
    if not tab then
        return false
    end

    return not table.isArray(tab)
end

---判断 table 是否为空
---@param tab table
---@return boolean
function table.isEmpty(tab)
    return tab == nil or _G.next(tab) == nil
end

---得到一个 value 对应的键名
function table.getKeyName(tab, value)
    if not tab then
        return nil
    end

    for k, v in pairs(tab) do
        if v == value then
            return tostring(k)
        end
    end

    return nil
end

---查找 table 中某个元素的索引
---@param t table
---@param item any
---@param checkIsArray boolean
---@return number|nil 如果存在则返回index，如果
function table.indexOf(t, item, checkIsArray)
    if checkIsArray then
        if not table.isArray(t) then
            return nil
        end
    end

    --TODO 可以改成二分法
    for i, k in ipairs(t) do
        if k == item then
            return i
        end
    end

    return nil
end

---将一个函数应用到 table 上的每一个元素
---@param t table
---@param func fun(k:any, v:any):any
---@return table
function table.map(t, func)
    assert(t, "Table map error, source table cannot be nil")

    local ret = {}

    for k, v in pairs(t) do
        ret[k] = func(k, v)
    end

    return ret
end
