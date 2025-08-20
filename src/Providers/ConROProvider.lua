local _, WoWHACv4 = ...
local currentId;
local currentHotkey;
local nextId;
local nextHotkey;
local ConROProvider = WoWHACv4.Provider:extend("ConROProvider")
function ConROProvider:init()
    WoWHACv4:Log("Supplier found: ConRO.")
    if ConROWindow and ConROWindow.fontkey then
        local Keybind = ConROWindow.fontkey
        local last = Keybind:GetText()
        WoWHACv4:SecureHook(Keybind, "SetText", function(_, txt)
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
        WoWHACv4:SecureHook(Keybind, "SetText", function(_, txt)
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

function ConROProvider:GetCurrentId()
    return currentId
end

function ConROProvider:GetNextHotKey()
    return nextHotkey
end

function ConROProvider:GetNextId()
    return nextId
end

WoWHACv4.providers["ConRO"] = ConROProvider