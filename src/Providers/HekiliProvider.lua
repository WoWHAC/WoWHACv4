local _, WoWHACv5 = ...

-- Наследуемся от базового Provider без 30log
-- Предполагается, что WoWHACv5.Provider — это класс на метатаблицах (как в вашей версии без 30log).
local HekiliProvider = setmetatable({}, { __index = WoWHACv5.Provider })
HekiliProvider.__index = HekiliProvider

-- Делаем класс вызываемым: HekiliProvider()
setmetatable(HekiliProvider, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        if self.init then self:init(...) end
        return self
    end
})

function HekiliProvider:init()
    -- Пер-инстанс состояние
    self.currentId     = nil
    self.currentHotkey = nil
    self.nextId        = nil
    self.nextHotkey    = nil

    WoWHACv5:Log("Supplier found: Hekili.")

    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, display, spellId, _, _, arg5)
                if event == "HEKILI_RECOMMENDATION_UPDATE" and arg5 then
                    -- ВАЖНО: не используем имя 'next' (конфликт с встроенной функцией next).
                    local nextRec = arg5[2]
                    if nextRec then
                        local keybind = nextRec.keybind
                        if keybind ~= self.nextHotkey then
                            self.nextHotkey = keybind
                            self.nextId     = nextRec.actionID
                        end
                    end

                    local currentRec = arg5[1]
                    if currentRec then
                        local keybind = currentRec.keybind
                        -- Не перезаписываем текущую, если это та же клавиша, что и у next
                        if keybind ~= self.currentHotkey and keybind ~= self.nextHotkey then
                            self.currentHotkey = keybind
                            -- Логичнее брать из currentRec.actionID; если его нет, fallback на spellId из события
                            self.currentId     = currentRec.actionID or spellId
                        end
                    end
                end
            end)
        else
            WoWHACv5:Log("To use the Hekili as rotation, you need to install WeakAuras.")
        end
    end)
end

-- API
function HekiliProvider:GetCurrentHotKey()
    return self.currentHotkey
end

function HekiliProvider:SetCurrentHotKey(hotkey)
    self.currentHotkey = hotkey
end

function HekiliProvider:SetCurrentId(spellId)
    self.currentId = spellId
end

function HekiliProvider:GetCurrentId()
    return self.currentId
end

function HekiliProvider:GetNextHotKey()
    return self.nextHotkey
end

function HekiliProvider:GetNextId()
    return self.nextId
end

WoWHACv5.providers = WoWHACv5.providers or {}
WoWHACv5.providers["Hekili"] = HekiliProvider
