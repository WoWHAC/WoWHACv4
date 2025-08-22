local _, WoWHACv5 = ...

local Provider = {}
Provider.__index = Provider

setmetatable(Provider, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then self:init(...) end
        return self
    end
})

function Provider:init()
    -- Внутреннее состояние
    self._currentHotKey = nil
    self._currentId     = nil
    self._nextHotKey    = nil
    self._nextId        = nil

    WoWHACv5:Log("No rotation suppliers found. A list of available suppliers can be found at https://wowhac.fun/")
end

function Provider:GetCurrentHotKey()
    return self._currentHotKey
end

function Provider:SetCurrentHotKey(hotkey)
    self._currentHotKey = hotkey
end

function Provider:SetCurrentId(spellId)
    self._currentId = spellId
end

function Provider:GetCurrentId()
    return self._currentId
end

function Provider:GetNextHotKey()
    return self._nextHotKey
end

function Provider:GetNextId()
    return self._nextId
end

WoWHACv5.Provider = Provider
