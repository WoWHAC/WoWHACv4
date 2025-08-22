local _, WoWHACv5 = ...

local HekiliProvider = {}
HekiliProvider.__index = HekiliProvider

local currentId
local currentHotkey
local nextId
local nextHotkey

function HekiliProvider:new()
    local self = setmetatable({}, HekiliProvider)
    WoWHACv5:Log("Supplier found: Hekili.")
    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            if WoWHACv5:IsHooked(WeakAuras, "ScanEvents") then
                WoWHACv5:Unhook(WeakAuras, "ScanEvents")
            end

            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, display, spellId, _, _, arg5)
                if event == "HEKILI_RECOMMENDATION_UPDATE" and type(arg5) == "table" then
                    local next = arg5[2]
                    if type(next) == "table" and next.keybind then
                        if next.keybind ~= nextHotkey then
                            nextHotkey = next.keybind
                            nextId = next.actionID
                        end
                    end
                    local current = arg5[1]
                    if type(current) == "table" and current.keybind then
                        if current.keybind ~= currentHotkey and current.keybind ~= nextHotkey then
                            currentHotkey = current.keybind
                            currentId = spellId
                        end
                    end
                end
            end)
        else
            WoWHACv5:Log("To use the Hekili as rotation, you need to install WeakAuras.")
        end
    end)
    return self
end

function HekiliProvider:GetCurrentHotKey()
    return currentHotkey
end

function HekiliProvider:SetCurrentHotKey(hotkey)
    currentHotkey = hotkey
end

function HekiliProvider:SetCurrentId(spellId)
    currentId = spellId
end

function HekiliProvider:GetCurrentId()
    return currentId
end

function HekiliProvider:GetNextHotKey()
    return nextHotkey
end

function HekiliProvider:GetNextId()
    return nextId
end

WoWHACv5.providers["Hekili"] = HekiliProvider.new