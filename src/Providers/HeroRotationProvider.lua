local _, WoWHACv5 = ...

local HeroRotationProvider = WoWHACv5.Provider:extend("HeroRotationProvider")

local currentHotkey;
function HeroRotationProvider:init()
    WoWHACv5:Log("Supplier found: HeroRotation.")
    local Keybind = HeroRotation.MainIconFrame.Keybind
    local last = Keybind:GetText()
    WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
        local rightSuggest = HeroRotation.RightSuggestedIconFrame.Keybind
        if rightSuggest and rightSuggest:IsVisible() then
            local suggestedHotkey = rightSuggest:GetText()
            if suggestedHotkey and suggestedHotkey ~= "" then
                currentHotkey = suggestedHotkey
                return
            end
        end
        local suggested = HeroRotation.SuggestedIconFrame.Keybind
        if suggested and suggested:IsVisible() then
            local suggestedHotkey = suggested:GetText()
            if suggestedHotkey and suggestedHotkey ~= "" then
                currentHotkey = suggestedHotkey
                return
            end
        end
        local burst = HeroRotation.SmallIconFrame.Icon[1].Keybind
        if burst and burst:IsVisible() then
            local burstHotkey = burst:GetText()
            if burstHotkey and burstHotkey ~= "" then
                currentHotkey = burstHotkey
                return
            end
        end
        if txt ~= last then
            currentHotkey = txt
        end
    end)
end

function HeroRotationProvider:GetCurrentHotKey()
    return currentHotkey
end

function HeroRotationProvider:GetCurrentId()
    return 0
end

WoWHACv5.providers["HeroRotation"] = HeroRotationProvider