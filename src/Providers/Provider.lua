local _, WoWHACv5 = ...

local Provider = {}
Provider.__index = Provider

function Provider:new()
    local self = setmetatable({}, Provider)
    WoWHACv5:Log("No rotation suppliers found. A list of available suppliers can be found at https://wowhac.fun/")
    return self
end

function Provider:GetCurrentHotKey()
    return nil
end

function Provider:SetCurrentHotKey(hotkey)
end

function Provider:SetCurrentId(spellId)
end

function Provider:GetCurrentId()
    return nil
end

function Provider:GetNextHotKey()
    return nil
end

function Provider:GetNextId()
    return nil
end

WoWHACv5.Provider = Provider.new