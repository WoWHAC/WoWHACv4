local _, WoWHACv5 = ...

local redMap = {
    [7] = 70,
    [3] = 60,
    [5] = 50,
    [1] = 40,
    [6] = 30,
    [2] = 20,
    [4] = 10,
}

local function _CalculateRed(keyBind)
    if not keyBind then
        return 0
    end
    local modifiers = 0
    if keyBind:match("ALT") then
        modifiers = modifiers + 1
    end
    if keyBind:match("CTRL") then
        modifiers = modifiers + 2
    end
    if keyBind:match("SHIFT") then
        modifiers = modifiers + 4
    end
    return (redMap[modifiers] or 0) / 255
end

--========================================================
-- KeyCode Reference Table
--========================================================
-- (таблица соответствий оставлена без изменений)
--========================================================
local function _CalculateGreen(keyBind)
    if not keyBind then
        return 0
    end

    keyBind = keyBind:gsub("ALT%-?", ""):gsub("CTRL%-?", ""):gsub("SHIFT%-?", "")
    if keyBind:len() == 1 then
        return keyBind:byte() / 255
    end

    local fNum = keyBind:match("^F(%d+)$")
    if fNum then
        fNum = tonumber(fNum)
        if fNum >= 1 and fNum <= 12 then
            return (148 + fNum) / 255
        end
    end

    return 0
end

--========================================
-- Steganography без 30log
--========================================
local Steganography = {}
Steganography.__index = Steganography

setmetatable(Steganography, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then self:init(...) end
        return self
    end
})

function Steganography:init(keybind)
    if keybind then
        keybind = WoWHACv5:NormalizeModifiers(keybind)
    end
    self.keybind = keybind
    self.red   = _CalculateRed(keybind)
    self.green = _CalculateGreen(keybind)
    self.blue  = self.red
end

WoWHACv5.Steganography = Steganography
