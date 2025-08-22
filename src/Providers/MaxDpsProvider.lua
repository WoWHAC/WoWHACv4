local _, WoWHACv5 = ...

local MaxDpsProvider = setmetatable({}, { __index = WoWHACv5.Provider })
MaxDpsProvider.__index = MaxDpsProvider

local currentHotkey

function MaxDpsProvider:new()
    local self = setmetatable(WoWHACv5.Provider:new(), MaxDpsProvider)

    WoWHACv5:Log("Supplier found: MaxDps.")
    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv5.ToggleBurstFrame:Show()

            if WoWHACv5:IsHooked(WeakAuras, "ScanEvents") then
                WoWHACv5:Unhook(WeakAuras, "ScanEvents")
            end

            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, _)
                if event == "MAXDPS_COOLDOWN_UPDATE" and MaxDps and MaxDps.Frames then
                    for _, frame in pairs(MaxDps.Frames) do
                        if frame and frame:IsVisible() then
                            if WoWHACv5.burst or frame.ovType ~= "cooldown" then
                                local button = frame:GetParent()
                                if button and button.HotKey then
                                    currentHotkey = button.HotKey:GetText()
                                    return
                                end
                            end
                        end
                    end
                end
            end)
        else
            WoWHACv5:Log("To use the MaxDps as rotation provider, you need to install WeakAuras.")
        end
    end)
    return self
end
function MaxDpsProvider:GetCurrentHotKey()
    return currentHotkey
end

function MaxDpsProvider:GetCurrentId()
    return 0
end

function MaxDpsProvider:SetCurrentHotKey(hotkey)
end

function MaxDpsProvider:SetCurrentId(spellId)
end

function MaxDpsProvider:GetNextHotKey()
    return nil
end

function MaxDpsProvider:GetNextId()
    return nil
end

WoWHACv5.providers["MaxDps"] = MaxDpsProvider.new