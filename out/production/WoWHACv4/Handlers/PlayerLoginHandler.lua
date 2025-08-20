local _, WoWHACv4 = ...

local PlayerLoginHandler = WoWHACv4:NewModule("PlayerLoginHandler", "AceEvent-3.0")

function PlayerLoginHandler:OnEnable()
    WoWHACv4:Debug("Register WeakAuras handlers")
    PlayerLoginHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function PlayerLoginHandler:PLAYER_ENTERING_WORLD()
    for key, value in pairs(WoWHACv4.providers) do
        if C_AddOns.IsAddOnLoaded(key) then
            value()
            break
        end
    end
    WoWHACv4:SendMessage("WOWHACV4_WA_PRESENTS", C_AddOns.IsAddOnLoaded("WeakAuras"))
end