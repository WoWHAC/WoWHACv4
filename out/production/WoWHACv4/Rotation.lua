local _, WoWHACv4 = ...

local queue = Queue()

WoWHACv4:RegisterMessage("WOWHACV4_UPDATE_HOTKEY", function(_, keybind)
    if keybind then
        WoWHACv4:Debug("Presumed hot key: " .. keybind)
    end
    local steganography = WoWHACv4.Steganography(keybind)
    queue:overwriteFirst(steganography)
end)

WoWHACv4:RegisterMessage("WOWHACV4_NEXT_HOTKEY", function(_, keybind)
    local steganography = WoWHACv4.Steganography(keybind)
    queue:push(steganography)
end)

local function IsGCDActive()
    local cd = C_Spell.GetSpellCooldown(61304)
    return cd.startTime > 0 and ((cd.startTime + cd.duration) - GetTime()) * 1000 > 150
end

local function IsChanneling()
    local _, _, _, _, endTimeMS = UnitChannelInfo("player")
    if not endTimeMS then
        _, _, _, _, endTimeMS = UnitCastingInfo("player")
    end

    if endTimeMS then
        return (endTimeMS - GetTime() * 1000) >= 150
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
local locked = false;
function WoWHACv4:OnSpellcast(event, unit)
    if unit == "player" then
        WoWHACv4.pixel:SetColor(0, 0, 0)
    end
    if event == "UNIT_SPELLCAST_SENT" then
        locked = false;
    end
end

function WoWHACv4:UpdatePixel()
    --local casting = UnitCastingInfo("player") ~= nil
    local channeling = IsChanneling()
    local gcdActive = IsGCDActive()
    if casting or channeling or gcdActive then
        WoWHACv4.pixel:SetColor(0, 0, 0)
        queue:pop()
    else
        local rgb = queue:peek()
        WoWHACv4.pixel:SetColor(rgb.red, green, blue)
    end
end

WoWHACv4:ScheduleRepeatingTimer("UpdatePixel", 0.1)