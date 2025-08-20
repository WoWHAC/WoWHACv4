local _, WoWHACv4 = ...

local Provider = class("Provider")

function Provider:init()
    self.available = false
    WoWHACv4:Log("No rotation suppliers found. A list of available suppliers can be found at https://wowhac.fun/")
end

function Provider:Fire(keybind)
    WoWHACv4:SendMessage("WOWHACV4_UPDATE_HOTKEY", keybind)
end

WoWHACv4.Provider = Provider