local _, WoWHACv4 = ...

local red, green, blue = 0, 0, 0

WoWHACv4:RegisterMessage("WOWHACV4_UPDATE_HOTKEY", function(_, keybind)
    if keybind then
        WoWHACv4:Debug("Presumed hot key: " .. keybind)
    end
    local steganography = WoWHACv4.Steganography(keybind)
    red = steganography.red
    green = steganography.green
    blue = steganography.blue
end)

local function IsGCDActive()
    local cd = C_Spell.GetSpellCooldown(61304)
    return cd.startTime > 0 and (cd.startTime + cd.duration > GetTime())
end

function WoWHACv4:UpdatePixel()
    local casting = UnitCastingInfo("player") ~= nil
    local channeling = UnitChannelInfo("player") ~= nil
    local gcdActive = IsGCDActive()
    if casting or channeling or gcdActive then
        WoWHACv4.pixel:SetColor(0, 0, 0)
    else
        WoWHACv4.pixel:SetColor(red, green, blue)
    end
end

WoWHACv4:ScheduleRepeatingTimer("UpdatePixel", 0.1)