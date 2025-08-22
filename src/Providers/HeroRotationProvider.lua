local _, WoWHACv5 = ...

local Base = WoWHACv5.Provider

-- Класс HeroRotationProvider без 30log
local HeroRotationProvider = {}
HeroRotationProvider.__index = HeroRotationProvider

setmetatable(HeroRotationProvider, {
    __index = Base,
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then self:init(...) end
        return self
    end
})

function HeroRotationProvider:init()
    WoWHACv5:Log("Supplier found: HeroRotation.")
    self.currentHotkey = nil

    local Keybind = HeroRotation.MainIconFrame.Keybind
    local last = Keybind:GetText()

    WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
        -- Правый рекомендуемый
        local rightSuggest = HeroRotation.RightSuggestedIconFrame and HeroRotation.RightSuggestedIconFrame.Keybind
        if rightSuggest and rightSuggest:IsVisible() then
            local suggestedHotkey = rightSuggest:GetText()
            if suggestedHotkey and suggestedHotkey ~= "" then
                self.currentHotkey = suggestedHotkey
                return
            end
        end

        -- Центральный рекомендуемый
        local suggested = HeroRotation.SuggestedIconFrame and HeroRotation.SuggestedIconFrame.Keybind
        if suggested and suggested:IsVisible() then
            local suggestedHotkey = suggested:GetText()
            if suggestedHotkey and suggestedHotkey ~= "" then
                self.currentHotkey = suggestedHotkey
                return
            end
        end

        -- Малый (burst)
        local burst = HeroRotation.SmallIconFrame
                and HeroRotation.SmallIconFrame.Icon
                and HeroRotation.SmallIconFrame.Icon[1]
                and HeroRotation.SmallIconFrame.Icon[1].Keybind
        if burst and burst:IsVisible() then
            local burstHotkey = burst:GetText()
            if burstHotkey and burstHotkey ~= "" then
                self.currentHotkey = burstHotkey
                return
            end
        end

        if txt ~= last then
            self.currentHotkey = txt
        end
    end)
end

function HeroRotationProvider:GetCurrentHotKey()
    return self.currentHotkey
end

function HeroRotationProvider:GetCurrentId()
    return 0
end

WoWHACv5.providers = WoWHACv5.providers or {}
WoWHACv5.providers["HeroRotation"] = HeroRotationProvider
