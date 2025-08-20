local _, WoWHACv4 = ...

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
-- Row 1 (digits and symbols)
-- ` = 96      1 = 49     2 = 50     3 = 51     4 = 52
-- 5 = 53      6 = 54     7 = 55     8 = 56     9 = 57
-- 0 = 48      - = 45     = = 61
--
-- Row 2 (QWERTY row)
-- Q = 81      W = 87     E = 69     R = 82     T = 84
-- Y = 89      U = 85     I = 73     O = 79     P = 80
-- [ = 91      ] = 93
--
-- Row 3 (ASDF row)
-- A = 65      S = 83     D = 68     F = 70     G = 71
-- H = 72      J = 74     K = 75     L = 76     ; = 59
-- ' = 39
--
-- Row 4 (ZXCV row)
-- Z = 90      X = 88     C = 67     V = 86     B = 66
-- N = 78      M = 77     , = 44     . = 46     / = 47
--
-- Function keys
-- F1  = 149   F2  = 150   F3  = 151   F4  = 152
-- F5  = 153   F6  = 154   F7  = 155   F8  = 156
-- F9  = 157   F10 = 158   F11 = 159   F12 = 160
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

local Steganography = class("Steganography")
function Steganography:init(keybind)
    keybind = WoWHACv4:NormalizeModifiers(keybind)
    self.red = _CalculateRed(keybind);
    self.green = _CalculateGreen(keybind)
    self.blue = self.red;
end
WoWHACv4.Steganography = Steganography