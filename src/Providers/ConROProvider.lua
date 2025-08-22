local _, WoWHACv5 = ...

local Base = WoWHACv5.Provider

-- Класс ConROProvider без 30log
local ConROProvider = {}
ConROProvider.__index = ConROProvider

-- Позволяем вызывать как конструктор: ConROProvider()
setmetatable(ConROProvider, {
    __index = Base,
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then self:init(...) end
        return self
    end
})

function ConROProvider:init()
    WoWHACv5:Log("Supplier found: ConRO.")

    -- Пер-экземплярное состояние
    self.currentId     = nil
    self.currentHotkey = nil
    self.nextId        = nil
    self.nextHotkey    = nil

    -- Основной хоткей/ид
    if ConROWindow and ConROWindow.fontkey then
        local Keybind = ConROWindow.fontkey
        local last = Keybind:GetText()
        WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
            if txt ~= last then
                last = txt
                self.currentId     = ConRO.Spell
                self.currentHotkey = txt
            end
        end)
    end

    -- Следующий хоткей/ид (вторая иконка)
    if ConROWindow2 and ConROWindow2.fontkey then
        local Keybind = ConROWindow2.fontkey
        local last = Keybind:GetText()
        WoWHACv5:SecureHook(Keybind, "SetText", function(_, txt)
            if txt ~= last then
                last = txt
                self.nextId     = ConRO.SuggestedSpells and ConRO.SuggestedSpells[2] or nil
                self.nextHotkey = txt
            end
        end)
    end
end

-- API
function ConROProvider:GetCurrentHotKey()
    return self.currentHotkey
end

function ConROProvider:SetCurrentHotKey(hotkey)
    self.currentHotkey = hotkey
end

function ConROProvider:SetCurrentId(spellId)
    self.currentId = spellId
end

function ConROProvider:GetCurrentId()
    return self.currentId
end

function ConROProvider:GetNextHotKey()
    return self.nextHotkey
end

function ConROProvider:GetNextId()
    return self.nextId
end

WoWHACv5.providers = WoWHACv5.providers or {}
WoWHACv5.providers["ConRO"] = ConROProvider
