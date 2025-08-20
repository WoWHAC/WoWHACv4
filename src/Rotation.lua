local _, WoWHACv4 = ...

local tuple = Tuple2()
local tupleId = Tuple2()

WoWHACv4:RegisterMessage("WOWHACV4_UPDATE_HOTKEY", function(_, keybind, spellId)
    if keybind then
        WoWHACv4:Debug("Presumed hot key: " .. keybind)
    end
    local steganography = WoWHACv4.Steganography(keybind)
    tuple:SetFirst(steganography)
    tupleId:SetFirst(spellId)
end)

WoWHACv4:RegisterMessage("WOWHACV4_NEXT_HOTKEY", function(_, keybind, spellId)
    local steganography = WoWHACv4.Steganography(keybind)
    tuple:SetSecond(steganography)
    print(keybind, " ", spellId)
    tupleId:SetSecond(spellId)
end)

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
    return ((cd.startTime + cd.duration) - GetTime()) * 1000
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

local SpellCastEventHandler = WoWHACv4:NewModule("SpellCastEventHandler", "AceEvent-3.0")

function SpellCastEventHandler:OnEnable()
    WoWHACv4:Debug("Register SpellCast handlers")
    WoWHACv4:RegisterEvent("UNIT_SPELLCAST_SENT", "OnSpellcast")
    WoWHACv4:RegisterEvent("UNIT_SPELLCAST_START", "OnSpellcast")
    WoWHACv4:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "OnSpellcast")
end
local lastCastId
local lastCast
function WoWHACv4:OnSpellcast(event, unit, _, _, spellId)
    if unit == "player" then
        WoWHACv4.pixel:SetColor(0, 0, 0)
    end
    if event == "UNIT_SPELLCAST_SENT" then
        lastCastId = spellId
        lastCast = tuple:GetFirst()
    end
end

function WoWHACv4:UpdatePixel()
    local casting = UnitCastingInfo("player") ~= nil
    if casting or IsChanneling(300) or IsGCDActive(300) then
        WoWHACv4.pixel:SetColor(0, 0, 0)
        if lastCastId == tupleId:GetFirst() then
            local second = tuple:GetSecond()
            if second then
                tuple:SetFirst(second)
                tupleId:SetFirst(tupleId:GetSecond())
            end
        end
    else
        local rgb = tuple:GetFirst()
        if rgb == nil or rgb.green == 0 then
            tuple:SetFirst(WoWHACv4.Steganography(WoWHACv4.CURRENT_PROVIDER:GetCurrent()))
        else
            WoWHACv4.pixel:SetColor(rgb.red, rgb.green, rgb.blue)
        end
    end
end

WoWHACv4:ScheduleRepeatingTimer("UpdatePixel", 0.06)