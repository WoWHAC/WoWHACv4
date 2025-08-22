local _, WoWHACv5 = ...

local HeroRotationProvider = setmetatable({}, { __index = WoWHACv5.Provider })
HeroRotationProvider.__index = HeroRotationProvider

local currentHotkey

function HeroRotationProvider:new()
    local self = setmetatable(WoWHACv5.Provider:new(), HeroRotationProvider)

    WoWHACv5:Log("Supplier found: HeroRotation.")

    local Keybind = HeroRotation.MainIconFrame.Keybind
    if not Keybind then
        WoWHACv5:Log("HeroRotation MainIconFrame.Keybind not found.")
        return self
    end

    local last = Keybind:GetText() or ""
    WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
        local rightSuggest = HeroRotation.RightSuggestedIconFrame and HeroRotation.RightSuggestedIconFrame.Keybind
        if rightSuggest and rightSuggest:IsVisible() then
            local suggestedHotkey = rightSuggest:GetText()
            if suggestedHotkey and suggestedHotkey ~= "" then
                currentHotkey = suggestedHotkey
                return
            end
        end
        local suggested = HeroRotation.SuggestedIconFrame and HeroRotation.SuggestedIconFrame.Keybind
        if suggested and suggested:IsVisible() then
            local suggestedHotkey = suggested:GetText()
            if suggestedHotkey and suggestedHotkey ~= "" then
                currentHotkey = suggestedHotkey
                return
            end
        end
        local burst = HeroRotation.SmallIconFrame and HeroRotation.SmallIconFrame.Icon and HeroRotation.SmallIconFrame.Icon[1] and HeroRotation.SmallIconFrame.Icon[1].Keybind
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
    return self
end

function HeroRotationProvider:GetCurrentHotKey()
    return currentHotkey
end

function HeroRotationProvider:GetCurrentId()
    return 0
end

function HeroRotationProvider:SetCurrentHotKey(hotkey)
end

function HeroRotationProvider:SetCurrentId(spellId)
end

function HeroRotationProvider:GetNextHotKey()
    return nil
end

function HeroRotationProvider:GetNextId()
    return nil
end

WoWHACv5.providers["HeroRotation"] = HeroRotationProvider.new
