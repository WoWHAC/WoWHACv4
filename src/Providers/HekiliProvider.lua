local _, WoWHACv5 = ...

local HekiliProvider = WoWHACv5.Provider:extend("HekiliProvider")

local currentId;
local currentHotkey;
local nextId;
local nextHotkey;
function HekiliProvider:init()
    WoWHACv5:Log("Supplier found: Hekili.")
    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, display, spellId, _, _, arg5)
                if event == "HEKILI_RECOMMENDATION_UPDATE" then
                    if arg5 then
                        local next = arg5[2]
                        if next then
                            local keybind = next.keybind
                            if nextKeybind ~= nextHotkey then
                                nextHotkey = keybind
                                nextId = next.actionID
                            end
                        end
                        local current = arg5[1]
                        if current then
                            local keybind = current.keybind
                            if keybind ~= currentHotkey and keybind ~= nextHotkey then
                                currentHotkey = keybind
                                currentId = spellId
                            end
                        end
                    end
                end
            end)
        else
            WoWHACv5:Log("To use the Hekili as rotation, you need to install WeakAuras.")
        end
    end)
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
    --return nil
    return nextHotkey
end

function HekiliProvider:GetNextId()
    --return nil
    return nextId
end

WoWHACv5.providers["Hekili"] = HekiliProvider