local _, WoWHACv5 = ...

local ConROProvider = WoWHACv5.Provider:extend("ConROProvider")

local currentId;
local currentHotkey;
local nextId;
local nextHotkey;
function ConROProvider:init()
    WoWHACv5:Log("Supplier found: ConRO.")
    if ConROWindow and ConROWindow.fontkey then
        local Keybind = ConROWindow.fontkey
        local last = Keybind:GetText()
        WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
            if txt ~= last then
                last = txt
                currentId = ConRO.Spell;
                currentHotkey = txt;
            end
        end)
    end
    if ConROWindow2 and ConROWindow2.fontkey then
        local Keybind = ConROWindow2.fontkey
        local last = Keybind:GetText()
        WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
            if txt ~= last then
                last = txt
                nextId = ConRO.SuggestedSpells[2];
                nextHotkey = txt;
            end
        end)
    end
end

function ConROProvider:GetCurrentHotKey()
    return currentHotkey
end

function ConROProvider:SetCurrentHotKey(hotkey)
    currentHotkey = hotkey
end

function ConROProvider:SetCurrentId(spellId)
    currentId = spellId
end

function ConROProvider:GetCurrentId()
    return currentId
end

function ConROProvider:GetNextHotKey()
    --return nil
    return nextHotkey
end

function ConROProvider:GetNextId()
    --return nil
    return nextId
end

WoWHACv5.providers["ConRO"] = ConROProvider