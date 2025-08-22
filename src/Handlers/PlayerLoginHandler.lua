local _, WoWHACv5 = ...

local PlayerLoginHandler = WoWHACv5:NewModule("PlayerLoginHandler", "AceEvent-3.0")

function PlayerLoginHandler:OnEnable()
    WoWHACv5:Debug("Register WeakAuras handlers")
    PlayerLoginHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function PlayerLoginHandler:PLAYER_ENTERING_WORLD()
    for key, value in pairs(WoWHACv5.providers) do
        if C_AddOns.IsAddOnLoaded(key) then
            WoWHACv5.CURRENT_PROVIDER = value()
            break
        end
    end
    if WoWHACv5.CURRENT_PROVIDER == nil then
        WoWHACv5.CURRENT_PROVIDER = WoWHACv5.Provider()
    end
    WoWHACv5:SendMessage("WOWHACV4_WA_PRESENTS", C_AddOns.IsAddOnLoaded("WeakAuras"))
end