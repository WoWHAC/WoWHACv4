--- ============================ HEADER ============================
-- Addon
local addonName, WoWHACv5 = ...
local tostring = tostring
--- ============================ CONTENT ============================
WoWHACv5.ToggleHekiliFrame = CreateFrame("Frame", "WoWHACv5_ToggleHekiliFrame", UIParent)

function WoWHACv5.ToggleHekiliFrame:Init()
    if self.Button then
        return
    end
    -- Frame Init
    self:SetPoint("CENTER")
    self:SetClampedToScreen(true)
    self:SetMovable(true)
    self:EnableMouse(true)

    self:SetWidth(150)
    self:SetHeight(20)

    self:Show()

    -- Button Creation
    self.Button = {}
    self:AddButton("cooldowns", "C", "Toggle Major Cooldowns")
    self:AddButton("essences", "E", "Toggle Minor Cooldowns")
    self:AddButton("interrupts", "I", "Toggle Interrupts")
    self:AddButton("defensives", "D", "Toggle Defensives")
    self:AddButton("potions", "P", "Toggle Potions")
    self:AddButton("custom1", "1", "Toggle " .. Hekili.DB.profile.toggles.custom1.name)
    self:AddButton("custom2", "2", "Toggle " ..  Hekili.DB.profile.toggles.custom2.name)
end
local index = 0;
-- Add a button
function WoWHACv5.ToggleHekiliFrame:AddButton (Toggle, Text, Tooltip)
    local ButtonFrame = CreateFrame("Button", "$parentButton" .. tostring(Toggle), self)
    local constIndex = index + 1;
    index = constIndex
    ButtonFrame:SetWidth(20)
    ButtonFrame:SetHeight(20)
    ButtonFrame:SetPoint("LEFT", self, "LEFT", 20 * (constIndex - 1) + constIndex, 0)

    -- Button Tooltip (Optional)
    if Tooltip then
        ButtonFrame:SetScript("OnEnter",
                function()
                    Mixin(GameTooltip, BackdropTemplateMixin)
                    GameTooltip:SetOwner(WoWHACv5.ToggleHekiliFrame, "ANCHOR_BOTTOM", 0, 0)
                    GameTooltip:ClearLines()
                    GameTooltip:SetBackdropColor(0, 0, 0, 1)
                    GameTooltip:SetText(Tooltip, nil, nil, nil, 1, true)
                    GameTooltip:Show()
                end
        )
        ButtonFrame:SetScript("OnLeave",
                function()
                    GameTooltip:Hide()
                end
        )
    end
    -- Button Text
    ButtonFrame:SetNormalFontObject("GameFontNormalSmall")
    ButtonFrame.text = Text
    -- Button Texture
    local NormalTexture = ButtonFrame:CreateTexture()
    NormalTexture:SetTexture("Interface/Buttons/UI-Silver-Button-Up")
    NormalTexture:SetTexCoord(0, 0.625, 0, 0.7875)
    NormalTexture:SetAllPoints()
    ButtonFrame:SetNormalTexture(NormalTexture)
    local HighlightTexture = ButtonFrame:CreateTexture()
    HighlightTexture:SetTexture("Interface/Buttons/UI-Silver-Button-Highlight")
    HighlightTexture:SetTexCoord(0, 0.625, 0, 0.7875)
    HighlightTexture:SetAllPoints()
    ButtonFrame:SetHighlightTexture(HighlightTexture)
    local PushedTexture = ButtonFrame:CreateTexture()
    PushedTexture:SetTexture("Interface/Buttons/UI-Silver-Button-Down")
    PushedTexture:SetTexCoord(0, 0.625, 0, 0.7875)
    PushedTexture:SetAllPoints()
    ButtonFrame:SetPushedTexture(PushedTexture)

    ButtonFrame:SetScript("OnMouseDown",
            function(self, Button)
                if Button == "LeftButton" then
                    Hekili:FireToggle(Toggle)
                    WoWHACv5.ToggleHekiliFrame:UpdateButtonText(Toggle)
                end
                if Button == "RightButton" then
                    WoWHACv5.ToggleHekiliFrame:StartMoving()
                end
            end
    )
    ButtonFrame:SetScript("OnMouseUp",
            function(self, Button)
                if Button == "RightButton" then
                    WoWHACv5.ToggleHekiliFrame:StopMovingOrSizing()
                end
            end
    )

    self.Button[Toggle] = ButtonFrame

    WoWHACv5.ToggleHekiliFrame:UpdateButtonText(Toggle)

    ButtonFrame:Show()
end

-- Update a button text
function WoWHACv5.ToggleHekiliFrame:UpdateButtonText (i)
    if Hekili.DB.profile.toggles[i].value then
        self.Button[i]:SetFormattedText("|cff00ff00%s|r", self.Button[i].text)
    else
        self.Button[i]:SetFormattedText("|cffff0000%s|r", self.Button[i].text)
    end
end