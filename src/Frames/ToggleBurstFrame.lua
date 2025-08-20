local _, WoWHACv4 = ...

local ToggleBurstFrame = class("ToggleBurstFrame")

function ToggleBurstFrame:init()
    WoWHACv4.burst = false;
    local parent = (PARENT_NAME and _G[PARENT_NAME]) or UIParent
    local button = CreateFrame("Button", "WoWHACv4ToggleBurstFrame", parent, "UIPanelButtonTemplate")
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
        WoWHACv4.burst = not WoWHACv4.burst
        if WoWHACv4.burst then
            fontString:SetTextColor(0, 1, 0)
        else
            fontString:SetTextColor(1, 0, 0)
        end
    end)
    self.btn = button
    self:Hide()
end

function ToggleBurstFrame:Show()
    self.btn:Show()
end

function ToggleBurstFrame:Hide()
    self.btn:Hide()
end

WoWHACv4.ToggleBurstFrame = ToggleBurstFrame()