local _, WoWHACv5 = ...

local PixelFrame = {}
PixelFrame.__index = PixelFrame

function PixelFrame:new()
    local self = setmetatable({}, PixelFrame)

    WoWHACv5:Debug("Creating pixel frame at top-left corner")
    self.frame = CreateFrame("Frame", "PixelFrame", UIParent)
    self.frame.back = self.frame:CreateTexture(nil, "BACKGROUND", nil, -1)
    self.legacy = not self.frame.back.SetColorTexture
    self:SetSize(2, 2)
    self.frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",
            self.legacy and -1 or 0,
            self.legacy and 1 or 0
    )
    self.frame:SetFrameStrata("TOOLTIP")
    self.frame.back:SetAllPoints(self.frame)
    self:SetColor(0, 0, 0)
    return self
end

function PixelFrame:SetSize(x, y)
    self.frame:SetSize(x, y)
end
local previousR, previousG, previousB = 0, 0, 0
function PixelFrame:SetColor(r, g, b)
    local result = false
    if r ~= previousR or g ~= previousG or b ~= previousB then
        if r == nil then
            r = 0
        end
        if g == nil then
            g = 0
        end
        if b == nil then
            b = 0
        end
        WoWHACv5:Debug("Change pixel color to R: " .. r .. " G: " .. g .. " B: " .. b)
        result = true
    end
    previousR, previousG, previousB = r, g, b
    if self.legacy then
        self.frame.back:SetTexture(r, g, b)
    else
        self.frame.back:SetColorTexture(r, g, b)
    end
    return result
end

WoWHACv5.pixel = PixelFrame:new()