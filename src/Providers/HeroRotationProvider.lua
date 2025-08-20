local _, WoWHACv4 = ...

local HeroRotationProvider = WoWHACv4.Provider:extend("HeroRotationProvider")

function HeroRotationProvider:init()
    WoWHACv4:Log("Supplier found: HeroRotation.")
    local Keybind = HeroRotation.MainIconFrame.Keybind
    local last = Keybind:GetText()
    WoWHACv4:SecureHook(Keybind, "SetText", function(_, txt)
        local burst = HeroRotation.SmallIconFrame.Icon[1].Keybind
        if burst and burst:IsVisible() then
            local burstHotkey = burst:GetText()
            if burstHotkey and burstHotkey ~= "" then
                txt = burstHotkey
            end
        end
        if txt ~= last then
            last = txt
            self:Fire(txt)
        end
    end)
end

WoWHACv4.providers["HeroRotation"] = HeroRotationProvider