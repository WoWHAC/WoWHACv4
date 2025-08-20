local _, WoWHACv4 = ...

WoWHACv4:RegisterMessage("WOWHACV4_ENABLE", function()
    WoWHACv4:Debug("Register SpellCast handlers")
    WoWHACv4:RegisterEvent("UNIT_SPELLCAST_SENT", "OnSpellcast")
    WoWHACv4:RegisterEvent("UNIT_SPELLCAST_START", "OnSpellcast")
    WoWHACv4:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "OnSpellcast")
end)

function WoWHACv4:OnSpellcast(_, unit)
    if unit == "player" then
        WoWHACv4.pixel:SetColor(0, 0, 0)
    end
end