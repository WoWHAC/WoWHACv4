local _, WoWHACv5 = ...

local ToggleBurstFrame = {}
ToggleBurstFrame.__index = ToggleBurstFrame

function ToggleBurstFrame:new()
    local self = setmetatable({}, ToggleBurstFrame)
    WoWHACv5.burst = false
    local parent = (PARENT_NAME and _G[PARENT_NAME]) or UIParent
    local button = CreateFrame("Button", "WoWHACv5ToggleBurstFrame", parent, "UIPanelButtonTemplate")
    button:SetSize(40, 20)
    button:SetText("CDs")
    button:SetPoint("CENTER")
    button:SetClampedToScreen(true)
    button:SetMovable(true)
    button:EnableMouse(true)
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", button.StartMoving)
    button:SetScript("OnDragStop", button.StopMovingOrSizing)
    local fontString = button.Text or button:GetFontString()
    fontString:SetTextColor(1, 0, 0)
    button:SetScript("OnClick", function()
        WoWHACv5.burst = not WoWHACv5.burst
        if WoWHACv5.burst then
            fontString:SetTextColor(0, 1, 0)
        else
            fontString:SetTextColor(1, 0, 0)
        end
    end)
    self.btn = button
    self:Hide()
    return self
end

function ToggleBurstFrame:Show()
    self.btn:Show()
end

function ToggleBurstFrame:Hide()
    self.btn:Hide()
end

WoWHACv5.ToggleBurstFrame = ToggleBurstFrame:new()