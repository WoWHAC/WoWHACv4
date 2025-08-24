local _, WoWHACv5 = ...

WoWHACv5.providers = WoWHACv5.providers or {}
WoWHACv5.providers["Hekili"] = function ()
    WoWHACv5:Log("Supplier found: Hekili.")

    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, display, spellId, _, _, arg5)
                if event == "HEKILI_RECOMMENDATION_UPDATE" and arg5 then
                    local currentRec = arg5[1]
                    if currentRec then
                        local keybind = currentRec.keybind
                        if keybind ~= WoWHACv5:GetCurrentHotKey() and keybind ~= WoWHACv5:GetNextHotKey() then
                            WoWHACv5:SetCurrentId(currentRec.actionID or spellId)
                            WoWHACv5:SetCurrentHotKey(keybind)
                        end
                    end
                    local nextRec = arg5[2]
                    if nextRec then
                        local keybind = nextRec.keybind
                        if keybind ~= WoWHACv5:GetNextHotKey() then
                            WoWHACv5:SetNextId(nextRec.actionID)
                            WoWHACv5:SetNextHotKey(keybind)
                        end
                    end
                end
            end)
        else
            WoWHACv5:Log("To use the Hekili as rotation, you need to install WeakAuras.")
        end
    end)
end
