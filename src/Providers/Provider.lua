local _, WoWHACv5 = ...

local currentId = 0
local currentHotkey
local nextId
local nextHotkey

function WoWHACv5:GetCurrentHotKey()
    return currentHotkey
end

function WoWHACv5:GetCurrentId()
    return currentId
end

function WoWHACv5:SetCurrentHotKey(hotkey)
    if hotkey then
        WoWHACv5:Debug("Current hotkey is: " .. hotkey)
    end
    currentHotkey = hotkey
end

function WoWHACv5:SetCurrentId(spellId)
    currentId = spellId
end

function WoWHACv5:GetNextHotKey()
    return nextHotkey
end

function WoWHACv5:GetNextId()
    return nextId
end

function WoWHACv5:SetNextHotKey(hotkey)
    if hotkey then
        WoWHACv5:Debug("Next hotkey is: " .. hotkey)
    end
    nextHotkey = hotkey
end

function WoWHACv5:SetNextId(spellId)
    nextId = spellId
end

WoWHACv5.Provider = function()
    WoWHACv5:Log("No rotation suppliers found. A list of available suppliers can be found at https://wowhac.fun/")
end
