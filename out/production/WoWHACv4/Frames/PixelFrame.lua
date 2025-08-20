local _, WoWHACv4 = ...

local PixelFrame = class("PixelFrame")

function PixelFrame:init()
    WoWHACv4:Debug("Creating pixel frame at top-left corner")
    self.frame = CreateFrame("Frame", "PixelFrame", UIParent)
    self.frame.back = self.frame:CreateTexture(nil, "BACKGROUND", nil, -1)
    self.legacy = not self.frame.back.SetColorTexture
    self:SetSize(2, 2)
    self.frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.legacy and -1 or 0, self.legacy and 1 or 0)
    self.frame:SetFrameStrata("TOOLTIP")
    self.frame.back:SetAllPoints(self.frame)
    self:SetColor(0, 0, 0)
end

function PixelFrame:SetSize(x, y)
    self.frame:SetSize(x, y)
end
local previousR = 0
local previousG = 0
local previousB = 0
function PixelFrame:SetColor(r, g, b)
    if r ~= previousR or g ~= previousG or b ~= previousB then
        WoWHACv4:Debug("Change pixel color to R: " .. r .. " G: " .. g .. " B: " .. b)
    end
    previousR = r
    previousG = g
    previousB = b
    if self.legacy then
        self.frame.back:SetTexture(r, g, b)
    else
        self.frame.back:SetColorTexture(r, g, b)
    end
end

WoWHACv4.pixel = PixelFrame()