local _, WoWHACv5 = ...

local Base = WoWHACv5.Provider

-- Класс MaxDpsProvider без 30log
local MaxDpsProvider = {}
MaxDpsProvider.__index = MaxDpsProvider

-- Вызываемый конструктор с корректным fallback к Base для инстансов
setmetatable(MaxDpsProvider, {
    __index = Base,
    __call = function(cls, ...)
        local self = setmetatable({}, {
            __index = function(_, k)
                local v = MaxDpsProvider[k]
                if v ~= nil then return v end
                return Base and Base[k] or nil
            end
        })
        if self.init then self:init(...) end
        return self
    end
})

function MaxDpsProvider:init()
    WoWHACv5:Log("Supplier found: MaxDps.")
    self.currentHotkey = nil

    WoWHACv5:RegisterMessage("WOWHACV4_WA_PRESENTS", function(_, _, isLoaded)
        if isLoaded then
            WoWHACv5.ToggleBurstFrame:Show()
            WoWHACv5:SecureHook(WeakAuras, "ScanEvents", function(event, _)
                if event == "MAXDPS_COOLDOWN_UPDATE" then
                    for _, frame in pairs(MaxDps.Frames) do
                        if frame and frame:IsVisible() then
                            if WoWHACv5.burst or frame.ovType ~= "cooldown" then
                                local button = frame:GetParent()
                                -- как в оригинале: берём текст хоткея у кнопки
                                self.currentHotkey = button.HotKey:GetText()
                                return
                            end
                        end
                    end
                    return
                end
            end)
        else
            WoWHACv5:Log("To use the MaxDps as rotation provider, you need to install WeakAuras.")
        end
    end)
end

function MaxDpsProvider:GetCurrentHotKey()
    return self.currentHotkey
end

function MaxDpsProvider:GetCurrentId()
    return 0
end

WoWHACv5.providers = WoWHACv5.providers or {}
WoWHACv5.providers["MaxDps"] = MaxDpsProvider
