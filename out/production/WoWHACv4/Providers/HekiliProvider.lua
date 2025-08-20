local _, WoWHACv4 = ...

local HekiliProvider = WoWHACv4.Provider:extend("HekiliProvider")

function HekiliProvider:init()
    WoWHACv4:Log("Supplier found: Hekili.")
    WoWHACv4:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv4:SecureHook(WeakAuras, "ScanEvents", function(event, _, _, _, _, arg5)
                if event == "HEKILI_RECOMMENDATION_UPDATE" then
                    if arg5 then
                        if arg5[1] then
                            if arg5[1].keybind then
                                self:Fire(arg5[1].keybind)
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

WoWHACv4.providers["Hekili"] = HekiliProvider