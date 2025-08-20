local _, WoWHACv4 = ...

WoWHACv4:RegisterMessage("WOWHACV4_ENABLE", function()
    WoWHACv4:Debug("Register WeakAuras handlers")
    WoWHACv4:RegisterEvent("PLAYER_LOGIN")
end)

function WoWHACv4:PLAYER_LOGIN()
    for key, value in pairs(WoWHACv4.providers) do
        if C_AddOns.IsAddOnLoaded(key) then
            value()
            break
        end
    end
    WoWHACv4:SendMessage("WOWHACV4_WA_PRESENTS", C_AddOns.IsAddOnLoaded("WeakAuras"))
end