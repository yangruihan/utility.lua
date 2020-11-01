local Utility = {}

function Utility.makeGlobal()
    for k, v in pairs(Utility) do
        if k ~= "makeGlobal" then
            _G[k] = v
        end
    end
end

function Utility.makeAutoIdx()
    local idx = 0
    return function()
        idx = idx + 1
        return idx
    end
end

return Utility