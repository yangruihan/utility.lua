--[[
MIT License

Copyright (c) 2020 Rayn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

---判断字符串是否以 prefix 开头
---@param value string 待判断字符串
---@param prefix string 开头字符串
---@param toffset number 开头偏移量
---@return boolean 是否已 prefix 字符串开头
function string.startsWith(value, prefix, toffset)
    if value and prefix then
        toffset = (toffset or 1) > 0 and toffset or 1
        return string.sub(value, toffset, toffset + #prefix - 1) == prefix
    end
    return false
end

---判断字符串是否以 suffix 结尾
---@param value string 待判断字符串
---@param suffix string 结尾字符串
---@return boolean 是否已 suffix 字符串结尾
function string.endsWith(value, suffix)
    if value and suffix then
        return string.sub(value, -(#suffix)) == suffix
    end
    return false
end

---将某个字符串首字母大写
---@param value string 字符串
function string.title(value)
    return string.upper(string.sub(value, 1, 1)) .. string.sub(value, 2, #value)
end

---返回字符串中某个位置的字符
---@param value string 字符串
---@param position number 字符位置
---@return string 某个位置的字符
function string.charAt(value, position)
    if value and position and position > 0 then
        local b = string.byte(value, position, position + 1)
        return b and string.char(b) or b
    end
end

---判断字符串是不是全由空白符组成 (空格和\t)
---@param value string 字符串
---@return boolean 结果
function string.isWhitespace(value)
    if value then
        local len = #value
        for i = 1, len do
            local char = string.CharAt(value, i)
            if char ~= " " and char ~= "\t" then
                return false
            end
        end
        return true
    end
    return false
end

---空或者Empty
---@param value string
---@return boolean
function string.isNilOrEmtpy(value)
    return value == nil or value == ""
end

---将一个字符串转换成数组
---@param value string 字符串
---@return table 数组 Table
function string.toArray(value)
    local ret = {}
    if value then
        local idx = 1
        local count = #value
        while idx <= count do
            local b = string.byte(value, idx, idx + 1)
            if b > 127 then
                table.insert(ret, string.sub(value, idx, idx + 1))
                idx = idx + 2
            else
                table.insert(ret, string.char(b))
                idx = idx + 1
            end
        end
    end
    return ret
end

---将字符串转换成 Bytecode
---@param value string 字符串
---@return string Bytecode
function string.bytecode(value)
    if value then
        local bytes = {}
        local idx = 1
        local count = #value
        while idx <= count do
            local b = string.byte(value, idx, idx + 1)
            if b >= 100 then
                table.insert(bytes, "\\" .. b)
            else
                table.insert(bytes, "\\0" .. b)
            end
            idx = idx + 1
        end
        local code, ret = pcall(loadstring(string.format("do local _='%s' return _ end", table.concat(bytes))))
        if code then
            return ret
        end
    end
    return ""
end

---得到字符串的子串
---@param value string 字符串
---@param startIndex number 开始索引
---@param endIndex number 结束索引
---@return string 子串
function string.subStr(value, startIndex, endIndex)
    if value then
        local ret = {}
        local idx = startIndex
        local count = endIndex or #value
        while idx <= count do
            local b = string.byte(value, idx, idx + 1)
            if not b then
                break
            end
            if b > 127 then
                table.insert(ret, string.sub(value, idx, idx + 1))
                idx = idx + 2
            else
                table.insert(ret, string.char(b))
                idx = idx + 1
            end
        end
        return table.concat(ret)
    end
end

---拆分字符串
---@param value string 字符串
---@param sep string 分隔符
---@return table 分割后的结果
function string.split(value, sep)
    sep = sep or "%s"
    local t = {}
    for field, s in string.gmatch(value, "([^" .. sep .. "]*)(" .. sep .. "?)") do
        table.insert(t, field)
        if s == "" then
            return t
        end
    end
end
