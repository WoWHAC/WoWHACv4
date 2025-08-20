local _, WoWHACv4 = ...

local MaxDpsProvider = WoWHACv4.Provider:extend("MaxDpsProvider")

local currentHotkey;
function MaxDpsProvider:init()
    WoWHACv4:Log("Supplier found: MaxDps.")
    WoWHACv4:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv4.ToggleBurstFrame:Show()
            WoWHACv4:SecureHook(WeakAuras, "ScanEvents", function(event, _)
                if event == "MAXDPS_COOLDOWN_UPDATE" then
                    if true then
                        for _, frame in pairs(MaxDps.Frames) do
                            if frame and frame:IsVisible() then
                                if WoWHACv4.burst or frame.ovType ~= "cooldown" then
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
            WoWHACv4:Log("To use the MaxDps as rotation provider, you need to install WeakAuras.")
        end
    end)
end
function MaxDpsProvider:GetCurrentHotKey()
    return currentHotkey
end

function MaxDpsProvider:GetCurrentId()
    return 0
end

WoWHACv4.providers["MaxDps"] = MaxDpsProvider