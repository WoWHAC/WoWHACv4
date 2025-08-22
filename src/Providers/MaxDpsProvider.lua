local _, WoWHACv5 = ...

local MaxDpsProvider = WoWHACv5.Provider:extend("MaxDpsProvider")

local currentHotkey;
function MaxDpsProvider:init()
    WoWHACv5:Log("Supplier found: MaxDps.")
    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv5.ToggleBurstFrame:Show()
            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, _)
                if event == "MAXDPS_COOLDOWN_UPDATE" then
                    if true then
                        for _, frame in pairs(MaxDps.Frames) do
                            if frame and frame:IsVisible() then
                                if WoWHACv5.burst or frame.ovType ~= "cooldown" then
                                    local button = frame:GetParent()
                                    currentHotkey = button.HotKey:GetText()
                                    return
                                end
                            end
                        end
                        return
                    end
                end
            end)
        else
            WoWHACv5:Log("To use the MaxDps as rotation provider, you need to install WeakAuras.")
        end
    end)
end
function MaxDpsProvider:GetCurrentHotKey()
    return currentHotkey
end

function MaxDpsProvider:GetCurrentId()
    return 0
end

WoWHACv5.providers["MaxDps"] = MaxDpsProvider