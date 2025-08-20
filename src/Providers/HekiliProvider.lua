local _, WoWHACv4 = ...

local HekiliProvider = WoWHACv4.Provider:extend("HekiliProvider")

local currentId;
local currentHotkey;
local nextId;
local nextHotkey;
function HekiliProvider:init()
    WoWHACv4:Log("Supplier found: Hekili.")
    WoWHACv4:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv4:SecureHook(WeakAuras, "ScanEvents", function(event, display, spellId, _, _, arg5)
                if event == "HEKILI_RECOMMENDATION_UPDATE" then
                    if arg5 then
                        local current = arg5[1]
                        if current then
                            local keybind = current.keybind
                            if keybind ~= currentHotkey then
                                currentHotkey = keybind
                                currentId = spellId
                                local next = arg5[2]
                                if next then
                                    local nextKeybind = next.keybind
                                    if nextKeybind ~= nextHotkey then
                                        nextHotkey = nextKeybind
                                        nextId = next.actionID
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            WoWHACv4:Log("To use the Hekili as rotation, you need to install WeakAuras.")
        end
    end)
end

function HekiliProvider:GetCurrentHotKey()
    return currentHotkey
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

WoWHACv4.providers["Hekili"] = HekiliProvider