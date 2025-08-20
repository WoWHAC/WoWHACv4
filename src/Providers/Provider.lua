local _, WoWHACv4 = ...

local Provider = class("Provider")

function Provider:init()
    WoWHACv4:Log("No rotation suppliers found. A list of available suppliers can be found at https://wowhac.fun/")
end

--function Provider:Fire(keybind, spellId)
--    WoWHACv4:SendMessage("WOWHACV4_UPDATE_HOTKEY", keybind, spellId)
--end
--
--function Provider:FireNext(keybind, spellId)
--    WoWHACv4:SendMessage("WOWHACV4_NEXT_HOTKEY", keybind, spellId)
--end

function Provider:GetCurrentHotKey()
    return nil
end

function Provider:GetCurrentId()
    return nil
end

function Provider:GetNextHotKey()
    return nil
end

function Provider:GetNextId()
    return nil
end

WoWHACv4.Provider = Provider