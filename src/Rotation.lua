local _, WoWHACv5 = ...

local function GetItemCooldownDuration(itemId)
    local start, duration, enable = GetItemCooldown(itemId)
    if enable == 0 or start == 0 then
        return 0
    end
    return ((start + duration) - GetTime()) * 1000
end

local function GetCooldownDuration(spellId)
    local itemName = GetItemInfo(spellId)
    if itemName ~= null then
        return GetItemCooldownDuration(spellId)
    end
    local cd = C_Spell.GetSpellCooldown(spellId)
    if cd then
        return ((cd.startTime + cd.duration) - GetTime()) * 1000
    end
    return 0
end
local function IsCooldownActive(spellId, threshold)
    return GetCooldownDuration(spellId) > threshold
end

local function IsGCDActive(threshold)
    return IsCooldownActive(61304, threshold)
end

local function IsChanneling(threshold)
    local _, _, _, _, endTimeMS = UnitChannelInfo("player")
    if not endTimeMS then
        _, _, _, _, endTimeMS = UnitCastingInfo("player")
    end

    if endTimeMS then
        return (endTimeMS - GetTime() * 1000) >= threshold
    end
    return false
end

local SpellCastEventHandler = WoWHACv5:NewModule("SpellCastEventHandler", "AceEvent-3.0")

function SpellCastEventHandler:OnEnable()
    WoWHACv5:Debug("Register SpellCast handlers")
    WoWHACv5:RegisterEvent("UNIT_SPELLCAST_SENT", "OnSpellcast")
    WoWHACv5:RegisterEvent("UNIT_SPELLCAST_START", "OnSpellcast")
    WoWHACv5:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "OnSpellcast")
end
function WoWHACv5:OnSpellcast(event, unit, _, _, spellId)
    if unit == "player" then
        WoWHACv5.pixel:SetColor(0, 0, 0)
    end
    if event == "UNIT_SPELLCAST_CHANNEL_START" then
        local next = WoWHACv5.CURRENT_PROVIDER:GetNextHotKey();
        if next then
            WoWHACv5.CURRENT_PROVIDER:SetCurrentHotkey(next)
            WoWHACv5.CURRENT_PROVIDER:SetCurrentId(WoWHACv5.CURRENT_PROVIDER:GetNextId())
        end
    end
end

function WoWHACv5:UpdatePixel()
    local casting = UnitCastingInfo("player") ~= nil
    if casting or IsChanneling(300) or IsGCDActive(300) then
        WoWHACv5.pixel:SetColor(0, 0, 0)
    else
        if WoWHACv5.CURRENT_PROVIDER == nil then
            return
        end
        local curr = WoWHACv5.CURRENT_PROVIDER:GetCurrentId()
        if curr == nil then
            return
        end
        local rgb = WoWHACv5.Steganography(WoWHACv5.CURRENT_PROVIDER:GetCurrentHotKey())
        WoWHACv5.pixel:SetColor(rgb.red, rgb.green, rgb.blue)
    end
end

WoWHACv5:ScheduleRepeatingTimer("UpdatePixel", 0.1)